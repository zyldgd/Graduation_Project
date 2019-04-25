module TRANS_TEST_SEND(
    input    wire           CLK,
    input    wire           RESET_N, 
    output   wire           SPI_WR_SS  ,//   : AD <- DE1 
    output   wire           SPI_WR_SCK ,//   : AD <- DE1
    output   wire           SPI_WR_SD  ,//   : AD <- DE1
    input    wire           SPI_WR_SACK,//   : AD -> DE1
    input    wire           SPI_RD_SS  ,//   : AD -> DE1
    input    wire           SPI_RD_SCK ,//   : AD -> DE1
    input    wire           SPI_RD_SD  ,//   : AD -> DE1
    output   reg            ERR,
    output   wire           SPI_RD_SACK //   : AD <- DE1
    );

	//reg            ERR = 0;
	reg   [63:0]   cnt = 0;
	reg   [ 7:0]   state = 0;

	reg            WR = 0;
	reg            RD = 0;
	wire           VALID_RD;
	wire           BUSY_WR;

	reg   [63:0]   DATA_WR = 0;
	wire  [63:0]   DATA_RD;
	reg   [63:0]   DATA_RECEIVE = 0;



	always @(posedge CLK) begin
        if (!RESET_N) begin
            WR <= 0;
            RD <= 0;
            ERR <= 0;
            cnt <= 0;
            state <= 0;
        end else begin
            case(state)
                0:begin
                    WR <= 0;
                    RD <= 0;
                    DATA_WR <= cnt;
                    state <= 1;
                end
                1:begin
                    if(!BUSY_WR) begin
                        WR <= 1;
                        state <= 2;
                    end
                end
                2:begin
                    WR <= 0;
                    state <= 3;
                end
                3:begin
                    if (VALID_RD) begin
                        DATA_RECEIVE <= DATA_RD;
                        RD <= 1;
                        state <= 4;
                    end
                end
                4:begin
                    RD <= 0;
                    ERR <= (DATA_RECEIVE == DATA_WR) ? 0 : 1;
                    state <= 5;
                end
                5:begin
                    cnt <= cnt+1;
                    state <= 0;
                end
            endcase
        end
	end

	 
    SPI_MASTER MASTER(
		.CLK         (CLK),
		.RESET_N     (RESET_N),

		.WR          (WR),
		.DATA        (DATA_WR),
		.BUSY        (BUSY_WR),

		.SS          (SPI_WR_SS  ),
		.SCLK        (SPI_WR_SCK ),
		.SD          (SPI_WR_SD  ),
		.SACK        (SPI_WR_SACK)
    );
	
    SPI_SLAVE SLAVE(
		.CLK         (CLK),
		.RESET_N     (RESET_N),

		.RD          (RD),
		.DATA        (DATA_RD),
		.VALID       (VALID_RD),

		.SS          (SPI_RD_SS  ),
		.SCLK        (SPI_RD_SCK ),
		.SD          (SPI_RD_SD  ),
		.SACK        (SPI_RD_SACK)
    );

endmodule