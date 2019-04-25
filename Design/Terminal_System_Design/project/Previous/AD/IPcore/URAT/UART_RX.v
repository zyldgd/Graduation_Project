
/*
 * file    : UART_RX.v
 * author  : zyl
 * date    : 2018-8-22
 * version : 1.1
 * addr    : whu.edu.ionosphereLab
 */

// 系统时钟50MHz，波特率115200，带忙闲指示信号BUSY

module UART_RX #(parameter BAUDRATE = 115200, parameter FREQ = 50_000_000)(
    input                 CLOCK_50M,
    input                 RESET_N,
    input                 RX,
    output reg    [7:0]   RDATA,
    output reg            VALID
    );

    localparam T = FREQ / BAUDRATE;

    reg                   BUSY; // BUSY接受处理标志位，为1表明当前处于接受状态
	reg    [7:0]          DATA_OUT_reg;//缓存
    reg    [3:0]          cnt_bit; // 两层计数结构，cnt_clk计数每一位所占的时钟数，cnt_bit计数1个开始位，8个数据位，一个停止位，共10位
    reg    [31:0]         cnt_clk;
	 
    assign                end_cnt_clk = cnt_clk == T - 1;
    assign                end_cnt_bit = end_cnt_clk && cnt_bit == 10 - 1;




    always @(posedge CLOCK_50M or negedge RESET_N) begin
        if(!RESET_N)
            BUSY <= 0; 
        else if(BUSY == 0 && RX == 0)
            BUSY <= 1;
        else if(cnt_bit == 0 && cnt_clk == T / 2 - 1 && RX == 1)
            BUSY <= 0;
        else if(end_cnt_bit)
            BUSY <= 0;
    end
    
   
    
    always @(posedge CLOCK_50M or negedge RESET_N) begin
        if(!RESET_N)
            cnt_clk <= 0;
        else if(BUSY) begin
            if(end_cnt_clk)
                cnt_clk <= 0;
            else
                cnt_clk <= cnt_clk + 1'b1;
        end else
            cnt_clk <= 0;
    end
    


    always @(posedge CLOCK_50M or negedge RESET_N) begin
        if(!RESET_N)
            cnt_bit <= 0;
        else if(end_cnt_clk) begin
            if(end_cnt_bit)
                cnt_bit <= 0;
            else
                cnt_bit <= cnt_bit + 1'b1;
        end
    end    


    
    // 读数据及数据有效指示信号
    always @(posedge CLOCK_50M or negedge RESET_N) begin
        if(!RESET_N)
            DATA_OUT_reg <= 0;
        else if(cnt_clk == T / 2 - 1 && cnt_bit != 1 - 1 && cnt_bit != 10 - 1)
            DATA_OUT_reg[cnt_bit - 1] <= RX;
    end


    
    always @(posedge CLOCK_50M or negedge RESET_N) begin
        if(!RESET_N) begin
            RDATA <= 0;
            VALID <= 0;
        end else if(end_cnt_bit) begin
            VALID <= 1;
            RDATA <= DATA_OUT_reg;
        end else
            VALID <= 0;
    end
    
endmodule