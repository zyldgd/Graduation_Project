/*
* file         :  SPI_SLAVE.v
* version      :  v2.0
* date         :  2018-12-23
* address      :  whu.edu.ionolab
* author       :  ZYL
* decription   :  SPI slave module with the parity function
* time diagram :  
*
*                                                                       ┌───┐
*   [input]                                                             │   │   fall after the VALID gets low
*   RD             ─────────────────────────────────────────────────────┘   └───────────────────────────────────────────────────────
*
*
*                                                                     ┌───┐
*   [output]            no new data                                   │   │   be low until new data arrives
*   VALID          ───────────────────────────────────────────────────┘   └───────────────────────────────────────────────────────
*
*
*                  ┌──────────────────────────────────────────────────┬──────────────────────────────────────────────────────────┐
*   [output]       │  old data                                        │   new data                                               │
*   DATA           └──────────────────────────────────────────────────┴──────────────────────────────────────────────────────────┘
*
*
*                  ───────────┐                                 ┌─────────────────────────────────────────────────────────────────
*   [input]                   │                                 │
*   SS                        └─────────────────────────────────┘
*
*
*                                 ┌─┐  ┌─┐  ┌─┐  ┌─┐  ┌─┐  ┌─┐
*   [input]                       │ │  │ │  │ │  │ │  │ │  │ │
*   SCLK           ───────────────┘ └──┘ └──┘ └──┘ └──┘ └──┘ └────────────────────────────────────────────────────────────────────
*
*
*                               ┌────┬────┬────┬────┬────┬────┐
*   [input]                     │  0 │  1 │  2 │  3 │....│  n │
*   SD             ─────────────┴────┴────┴────┴────┴────┴────┴───────────────────────────────────────────────────────────────────
*
*
*                  ───────────┐                                       ┌───────────────────────────────────────────────────────────
*   [ouput]                   │                                       │
*   SACK                      └───────────────────────────────────────┘
*
*
*
*/

module SPI_SLAVE(
    input    wire            CLK,
    input    wire            RESET_N,
    /******* data interface ********/ 
    input    wire            RD,
    output   wire   [63:0]   DATA,
    output   reg             VALID,

    /******** SPI interface ********/
    input    wire            SS,
    input    wire            SCLK,
    input    wire            SD,
    output   reg             SACK
    );


    /************************** FIFO interface **************************/

    reg            FIFO_ACLR = 1;
    wire  [63:0]   FIFO_DATA;
    wire           FIFO_RDCLK;
    reg            FIFO_RDREQ = 0;
    wire           FIFO_WRCLK;
    reg            FIFO_WRREQ = 0;
    wire  [63:0]   FIFO_Q;
    wire           FIFO_RDEMPTY;
    wire           FIFO_WRFULL;

    /***************************** reg/wire *****************************/
    
    reg   [63:0]   DATA_receive = 0;
    reg            parity = 0;
    reg            parity_receive = 0;
    reg   [ 6:0]   i = 0;
    reg   [ 3:0]   state1 = 0;
    reg   [ 3:0]   state2 = 0;
    reg            enough = 0;
    reg            restart = 0;

    /*********************** read data from BUFFER **********************/

    always @(posedge CLK or negedge RESET_N) begin
        if (!RESET_N) begin
            FIFO_RDREQ <= 0;
            FIFO_ACLR  <= 1;
            VALID  <= 0;
            state1 <= 0;
        end else begin
            case (state1)
                0:  begin 
                        FIFO_ACLR  <= 0;
                        FIFO_RDREQ <= 0;
                        VALID  <= 0;
                        state1 <= 1;
                    end
                1:  begin // read data from BUFFER after ready
                        if (!FIFO_RDEMPTY) begin 
                            FIFO_RDREQ <= 1;
                            state1 <= 2;
                        end
                    end
                2:  begin 
                        FIFO_RDREQ <= 0;
                        state1 <= 3;
                    end 
                3:  begin
                        VALID  <= 1;
                        state1 <= 4;
                    end
                4:  begin // waiting 
                        if (RD) begin 
                            VALID  <= 0;
                            state1 <= 0;
                        end
                    end
                default: state1 <= 0;
            endcase
        end
    end


    /*************************** receive data  ***************************/

    always @(posedge SCLK or posedge SS) begin
        if (SS) begin
            i <= 0;
        end else begin
            if (i==0) begin
                DATA_receive[0] <= SD;
                parity <= SD;
                i <= 1;
                enough <= 0;
            end else if (i<=63) begin
                DATA_receive[i] <= SD;
                parity <= parity+SD;
                i <= i+1;
                enough <= 0;
            end else begin
                parity_receive <= SD;
                enough <= 1;
            end
        end
    end


    /*********************** push data into BUFFER ************************/

    always @(posedge CLK or negedge RESET_N) begin
        if (!RESET_N) begin
            FIFO_WRREQ <= 0;
            SACK <= 0;
            restart <= 0;
            state2 <= 0;
        end else begin
            if (!enough) begin
                FIFO_WRREQ <= 0;
                SACK <= 0;
                restart <= 1; // No Reset to high !!!  
                state2 <= 0;
            end else begin
                case (state2)
                    0:  begin
                            if (restart) begin
                                restart <= 0;
                                state2 <= 1;
                            end
                        end
                    1:  begin // cheak parity
                            if (parity == parity_receive) begin
                                state2 <= 2;
                            end else begin
                                state2 <= 4;
                            end
                        end
                    2:  begin // wirte data into fifo
                            if (!FIFO_WRFULL) begin
                                FIFO_WRREQ <= 1;
                                state2 <= 3;
                            end else begin
                                state2 <= 4;
                            end
                        end
                    3:  begin // success 
                            FIFO_WRREQ <= 0;
                            SACK <= 1;
                        end
                    4:  begin // fail
                            FIFO_WRREQ <= 0;
                            SACK <= 0;
                        end
                    default:  state2 <= 0;
                endcase
            end
        end
    end


    /************************ BUFFER instance **************************/

    assign   FIFO_RDCLK = CLK;
    assign   FIFO_WRCLK = CLK;
    assign   FIFO_DATA  = DATA_receive;
    assign   DATA = FIFO_Q;

    FIFO  BUFFER (
        .aclr    ( FIFO_ACLR    ),    // input	        aclr;
        .data    ( FIFO_DATA    ),    // input	[63:0]  data;
        .rdclk   ( FIFO_RDCLK   ),    // input	        rdclk;
        .rdreq   ( FIFO_RDREQ   ),    // input	        rdreq;
        .wrclk   ( FIFO_WRCLK   ),    // input	        wrclk;
        .wrreq   ( FIFO_WRREQ   ),    // input	        wrreq;
        .q       ( FIFO_Q       ),    // output	[63:0]  q;
        .rdempty ( FIFO_RDEMPTY ),    // output	        rdempty;
        .wrfull  ( FIFO_WRFULL  )     // output	        wrfull;
    );












endmodule
