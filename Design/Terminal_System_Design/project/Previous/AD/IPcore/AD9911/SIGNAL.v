/*

requset: 
    FREQW
    FREQW_UPDATE
    CODE
    CODE_LEN
    PULSE_LEN
    
ouput:
    FREQW_UPDATE_OVER
    GEN_OVER


*/



module SIGNAL #(parameter CODE_DURATION = 256-1)(
    input     wire              CLOCK_10M,
    input     wire              RESET_N,

    input     wire              RF_OUTPUT_EN,
    input     wire              GEN,
    output    reg               GEN_OVER,  
    input     wire   [31:0]     FREQW,
    input     wire              FREQW_UPDATE,
    output    wire              FREQW_UPDATE_OVER,
    input     wire   [31:0]     CODE,
    input     wire   [ 7:0]     CODE_LEN,
    input     wire   [15:0]     PULSE_LEN,

    output    wire              LO_CS,  
    output    wire              LO_PD,  
    output    wire              LO_UPDATE,
    output    reg               LO_MRSET,
    output    wire              LO_SCLK,
    output    wire   [ 3:0]     LO_SDIO,
    output    wire   [ 3:0]     LO_P,


    output    wire              RF_CS,  
    output    wire              RF_PD,  
    output    wire              RF_UPDATE,
    output    reg               RF_MRSET,
    output    wire              RF_SCLK,
    output    wire   [ 3:0]     RF_SDIO,
    output    wire   [ 3:0]     RF_P
    );
    
    reg    MA = 0;
    reg    MP = 0;
    wire   RF_FREQW_UPDATE_OVER;
    wire   LO_FREQW_UPDATE_OVER;
    
    assign LO_PD = 0;
    assign RF_PD = 0;
    
    assign RF_P[1] = MP;
    assign RF_P[3] = RF_OUTPUT_EN & MA;

    assign LO_P[1] = 0;
    assign LO_P[3] = 1;

    assign FREQW_UPDATE_OVER = RF_FREQW_UPDATE_OVER & LO_FREQW_UPDATE_OVER;



/*
*
*       XXX_LEN  : number/length
*       XXX_WIDE : duration
*
*
*       <------------------------------------ PULSE_LEN --------------------------------------->
*       <-------- CODE_LEN ---------><---------------------- BLANK_LEN ------------------------>
*       ┌─────┬─────┬─────┬─────────┐ 
*       │  1  │  0  │ ... │   CODE  │ 
*   ────┴─────┴─────┴─────┴─────────┴───────────────────────────────────────────────────────────
*       <-- -->
*          | CODE_DURATION = 25.6us = 256T (10MHZ) = 1/FSR
*
*
*       PULSE_LEN  = CODE_LEN(16) + BLANK_LEN(320-16) = 320
*       PULSE_WIDE = PULSE_LEN(320) * CODE_DURATION(25.6us) = 8.192ms
*
*
*/

    // gray-code
    localparam S0 = 2'b00;
    localparam S1 = 2'b01;
    localparam S2 = 2'b11;
    localparam S3 = 2'b10;
    reg   [ 1:0]    STATE = 0;

    reg   [31:0]    CODE_reg; //  2-level modulation : 1 or 0
    reg   [ 7:0]    CODE_LEN_reg = 0;
    reg   [15:0]    PULSE_LEN_reg = 0;
    reg   [15:0]    INDEX = 0;

   
    reg   [15:0]    COUNT = 1;

    initial begin
        LO_MRSET <= 1;
        RF_MRSET <= 1;
        GEN_OVER <= 1;
    end

