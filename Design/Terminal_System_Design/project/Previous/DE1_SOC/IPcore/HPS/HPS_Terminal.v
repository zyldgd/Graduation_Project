/*

┌─────────┐
│         ┼───> Read_OK
│         │
│         ┼───< Data [31: 0]
│         │ 
│         ┼───< Full      : FIFO write full
│         │ 
│         ┼───< Ready     : ready to read data
└─────────┘

256*32bit
    AD9911 : 
    GPS    : 
    task   :

320*32bit
    data:


name   : RAED
address: 0
┌───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┐
│31 │30 │29 │28 │27 │26 │25 │24 │23 │22 │21 │20 │19 │18 │17 │16 │15 │14 │13 │12 │11 │10 │ 9 │ 8 │ 7 │ 6 │ 5 │ 4 │ 3 │ 2 │ 1 │ 0 │
├───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┤
│                                                                                                                               │
└───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘

name   : WRITE
address: 1
┌───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┐
│31 │30 │29 │28 │27 │26 │25 │24 │23 │22 │21 │20 │19 │18 │17 │16 │15 │14 │13 │12 │11 │10 │ 9 │ 8 │ 7 │ 6 │ 5 │ 4 │ 3 │ 2 │ 1 │ 0 │
├───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┤
│                                                                                                                               │
└───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/


module HPS_Terminal(
    input    wire                   s_clk,
    input    wire                   s_reset,
    input    wire                   s_write,
    input    wire                   s_read,
    input    wire        [ 9:0]     s_address,// 1024 * 4
    input    wire        [31:0]     s_writedata,
    output   reg         [31:0]     s_readdata,


    output   wire                   main_reset_n,

    output   reg                    rd,  
    input    wire                   rd_valid,
    input    wire        [63:0]     rd_instruction, 

    output   reg                    wr,
    input    wire                   wr_busy,
    output   reg         [63:0]     wr_instruction 

    );

    reg  [31:0]  RAM[1023:0];
    wire [31:0]  READ;
    reg  [31:0]  WRITE;
    reg  [ 1:0]  state;

    reg  wr_over;
    assign READ[0] = wr_over;
    assign main_reset_n = WRITE[0];

    always @(posedge s_clk or posedge s_reset) begin
        if (s_reset) begin
            
        end else if (s_read) begin
            if (s_address == 0) begin
                s_readdata <= READ;
            end else if (s_address >= 500) begin
                s_readdata <= RAM[s_address]; // QIdata
            end
        end else if (s_write) begin
            if (s_address == 1) begin
                WRITE <= s_writedata;
            end
        end
    end



    always @(posedge s_clk or posedge s_reset) begin
        if (s_reset) begin
            state <= 0;
            wr_over <= 1;
        end else begin
            case (state)
                0:  begin
                        wr <= 0;
                        wr_over <= 1;
                        state <= 1;
                    end 
                1:  begin
                        if (s_write && (100 <= s_address) && (s_address <= 355)) begin
                            wr_instruction <= { 8'd0 ,s_writedata[31:0] , {8'd0 |(s_address-100)} ,8'd111, 8'd1};
                            wr_over <= 0;
                            state <= 2;
                        end
                    end
                2:  begin
                        if (!wr_busy) begin
                            wr <= 1;
                            state <= 3;
                        end
                    end
                3:  begin
                        state <= 0;
                    end
                default: state <= 0;
            endcase 
        end
    end

endmodule
