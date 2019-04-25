/*

requset: 
    FREQW
    FREQW_UPDATE
    CODE
    CODE_NUM
    PULSE_NUM
    
ouput:
    FREQW_UPDATE_OVER
    GEN_OVER


*/



module SIGNAL_GEN(
    input     wire              CLOCK_10M,
    input     wire              RESET_N,
    input     wire              GEN,

    input     wire   [31:0]     FREQW,
    input     wire              FREQW_UPDATE,
    output    wire              FREQW_UPDATE_OVER,
    output    wire              INIT_OK,  
    input     wire   [31:0]     CODE,
    input     wire   [ 7:0]     CODE_NUM,
    input     wire   [15:0]     PULSE_NUM,

    output    reg               GEN_OVER,  

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

    assign LO_PD = 0;
    assign RF_PD = 0;
    
    assign RF_P[1] = MP;
    assign RF_P[3] = MA;

    assign LO_P[1] = 0;
    assign LO_P[3] = 1;

    assign FREQW_UPDATE_OVER = RF_FREQW_UPDATE_OVER & LO_FREQW_UPDATE_OVER;
    assign INIT_OK = RF_INIT_OK & LO_INIT_OK;

    reg    MA = 0;
    reg    MP = 0;

/*
*
*       XXX_NUM  : number
*       XXX_WIDE : duration
*
*
*       <------------------------------------ PULSE_NUM --------------------------------------->
*       <-------- CODE_NUM ---------><---------------------- BLANK_NUM ------------------------>
*       ┌─────┬─────┬─────┬─────────┐ 
*       │  1  │  0  │ ... │   CODE  │ 
*   ────┴─────┴─────┴─────┴─────────┴───────────────────────────────────────────────────────────
*       <-- -->
*          | CODE_WIDE = 25.6us = 256T (10MHZ) = 1/FSR
*
*
*       PULSE_NUM  = CODE_NUM(16) + BLANK_NUM(320-16) = 320
*       PULSE_WIDE = PULSE_NUM(320) * CODE_WIDE(25.6us) = 8.192ms
*
*
*/

//    parameter       CODE_WIDE = 256;
 //   parameter       PULSE_NUM = 320;
 //   parameter       BLANK_NUM = 320-16;


    reg   [31:0]    CODE_reg; //  2-level modulation : 1 or 0
    reg   [ 7:0]    CODE_NUM_reg = 0;
    reg   [15:0]    PULSE_NUM_reg = 0;
    reg   [ 9:0]    INDEX = 0;

    reg   [ 3:0]    STATE = 0;
    reg             FSR = 0;
    reg   [15:0]    COUNT = 1;

    initial begin
        LO_MRSET <= 1;
        RF_MRSET <= 1;
        GEN_OVER <= 0;
        CODE_reg[ 0] <=  1;
        CODE_reg[ 1] <=  1;
        CODE_reg[ 2] <=  0;
        CODE_reg[ 3] <=  1;
        CODE_reg[ 4] <=  1;
        CODE_reg[ 5] <=  1;
        CODE_reg[ 6] <=  1;
        CODE_reg[ 7] <=  0;
        CODE_reg[ 8] <=  1;
        CODE_reg[ 9] <=  0;
        CODE_reg[10] <=  0;
        CODE_reg[11] <=  0;
        CODE_reg[12] <=  1;
        CODE_reg[13] <=  0;
        CODE_reg[14] <=  1;
        CODE_reg[15] <=  1;
    end

/*
*                                               ┌──┐ 
*                                               │  │ 
*    FREQW_UPDATE          ─────────────────────┘  └────────────────────────────────────────────────────────────────────────────────────
*
*
*                          ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────┐ 
*                          │                  FREQW                                                                                    │ 
*    FREQW                 └───────────────────────────────────────────────────────────────────────────────────────────────────────────┘ 
*
*                                                                          ┌────────────────────────────────────────────────────────┐ 
*                                                                          │ keep high level until FREQW_UPDATE pulse arrives again │  
*    FREQW_UPDATE_OVER     ────────────────────────────────────────────────┘                                                        └───
*
*                                   ┌──┐ 
*                                   │  │  
*    GEN        ────────────────────┘  └────────────────────────────────────────────────────────────────────────────────────
*
*                                    ┌───────────────────────────┐ 
*                                    │                           │  
*    MA         ─────────────────────┘                           └───────────────────────────────────────────────────────────
*
*                                    ┌─────┬─────┬─────┬─────────┐ 
*                                    │  1  │  0  │ ... │   CODE  │ 
*    MP         ─────────────────────┴─────┴─────┴─────┴─────────┴───────────────────────────────────────────────────────────
*
*                                                                ┌───────────────────────────────────────────────┐ 
*                                                                │ keep high level until GEN pulse arrives again │  
*    GEN_OVER   ─────────────────────────────────────────────────┘                                               └────────────
*/

    always @(posedge CLOCK_10M) begin
        if (!RESET_N) begin
            GEN_OVER <= 1;
            MA <= 0;
            LO_MRSET <= 1;
            RF_MRSET <= 1;
            STATE <= 0;
        end else begin
            case (STATE)
                0   :begin
                        MA <= 0;
                        LO_MRSET <= 0;
                        RF_MRSET <= 0;
								GEN_OVER <= 1;
                        STATE <= 1;
                    end

                1   :begin
                        if (GEN) begin
                            CODE_reg <= CODE;
                            CODE_NUM_reg <= CODE_NUM;
                            PULSE_NUM_reg <= PULSE_NUM;
                            GEN_OVER <= 0;
                            COUNT <= 1;
                            INDEX <= 0;
                            STATE <= 2;
                        end
                    end
                2   :begin
                        if (INDEX < CODE_NUM_reg) begin
                            MP <= CODE[INDEX];
                            MA <= 1;
                            STATE <= 3;
                        end else if (INDEX < PULSE_NUM_reg) begin
                            MA <= 0;
                            STATE <= 3;
                        end else begin
                            MA <= 0;
                            STATE <= 0;
                        end
                    end
                3   :begin
                        if (COUNT < 255) begin  //COUNT_NUM
                            COUNT <= COUNT+1;
                        end else begin
                            COUNT <= 1;
									 INDEX <= INDEX+1;
                            STATE <= 2;
                        end
                    end

                
                default: STATE <= 0;
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

        .INIT_OK            (LO_INIT_OK),
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

        .INIT_OK            (RF_INIT_OK),
        .FREQW_UPDATE_OVER  (RF_FREQW_UPDATE_OVER),
        .TR                 (RF_TR),
        .ADDR               (RF_ADDR[7:0]),
        .DATA               (RF_DATA[31:0])
    );
    


    AD9911_DATA_ACCESS AD9911_SPI_LO(
        .CLK         (CLOCK_10M),
        .RESET_N     (RESET_N),
      //.R_W         (),
        .TR          (LO_TR),
        .REG_ADDR    (LO_ADDR[7:0]),
        .DATA_IN     (LO_DATA[31:0]),
      //.DATA_OUT    (),
        .AD_CS       (LO_CS),
        .AD_SCLK     (LO_SCLK),
        .AD_SDIO0    (LO_SDIO[0]),
        .AD_UPADTE   (LO_UPDATE),
        .OVER        (LO_OVER)
    );


    AD9911_DATA_ACCESS AD9911_SPI_RF (
        .CLK         (CLOCK_10M),
        .RESET_N     (RESET_N),
      //.R_W         (),
        .TR          (RF_TR),
        .REG_ADDR    (RF_ADDR[7:0]),
        .DATA_IN     (RF_DATA[31:0]),
      //.DATA_OUT    (),
        .AD_CS       (RF_CS),
        .AD_SCLK     (RF_SCLK),
        .AD_SDIO0    (RF_SDIO[0]),
        .AD_UPADTE   (RF_UPDATE),
        .OVER        (RF_OVER)
    );
	
endmodule // SIGNAL_GEN