/*
*                                               ┌──┐                                                                                ┌──┐  
*    input                                      │  │                                                                                │  │  
*    FREQW_UPDATE          ─────────────────────┘  └────────────────────────────────────────────────────────────────────────────────┘  └──
*
*
*                          ┌─────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
*    input                 │                  FREQW                                                                                      │
*    FREQW                 └─────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*
*                          ────────────────────────┐                          ┌────────────────────────────────────────────────────────┐ 
*    output                                        │     updating             │ keep high level until FREQW_UPDATE pulse arrives again │  
*    FREQW_UPDATE_OVER                             └──────────────────────────┘                                                        └──
*
*
*******************************************************************************************************************************************
*
*                                  ┌─┐                                                                                       ┌─┐   
*    input                         │ │                                                                                       │ │   
*    GEN        ───────────────────┘ └───────────────────────────────────────────────────────────────────────────────────────┘ └──────────
*
*                                    ┌───────┐                                                                                 ┌───────┐               
*    output                          │       │                                                                                 │       │               
*    MA         ─────────────────────┘       └─────────────────────────────────────────────────────────────────────────────────┘       └──
*
*                                    ┌─┬─┬───┐                                                                                 ┌─┬─┬───┐               
*    output                          │0│1│...│                                                                                 │0│1│...│               
*    MP         ─────────────────────┴─┴─┴───┴─────────────────────────────────────────────────────────────────────────────────┴─┴─┴───┴──
*
*               ─────────────────────┐                                        ┌────────────────────────────────────────────────┐                                    
*    output                          │        keep low until gen over         │ keep high level until GEN pulse arrives again  │                                   
*    GEN_OVER                        └────────────────────────────────────────┘                                                └──────────
*/

    always @(posedge CLOCK_10M or negedge RESET_N) begin
        if (!RESET_N) begin
            LO_MRSET <= 1;
            RF_MRSET <= 1;
            MA <= 0;
            STATE <= S0;
        end else begin
            case (STATE)
                S0  :begin
                        MA <= 0;
                        LO_MRSET <= 0;
                        RF_MRSET <= 0;
                        GEN_OVER <= 1;
                        STATE <= S1;
                    end

                S1  :begin
                        if (GEN) begin
                            CODE_reg <= CODE;
                            CODE_LEN_reg <= CODE_LEN;
                            PULSE_LEN_reg <= PULSE_LEN;
                            GEN_OVER <= 0;
                            INDEX <= 0;
                            STATE <= S2;
                        end
                    end
                S2  :begin
                        if (INDEX < CODE_LEN_reg) begin
                            MP <= CODE_reg[INDEX];
                            MA <= 1;
                            STATE <= S3;
                        end else if (INDEX < PULSE_LEN_reg) begin
                            MA <= 0;
                            STATE <= S3;
                        end else begin
                            MA <= 0;
                            STATE <= S0;
                        end
                        COUNT <= 1;
                    end
                S3  :begin // FSR delay
                        if (COUNT < CODE_DURATION) begin  //255 : COUNT_LEN 25.6us
                            COUNT <= COUNT+1;
                        end else begin
                            INDEX <= INDEX+1;
                            STATE <= S2;
                        end
                    end
                default: STATE <= S0;
            endcase
        end
    end




    wire [ 7:0] LO_ADDR;
    wire [ 7:0] RF_ADDR;
    wire [31:0] LO_DATA;
    wire [31:0] RF_DATA;


    AD9911_FREQW_UPDATE #(
	    .start_freqw(370440929)// 41.4MHZ
    ) 
	AD9911_FREQW_UPDATE_LO(
        .CLK                (CLOCK_10M),
        .RESET_N            (RESET_N),
        .OVER               (LO_OVER),
        .FREQW              (FREQW),
        .FREQW_UPDATE       (FREQW_UPDATE),

        .FREQW_UPDATE_OVER  (LO_FREQW_UPDATE_OVER),
        .TR                 (LO_TR),
        .ADDR               (LO_ADDR[7:0]),
        .DATA               (LO_DATA[31:0])
    );
    
    AD9911_FREQW_UPDATE #(
	    .start_freqw(0)
	) 
	AD9911_FREQW_UPDATE_RF(
        .CLK                (CLOCK_10M),
        .RESET_N            (RESET_N),
        .OVER               (RF_OVER),
        .FREQW              (FREQW),
        .FREQW_UPDATE       (FREQW_UPDATE),

        .FREQW_UPDATE_OVER  (RF_FREQW_UPDATE_OVER),
        .TR                 (RF_TR),
        .ADDR               (RF_ADDR[7:0]),
        .DATA               (RF_DATA[31:0])
    );
    


    AD9911_DATA_ACCESS AD9911_SPI_LO(
        .CLK         (CLOCK_10M),
        .RESET_N     (RESET_N),
        .TR          (LO_TR),
        .REG_ADDR    (LO_ADDR[7:0]),
        .DATA_IN     (LO_DATA[31:0]),
        .AD_CS       (LO_CS),
        .AD_SCLK     (LO_SCLK),
        .AD_SDIO0    (LO_SDIO[0]),
        .AD_UPADTE   (LO_UPDATE),
        .OVER        (LO_OVER)
    );

    AD9911_DATA_ACCESS AD9911_SPI_RF (
        .CLK         (CLOCK_10M),
        .RESET_N     (RESET_N),
        .TR          (RF_TR),
        .REG_ADDR    (RF_ADDR[7:0]),
        .DATA_IN     (RF_DATA[31:0]),
        .AD_CS       (RF_CS),
        .AD_SCLK     (RF_SCLK),
        .AD_SDIO0    (RF_SDIO[0]),
        .AD_UPADTE   (RF_UPDATE),
        .OVER        (RF_OVER)
    );
	
endmodule // SIGNAL_GEN










