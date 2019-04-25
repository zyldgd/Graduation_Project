


/* send 320x16bit  MSB */
module UART(
    input    wire           CLOCK_50M,
    input    wire           CLOCK_10M,
    input    wire           RESET_N,
    input    wire           TR,
    input    wire           EXECUT_OVER,
    input    wire           RE_OVER,
    input    wire   [15:0]  PULSE_LEN,
    output   reg    [15:0]  ADDR,
    input    wire   [31:0]  DATA,
    input    wire           RX,
    output   wire           TX,
    output   reg            START,
    output   reg            OVER
    );
    
    initial begin
        OVER <= 1;
    end

    reg    [7:0]   WDATA;
    wire   [7:0]   RDATA;
    reg    [7:0]   RDATA_reg = 0;


	always @(posedge CLOCK_10M) begin
        if(VALID) begin
            RDATA_reg <= RDATA;
        end
	end


    reg             WR = 0;
    reg    [ 4:0]   state = 0;
    reg    [15:0]   index = 0;


    always @(posedge CLOCK_10M or negedge RESET_N) begin
        if (!RESET_N) begin
            state <= 0;
            WR <= 0;
            OVER <= 1;
        end else begin
            case (state)
                0:  begin
                        state <= 1;
                        WR <= 0;
                        index <= 0;
                        OVER <= 1;
                    end 
                1:  begin // 开始探测
                        if (RDATA_reg == 8'hFF) begin
                            START <= 1;
                            OVER <= 0;
                            state <= 2;
                        end
                    end 
                2:  begin // 一组探测
                        START <= 0;
                        if (EXECUT_OVER) begin
                            state <= 17;
                        end else if (RE_OVER) begin
                            state <= 3;
                            index <= 0;
                        end
                    end 
                3:  begin // 发送 320x16x2bit
                        if (index<PULSE_LEN) begin 
                            ADDR <= index;
                            state <= 4;
                            OVER <= 0;
                        end else begin
                            state <= 16;
                        end
                    end 
                4:  begin // 先发送R 高位
                        WDATA <= DATA[15:8];
                        state <= 5;
                    end
                5:  begin
                        if (IDLE) begin
                            WR <= 1;
                            state <= 6;
                        end
                    end
                6:  begin
                        WR <= 0;
                        state <= 7;
                    end
                7:  begin // 再发送R 低位
                        WDATA <= DATA[7:0];
                        state <= 8;
                    end
                8:  begin
                        if (IDLE) begin
                            WR <= 1;
                            state <= 9;
                        end
                    end
                9:  begin
                        WR <= 0;
                        state <= 10;
                    end
                10: begin // 先发送I 高位
                        WDATA <= DATA[31:24];
                        state <= 11;
                    end
                11: begin
                        if (IDLE) begin
                            WR <= 1;
                            state <= 12;
                        end
                    end
                12: begin
                        WR <= 0;
                        state <= 13;
                    end
                13: begin // 再发送I 低位
                        WDATA <= DATA[23:16];
                        state <= 14;
                    end
                14: begin
                        if (IDLE) begin
                            WR <= 1;
                            state <= 15;
                        end
                    end
                15: begin
                        WR <= 0;
                        index <= index+1;
                        state <= 3;
                    end
                16: begin // 320x16x2bit 发送完成
                        if (IDLE) begin
                            OVER <= 1;
                            state <= 2;
                        end
                    end
                17: begin // 结束
                        if (RDATA_reg == 8'h00) begin
                            state <= 0;
                        end
                    end
                default: state <= 0;
            endcase

        end
    end





    UART_TX #(
        .BAUDRATE(115200), 
        .FREQ(50_000_000)) 
    tx (
        .CLOCK_50M   (CLOCK_50M),
        .RESET_N     (RESET_N),
        .WR          (WR),
        .WDATA       (WDATA),
        .TX          (TX),
        .IDLE        (IDLE)
    );

    UART_RX #(
        .BAUDRATE(115200), 
        .FREQ(50_000_000)) 
    rx (
        .CLOCK_50M   (CLOCK_50M),
        .RESET_N     (RESET_N),
        .RX          (RX),
        .RDATA       (RDATA),
        .VALID       (VALID)
    );
endmodule // UART