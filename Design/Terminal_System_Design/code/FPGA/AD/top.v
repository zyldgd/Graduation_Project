module top(
    input   wire           CLOCK_10M,
    input   wire           CLOCK_50M,
    output  wire   [11:0]  LED,

    output  wire           COM_AD_RF_GPS_RX,
    input   wire           COM_AD_RF_GPS_TX,
    input   wire           COM_AD_RF_GPS_1PPS,

    output  wire           COM_AD_RF_DAC8531_CLK,
    output  wire           COM_AD_RF_DAC8531_DIN,
    output  wire           COM_AD_RF_DAC8531_CS,

    output  wire           COM_AD_RF_AD9911_RF_UPDATE,
    output  wire           COM_AD_RF_AD9911_RF_SCLK,
    output  wire           COM_AD_RF_AD9911_RF_SDIO0,
    output  wire           COM_AD_RF_AD9911_RF_P1,
    output  wire           COM_AD_RF_AD9911_RF_P3,

    output  wire           COM_AD_RF_AD9911_LO_UPDATE,
    output  wire           COM_AD_RF_AD9911_LO_SCLK,
    output  wire           COM_AD_RF_AD9911_LO_SDIO0,
    output  wire           COM_AD_RF_AD9911_RF_MRSET,
    output  wire           COM_AD_RF_AD9911_LO_MRSET,
	 
    output  wire   [11:0]  COM_AD_DE1,
	 
    input   wire   [15:0]  LTC2202_DATA,
    input   wire           LTC2202_CLKOUT_n,
    input   wire           LTC2202_CLKOUT_p
    );
	 
	 
    assign COM_AD_DE1[0] = COM_AD_RF_GPS_1PPS;
	 
    reg [31:0] count=0;
    reg [12:0] val=1;
    reg RESET_N=0;
    always @(posedge CLOCK_10M) begin
        count <= count +1;
        if (count == 32'b00000000010000000000000000000000) begin
            count <= 0;
            if (val == 13'b1000000000000) begin
                val <= 1;
					 RESET_N <= 1;
            end else begin 
                val <= val<<1;
                //LED[7:0] <= val[7:0];
            end
        end
        
    end
/*
  

    wire [15:0] sin=0;
    wire [15:0] cos=0;
    wire        nco_valid=0;
    nco nco_inst(
        .phi_inc_i     (120259084/2),
        .clk           (CLOCK_50M),
        .reset_n       (1),
        .clken         (1),
        .fsin_o        (sin),
        .fcos_o        (cos),
        .out_valid     (nco_valid)
        );
        


reg [4:0] state = 0;
reg GEN = 0;	
wire GEN_OVER;
wire INIT_OK;

always @(posedge CLOCK_10M) begin
	case(state)
		0:begin 
			state <= 1;
			GEN <= 0;	
		end
		1:begin 
			if(GEN_OVER & INIT_OK) begin
				GEN <= 1;	
				state <= 2;
			end
		end
		2:begin 
			state <= 0;
		end
	endcase
end



reg [4:0] i = 1;
reg [4:0] state2 = 0;
wire FREQW_UPDATE_OVER;
reg FREQW_UPDATE = 0;
reg [31:0] FREQW = 8947849*20;	

always @(posedge CLOCK_10M) begin
	case(state2)
		0:begin 
			if (val != 13'b1000000000000) begin
				state2 <= 1;
			   FREQW_UPDATE <= 0;
			end
			
		end
		1:begin 
			if(FREQW_UPDATE_OVER & INIT_OK) begin
				FREQW_UPDATE <= 1;	
				state2 <= 2;
			end
		end
		2:begin 
			state2 <= 3;
		end
		3:begin 
			FREQW_UPDATE <= 0;
			state2 <= 4;
		end
		4:begin 
			if (val == 13'b1000000000000) begin
				FREQW <= 8947849*i;
				state2 <= 0;
				i = i<21 ? i+1 : 1;
			end
		end
		
	endcase
end





wire [3:0] LO_SDIO;
wire [3:0] RF_SDIO;

wire [3:0] RF_P;

assign COM_AD_RF_AD9911_RF_SDIO0 = RF_SDIO[0];
assign COM_AD_RF_AD9911_LO_SDIO0 = LO_SDIO[0];

assign COM_AD_RF_AD9911_RF_P1 = RF_P[1];
assign COM_AD_RF_AD9911_RF_P3 = RF_P[3];

    SIGNAL_GEN SIGNAL_GEN_inst1(
    .CLOCK_10M              (CLOCK_10M),
    .RESET_N                (1),
    .GEN                    (GEN),
    .FREQW                  (FREQW),
    .FREQW_UPDATE           (FREQW_UPDATE),
    .FREQW_UPDATE_OVER      (FREQW_UPDATE_OVER),
	 .INIT_OK                (INIT_OK),
    .CODE                   (31'b0000000000000000_1101000101111011),
    .CODE_NUM               (16),
    .PULSE_NUM              (320),
    .GEN_OVER               (GEN_OVER), 
    
    .LO_CS                  (), 
    .LO_PD                  (), 
    .LO_UPDATE              (COM_AD_RF_AD9911_LO_UPDATE),
    .LO_MRSET               (COM_AD_RF_AD9911_LO_MRSET),
    .LO_SCLK                (COM_AD_RF_AD9911_LO_SCLK),
    .LO_SDIO                (LO_SDIO),
    .LO_P                   (),

    .RF_CS                  (), 
    .RF_PD                  (), 
    .RF_UPDATE              (COM_AD_RF_AD9911_RF_UPDATE),
    .RF_MRSET               (COM_AD_RF_AD9911_RF_MRSET),
    .RF_SCLK                (COM_AD_RF_AD9911_RF_SCLK),
    .RF_SDIO                (RF_SDIO),
    .RF_P                   (RF_P)
    );

*/
	 
	 FREQ_CALIBRATION FREQ_CALIBRATION_inst1(
    .CLOCK_10M    (CLOCK_10M),
    .RESET_N      (RESET_N),
    .GPS_PPS      (COM_AD_RF_GPS_1PPS),
    .GPS_LOCK     (1),// GPS_LOCK
    .DA_CS        (COM_AD_RF_DAC8531_CS),
    .DA_SCLK      (COM_AD_RF_DAC8531_CLK),
    .DA_SDO       (COM_AD_RF_DAC8531_DIN),
	 .PRECISION    ({LED[8],LED[9],LED[10],LED[11]})
    );




endmodule

