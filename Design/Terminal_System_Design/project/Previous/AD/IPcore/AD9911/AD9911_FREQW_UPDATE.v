module AD9911_FREQW_UPDATE #(parameter start_freqw = 0)(
    input     wire              CLK,
    input     wire              RESET_N,
    input     wire              OVER,
    input     wire   [31:0]     FREQW,          // ad9911 CTW0
    input     wire              FREQW_UPDATE,   // active on low level

    output    reg               FREQW_UPDATE_OVER,
    output    reg               TR,
    output    reg    [ 7:0]     ADDR,
    output    reg    [31:0]     DATA
    );

    // one-hot code
    localparam S0 = 8'b00000001;
    localparam S1 = 8'b00000010;
    localparam S2 = 8'b00000100;
    localparam S3 = 8'b00001000;
    localparam S4 = 8'b00010000;
    localparam S5 = 8'b00100000;
    localparam S6 = 8'b01000000;
    localparam S7 = 8'b10000000;
    
    reg  [ 7:0]   STATE = 0;

    reg  [31:0]   REGS[24:0];
    reg  [ 4:0]   NUM = 0;



    initial begin
        FREQW_UPDATE_OVER <= 0;
        TR <= 0;
        REGS[0] <= 32'b00000000_00000000_00000000_00100000; //CSR
        REGS[1] <= 32'b00000000_10110011_00000100_00000000; //FR1
        REGS[2] <= 0;                                       //FR2
        REGS[3] <= 32'b00000000_11000000_00000011_00000000; //CFR
        REGS[4] <= 8947849*2 + start_freqw;                 //CTW0   536880000  8948   FREQW * 480M / 2^32 = Fout
        REGS[5] <= 0;                                       //CPOW0
        REGS[6] <= 32'b00000000_00000001_11011111_11111111; //ACR
        REGS[7] <= 32'b00000000_00000000_00000000_00000000; //LSR
        REGS[8] <= 32'b00000000_00000000_00000000_00000000; //RDW
        REGS[9] <= 32'b00000000_00000000_00000000_00000000; //FDW
        REGS[10]<= 32'b10000000_00000000_00000000_00000000; //CTW1
    end


    always @(posedge CLK or negedge RESET_N) begin
        if (!RESET_N) begin
            STATE <= S0;
        end else begin
            case (STATE)
                S0 :begin
                        FREQW_UPDATE_OVER <= 0;
                        TR <= 0;
                        NUM <= 0;
                        STATE <= S1;
                    end
                S1 :begin // initial S1 - S4
                        if (NUM>=11) begin
                            FREQW_UPDATE_OVER <= 1;
                            STATE <= S5;
                        end else begin
                            STATE <= S2;
                        end
                    end
                S2 :begin
                        ADDR <= NUM;
                        DATA <= REGS[NUM];
                        STATE <= S3;
                    end
                S3 :begin
                        TR <= 1;
                        STATE <= S4;
                    end
                S4 :begin
                        if (OVER) begin
                            if (!TR) begin
                                NUM <= NUM+1;
                                STATE <= S1;
                            end
                        end else begin
                            TR <= 0;
                        end
                    end
                S5 :begin // update freqw  S5 - S7
                        if (FREQW_UPDATE) begin
                            ADDR <= 4; // address of ad9911 reg CTW0 
                            DATA <= start_freqw + FREQW; // 41.4MHz : 370440929
                            FREQW_UPDATE_OVER <= 0;
                            STATE <= S6;
                        end
                    end
                S6 :begin
                        TR <= 1;
                        STATE <= S7;
                    end
                S7 :begin
                        if (OVER) begin
                            if (!TR) begin
                                FREQW_UPDATE_OVER <= 1;
                                STATE <= S5;
                            end
                        end else begin
                            TR <= 0;
                        end
                    end
                default: STATE <= S0;
            endcase
        end
    end
    
endmodule
