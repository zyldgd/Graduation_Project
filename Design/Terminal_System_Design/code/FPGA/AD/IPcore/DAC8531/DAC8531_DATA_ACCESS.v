module DAC9531_DATA_ACCESS(
    input   wire                CLK,
    input   wire                RESET_N,
    input   wire                TR,
    input   wire     [23:0]     DATA,
    output  reg                 DA_CS,
    output  reg                 DA_SCLK,
    output  reg                 DA_SDO,
    output  reg                 OVER
    );


    reg  [23:0]   DAdata; 

    reg  [ 3:0]   state = 0;
    reg  [ 7:0]   index = 0;

    always @(posedge CLK) begin
        if (!RESET_N) begin
            DA_CS <= 1;
            DA_SCLK <= 0;
            DA_SDO <= 0;
            OVER <= 1;  
            state <= 0; 
        end else begin
            case (state)
                0:  begin
                        DA_CS <= 1;
                        DA_SCLK <= 0;
                        DA_SDO <= 0;
                        OVER <= 1;
                        state <= 1; 
                    end

                1:  begin 
                        if (TR) begin
                            DA_CS <= 0;
                            DAdata <= DATA & 24'b000000001111111111111111;
                            index <= 23;
                            OVER <= 0;
                            state <= 2; 
                        end
                    end

                2:  begin 
                        DA_SDO <= DAdata[index];
                        DA_SCLK <= 1;
                        state <= 3;
                    end

                3:  begin
                        DA_SCLK <= 0;
                        if(index>0) begin
                            index <= index - 1;
                            state <= 2;
                        end else begin
                            state <= 4;
                        end
                    end

                4:  begin
                        DA_CS <= 1;
                        state <= 0;
                    end
                default: state <= 0;
            endcase
        end
    end




endmodule
