/*


*/


module HPS_Terminal(
    input    wire                   s_clk,
    input    wire                   s_reset,
    input    wire                   s_write,
    input    wire                   s_read,
    input    wire        [ 9:0]     s_address,// 1024 * 4
    input    wire        [31:0]     s_writedata,
    output   reg         [31:0]     s_readdata,

    output   reg                    main_reset_n,

    output   reg                    rd,  
    input    wire                   rd_valid,
    input    wire        [63:0]     rd_instruction, 

    output   reg                    wr,
    input    wire                   wr_busy,
    //output   reg                    sampled,
    output   reg         [63:0]     wr_instruction 

    );

    reg  [31:0]  REGS_D  [1023:0]; // read device / read data
    //reg  [31:0]  REGS_W  [9   :0]; // write
    reg  [ 7:0]  state1;
    reg  [ 7:0]  state2;

    reg          probe_status;
    reg          wr_over;
    reg          sampled;
    reg          got;



    always @(posedge s_clk or posedge s_reset) begin
        if (s_reset) begin
            main_reset_n <= 0;
            got <= 0;
        end else if (s_read) begin
            if (s_address >= 300) begin
                s_readdata <= REGS_D[s_address];
            end else if (s_address == 10) begin
                s_readdata <= probe_status;
            end else if (s_address == 11) begin
                s_readdata <= wr_over;
            end else if (s_address == 12) begin
                s_readdata <= sampled;
            end else begin
                s_readdata <= 0;
            end
        end else if (s_write) begin
            if (s_address == 0) begin
                main_reset_n <= s_writedata;
            //end else if (s_address == 1) begin
            //    got <= s_writedata;
            end
        end
    end


    always @(posedge s_clk or negedge main_reset_n) begin
        if (!main_reset_n) begin
            sampled <= 0;
        end else begin
            if ((rd == 1) && (rd_instruction_addr == 499) && (rd_instruction_data == 1)) begin
                sampled <= 1;
            end else if (s_write && (s_address == 1) && (s_writedata == 1)) begin
                sampled <= 0;
            end
        end
    end
    
    wire  [31:0]  wr_instruction_data;
    wire  [15:0]  wr_instruction_addr;
    wire  [31:0]  rd_instruction_data;
    wire  [15:0]  rd_instruction_addr;

    assign wr_instruction_data = s_writedata;
    assign wr_instruction_addr = {16'b0000_0011_1111_1111 & s_address};
    assign rd_instruction_data = rd_instruction[63:32];
    assign rd_instruction_addr = rd_instruction[15: 0];
    
    always @(posedge s_clk or negedge main_reset_n) begin
        if (!main_reset_n) begin
            state1 <= 0;
            wr_over <= 1;
        end else begin
            case (state1)
                0:  begin
                        wr <= 0;
                        wr_over <= 1;
                        state1 <= 1;
                    end 
                1:  begin
                        if (s_write && (100 <= s_address) && (s_address <= 300)) begin
                            wr_instruction <= {wr_instruction_data, 16'd0 ,wr_instruction_addr};
                            wr_over <= 0;
                            state1 <= 2;
                        end
                    end
                2:  begin
                        if (!wr_busy) begin
                            wr <= 1;
                            state1 <= 3;
                        end
                    end
                3:  begin
                        state1 <= 0;
                    end
                default: state1 <= 0;
            endcase 
        end
    end

    always @(posedge s_clk or negedge main_reset_n) begin
        if (!main_reset_n) begin
            rd <= 0;
            state2 <= 0;
        end else begin
            case (state2)
                0:  begin
                        rd <= 0;
                        state2 <= 1;
                    end 
                1:  begin
                        if (rd_valid) begin
                            REGS_D[rd_instruction_addr[9:0]] <= rd_instruction_data;
                            rd <= 1;
                            state2 <= 2;
                        end
                    end
                2:  begin
                        state2 <= 3;
                    end
                3:  begin
                        rd <= 0;
                        state2 <= 0;
                    end
                default: state2 <= 0;
            endcase 
        end
    end


endmodule
