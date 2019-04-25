/*
* file         :  SPI_MASTER.v
* version      :  v2.0
* date         :  2018-12-23
* address      :  whu.edu.ionolab
* author       :  ZYL
* decription   :  SPI master module with the parity function
* time diagram :  
*
*                                          ┌───┐
*   [input]                                │   │   lower when BUSY get high
*   WR             ────────────────────────┘   └───────────────────────────────────────────────────────────────────
*
*
*                  ┌─────────────────────┬────────────────────────────────────────────────────────────────────────┐
*   [input]        │  old data           │    push new data into the BUFFER                                       │
*   DATA           └─────────────────────┴────────────────────────────────────────────────────────────────────────┘
*
*
*                                            ┌───┐
*   [output]         high after WR rasing    │   │  come back to low after finishing push and the WR falls
*   BUSY           ──────────────────────────┘   └─────────────────────────────────────────────────────────────────
*
*
*                  ───────────────────────────────────┐                                 ┌──────────────────────────
*   [output]                                          │                                 │
*   SS                                                └─────────────────────────────────┘
*
*
*                                                         ┌─┐  ┌─┐  ┌─┐  ┌─┐  ┌─┐  ┌─┐
*   [output]                                              │ │  │ │  │ │  │ │  │ │  │ │
*   SCLK           ───────────────────────────────────────┘ └──┘ └──┘ └──┘ └──┘ └──┘ └─────────────────────────────
*
*
*                                                       ┌────┬────┬────┬────┬────┬────┐
*   [output]                                            │  0 │  1 │  2 │  3 │....│  n │
*   SD             ─────────────────────────────────────┴────┴────┴────┴────┴────┴────┴────────────────────────────
*
*
*                  ───────────────────────────────────┐                                       ┌────────────────────
*   [input]                                           │                                       │
*   SACK                                              └───────────────────────────────────────┘
*
*
*
*/

module SPI_MASTER(
    input    wire            CLK,
    input    wire            RESET_N,
    /******* data interface ********/
    input    wire            WR,
    input    wire   [63:0]   DATA,
    output   reg             BUSY,
    /******** SPI interface ********/
    output   reg             SS,
    output   reg             SCLK,
    output   reg             SD,
    input    wire            SACK
    );

    /************************** FIFO interface **************************/

    reg            FIFO_ACLR = 1;
    reg   [63:0]   FIFO_DATA = 0;
    wire           FIFO_RDCLK;
    reg            FIFO_RDREQ = 0;
    wire           FIFO_WRCLK;
    reg            FIFO_WRREQ = 0;
    wire  [63:0]   FIFO_Q;
    wire           FIFO_RDEMPTY;
    wire           FIFO_WRFULL;

    /***************************** reg/wire *****************************/

    reg            SACK_reg  = 0;
    reg   [63:0]   DATA_send = 0;
    reg            parity = 0;
    reg   [ 7:0]   delay  = 0;
    reg   [ 3:0]   state1 = 0;
    reg   [ 3:0]   state2 = 0;
    reg   [ 6:0]   i = 0;

    /********** push data into FIFO[BUFFER] unless FIFO full  ***********/
    
    always @(posedge CLK or negedge RESET_N) begin
        if (!RESET_N) begin
            FIFO_ACLR  <= 1;
            FIFO_WRREQ <= 0;
            FIFO_DATA <= 0;
            BUSY <= 1;
            state1 <= 0;
        end else begin
            case (state1)
                0:  begin
                        FIFO_ACLR  <= 0;
                        FIFO_WRREQ <= 0;
                        if (!FIFO_WRFULL) begin
                            BUSY <= 0;
                            state1 <= 1;
                        end
                    end
                1:  begin // waiting
                        if (WR) begin
                            FIFO_DATA <= DATA;
                            BUSY <= 1;
                            state1 <= 2;
                        end
                    end
                2:  begin 
                        state1 <= 3;
                    end
                3:  begin
                        FIFO_WRREQ <= 1;
                        state1 <= 4;
                    end
                4:  begin
                        FIFO_WRREQ <= 0;
                        state1 <= 0;
                    end
                default: state1 <= 0;
            endcase
        end
    end

    /**************** Synchronize the SACK signal ! ********************/

    always @(posedge CLK) begin
        SACK_reg <= SACK;
    end

    /************************  transfer data  **************************/

    always @(posedge CLK or negedge RESET_N) begin
        if (!RESET_N) begin
            FIFO_RDREQ <= 0;
            SCLK <= 0;
            SS  <= 1;
            SD  <= 0;
            state2 <= 0;
        end else begin
            case (state2)
                0:  begin
                        FIFO_RDREQ <= 0;
                        SCLK <= 0;
                        SS <= 1;
                        SD <= 0;
                        state2 <= 1;
                    end
                1:  begin // wait for FIFO data
                        if (!FIFO_RDEMPTY) begin
                            FIFO_RDREQ <= 1;
                            state2 <= 2;
                        end
                    end
                2:  begin
                        FIFO_RDREQ <= 0;
                        state2 <= 3;
                    end
                3:  begin // ready for transfering data by SPI
                        DATA_send <= FIFO_Q;
                        SS <= 0;
                        i <= 0;
                        delay <= 0;
                        SCLK <= 0;
                        parity <= 0;
                        state2 <= 4;
                    end
                4:  begin // transfer data[63:0] and parity                            
                        SCLK <= 0;
                        if (i<=63) begin
                            SD <= DATA_send[i];
                            state2 <= 5;
                        end else if (i==64) begin
                            SD <= parity;
                            state2 <= 5;
                        end else begin
                            SD <= 0;
                            state2 <= 6;
                        end
                    end
                5:  begin
                        SCLK <= 1;
                        parity <= parity + SD;
                        i <= i+1;
                        state2 <= 4;
                    end
                6:  begin // finish
                        SS <= 1;
                        state2 <= 7;
                    end
                7:  begin // wait for ACK in 100 cycles
                        if (SACK_reg) begin
                            state2 <= 0;
                        end else begin
                            if (delay < 100) begin
                                delay <= delay+1;
                            end else begin
                                state2 <= 3;
                            end
                        end
                    end
                default:  state2 <= 0;
            endcase
        end
    end

    /************************ BUFFER instance **************************/

    assign   FIFO_RDCLK = CLK;
    assign   FIFO_WRCLK = CLK;

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
