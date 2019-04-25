
/*
 * file   : uart_tx.v
 * author : zyl
 * date   : 2018-8-20
 * addr   : whu.edu.ionosphereLab
 */

// https://www.cnblogs.com/qingkai/p/7729621.html
// 系统时钟50MHz，波特率115200，带忙闲指示信号ready
// T : 2x10^-8

module UART_TX #(parameter BAUDRATE = 115200, parameter FREQ = 50_000_000)(
input               CLOCK_50M,
input               RESET_N,
input               WR,
input       [7:0]   WDATA,
output reg          TX,
output reg          IDLE
);

localparam T = FREQ / BAUDRATE;


reg         [7:0]   DATA;
reg         [3:0]   cnt_bit;
reg         [31:0]  cnt_clk;
wire                end_cnt_clk;
wire                end_cnt_bit;


assign end_cnt_clk = cnt_clk == T - 1;
assign end_cnt_bit = end_cnt_clk && cnt_bit == 10 - 1;


// 有写请求时将IDLE信号拉低，待到数据发送完毕再将信号拉
always @(posedge CLOCK_50M or negedge RESET_N) begin
    if(!RESET_N)
        IDLE <= 1;
    else if(WR) begin
	    DATA <= WDATA;
        IDLE <= 0;
    end else if(end_cnt_bit)
        IDLE <= 1;
end

// 两层计数结构，cnt_clk计数每一位所占的时钟数，cnt_bit计数1个开始位，8个数据位，一个停止位，共10位
always @(posedge CLOCK_50M or negedge RESET_N) begin
    if(!RESET_N)
        cnt_clk <= 0;
    else if(IDLE == 0) begin
        if(end_cnt_clk)
            cnt_clk <= 0;
        else
            cnt_clk <= cnt_clk + 1;
    end
end

always @(posedge CLOCK_50M or negedge RESET_N) begin
    if(!RESET_N)
        cnt_bit <= 0;
    else if(end_cnt_clk) begin
        if(end_cnt_bit)
            cnt_bit <= 0;
        else
            cnt_bit <= cnt_bit + 1;
    end
end

/*
example: 
send 0x41 <=> 0b0100 0001
┌───┬───┬───┬───┬───┬───┬───┬───┬───┬───┐
│ 0 │ 1 │ 2 │ 3 │ 4 │ 5 │ 6 │ 7 │ 8 │ 9 │
├───┼───┼───┼───┼───┼───┼───┼───┼───┼───┤
│ S │ 1 │ 0 │ 0 │ 0 │ 0 │ 0 │ 1 │ 0 │ E │
└───┴───┴───┴───┴───┴───┴───┴───┴───┴───┘
┐   ┌───┐                   ┌───┐   ┌───┐
│ 0 │ 1 │ 0   0   0   0   0 │ 1 │ 0 │ 1 │
└───┘   └───────────────────┘   └───┘   └
*/
// 先发送一个起始位0，然后8位数据位，最后是停止位1
always @(posedge CLOCK_50M or negedge RESET_N) begin
    if(!RESET_N)
        TX <= 1;
    else if(IDLE == 0 && cnt_clk == 0) begin
        if(cnt_bit == 0)
            TX <= 0;
        else if(cnt_bit == 9)
            TX <= 1;
        else
            TX <= DATA[cnt_bit - 1];
    end
end

endmodule