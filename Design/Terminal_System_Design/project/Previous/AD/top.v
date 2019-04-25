module top(
	input   wire           CLOCK_10M,
	input   wire           CLOCK_50M,

	output  reg    [11:0]  LED,
	output  wire   [ 2:0]  FILTER_SELECT,
	output  wire           RECEIVE_SW,

	output  wire           COM_AD_RF_GPS_RX,
	input   wire           COM_AD_RF_GPS_TX,
	input   wire           COM_AD_RF_GPS_1PPS,

	output  wire           COM_AD_RF_DAC8531_CLK,
	output  wire           COM_AD_RF_DAC8531_DIN,
	output  wire           COM_AD_RF_DAC8531_CS,

	output  wire           COM_AD_RF_AD9911_RF_MRSET,
	output  wire           COM_AD_RF_AD9911_RF_UPDATE,
	output  wire           COM_AD_RF_AD9911_RF_SCLK,
	output  wire           COM_AD_RF_AD9911_RF_SDIO0,
	output  wire   [ 3:0]  COM_AD_RF_AD9911_RF_P,

	output  wire           COM_AD_RF_AD9911_LO_MRSET,
	output  wire           COM_AD_RF_AD9911_LO_UPDATE,
	output  wire           COM_AD_RF_AD9911_LO_SCLK,
	output  wire           COM_AD_RF_AD9911_LO_SDIO0,
	output  wire   [ 3:0]  COM_AD_RF_AD9911_LO_P,

	input   wire           COM_AD_DE1_0,   // SPI0_SS     : AD <- DE1 
	input   wire           COM_AD_DE1_1,   // SPI0_SCK    : AD <- DE1
	input   wire           COM_AD_DE1_2,   // SPI0_SD     : AD <- DE1
	output  wire           COM_AD_DE1_3,   // SPI0_SACK   : AD -> DE1
	output  wire           COM_AD_DE1_4,   // SPI1_SS     : AD -> DE1
	output  wire           COM_AD_DE1_5,   // SPI1_SCK    : AD -> DE1
	output  wire           COM_AD_DE1_6,   // SPI1_SD     : AD -> DE1
	input   wire           COM_AD_DE1_7,   // SPI1_SACK   : AD <- DE1

	input   wire           COM_AD_DE1_8,   // CLK_DE1_50M
	input   wire           COM_AD_DE1_9,   // 
	input   wire           COM_AD_DE1_10,  // 
	input   wire           COM_AD_DE1_11,  // ALL_RESET_N :

	input   wire   [15:0]  LTC2202_DATA,
	input   wire           LTC2202_CLKOUT_n,
	input   wire           LTC2202_CLKOUT_p
    );
	 

	wire CLK_DE1_50M;
	assign CLK_DE1_50M = COM_AD_DE1_8;
	 
	wire  RESET_N;
	assign RESET_N = COM_AD_DE1_11;


	 
    reg [31:0] ccc=0;
    reg [12:0] val=1;

    always @(posedge CLK_DE1_50M) begin
        ccc <= ccc +1;
        if (ccc == 32'b00000000010000000000000000000000) begin
            ccc <= 0;
            if (val == 13'b1000000000000) begin
                val <= 1;
            end else begin 
                val <= val<<1;
                LED[7:0] <= val[7:0];
            end
        end
    end

    wire            TR_OUT;
    wire   [15:0]   ADDR_OUT;
    wire   [31:0]   DATA_OUT;

	wire            TR_IN;
	wire   [15:0]   ADDR_IN;
	wire   [31:0]   DATA_IN;
	wire            TR_IN_BUSY;

	wire            SIGNAL_TRANSC_BUSY;
	wire            SIGNAL_GEN_OVER;
	wire            RF_OUTPUT_EN;
	wire            GEN;
	wire            PRE_GEN;
	wire   [31:0]   CODE;
	wire   [15:0]   CODE_LEN;
	wire   [15:0]   CODE_DURATION;
	wire   [15:0]   PULSE_LEN;
	wire   [ 7:0]   PROBE_MODE;
	wire            INITIED;
	wire   [31:0]   FREQW;
	wire            UPDATE;
	wire            UPDATED;

	wire            GPS_1PPS;
	wire            GPS_locked;
	wire   [15:0]   GPS_year;
	wire   [ 7:0]   GPS_mouth;
	wire   [ 7:0]   GPS_day;
	wire   [ 7:0]   GPS_hour;
	wire   [ 7:0]   GPS_minutes;
	wire   [ 7:0]   GPS_second;
	wire            START;
	wire            RESET_N_PROBE;
	wire            INIT_DDS;

	assign GPS_1PPS = COM_AD_RF_GPS_1PPS;

	Terminal T(
		.CLK             (CLOCK_50M),
		.RESET_N         (RESET_N),
		.TR_IN           (TR_IN),
		.ADDR_IN         (ADDR_IN),
		.DATA_IN         (DATA_IN),
		.TR_IN_BUSY      (TR_IN_BUSY),
		.TR_OUT          (TR_OUT),
		.ADDR_OUT        (ADDR_OUT),
		.DATA_OUT        (DATA_OUT),
		.SPI_RD_SS       (COM_AD_DE1_0),
		.SPI_RD_SCK      (COM_AD_DE1_1),
		.SPI_RD_SD       (COM_AD_DE1_2),
		.SPI_RD_SACK     (COM_AD_DE1_3),
		.SPI_WR_SS       (COM_AD_DE1_4),
		.SPI_WR_SCK      (COM_AD_DE1_5),
		.SPI_WR_SD       (COM_AD_DE1_6),
		.SPI_WR_SACK     (COM_AD_DE1_7)
	);

	Launcher L(
		.CLK               (CLOCK_10M),
		.RESET_N           (RESET_N),
		.TR                (TR_OUT),
		.ADDR              (ADDR_OUT),
		.DATA              (DATA_OUT),
		.GPS_1PPS          (GPS_1PPS),
		.GPS_locked        (GPS_locked),
		.GPS_year          (GPS_year),
		.GPS_mouth         (GPS_mouth),
		.GPS_day           (GPS_day),
		.GPS_hour          (GPS_hour),
		.GPS_minutes       (GPS_minutes),
		.GPS_second        (GPS_second),
		.START             (START),
		.RESET_N_PROBE     (RESET_N_PROBE),
		.INIT_DDS          (INIT_DDS),
	);

	Signal_Transceiver ST(
		.CLOCK_10M           (CLOCK_10M),
		.RESET_N             (RESET_N_PROBE),
		.START               (START),
		.TR                  (TR_OUT),
		.ADDR                (ADDR_OUT),
		.DATA                (DATA_OUT),

		.SIGNAL_TRANSC_BUSY  (SIGNAL_TRANSC_BUSY),
		.SIGNAL_GEN_OVER     (SIGNAL_GEN_OVER),
		.Reveiver_OVER       (Reveiver_OVER),

		.RF_OUTPUT_EN        (RF_OUTPUT_EN),
		.PRE_GEN             (PRE_GEN),
		.GEN                 (GEN),
		.CODE                (CODE),
		.CODE_LEN            (CODE_LEN),
		.CODE_DURATION       (CODE_DURATION),
		.PULSE_LEN           (PULSE_LEN),
		.PROBE_MODE          (PROBE_MODE),
		
		.INITIED             (INITIED),
		.FREQW               (FREQW),
		.UPDATE              (UPDATE),
		.UPDATED             (UPDATED),
	);

	Signal_Generator SG(
		.CLOCK_10M           (CLOCK_10M),
		.RESET_N             (RESET_N_PROBE),

		.RF_OUTPUT_EN        (RF_OUTPUT_EN),
		.GEN                 (GEN),
		.CODE                (CODE),
		.CODE_LEN            (CODE_LEN),
		.CODE_DURATION       (CODE_DURATION),
		.PULSE_LEN           (PULSE_LEN),

		.INIT_DDS            (INIT_DDS),
		.INITIED             (INITIED),
		.FREQW               (FREQW),
		.UPDATE              (UPDATE),
		.UPDATED             (UPDATED),

		.SIGNAL_GEN_OVER     (SIGNAL_GEN_OVER),

		.LO_CS               (),
		.LO_PD               (),
		.LO_UPDATE           (COM_AD_RF_AD9911_LO_UPDATE),
		.LO_MRSET            (COM_AD_RF_AD9911_LO_MRSET),
		.LO_SCLK             (COM_AD_RF_AD9911_LO_SCLK),
		.LO_SDIO             (COM_AD_RF_AD9911_LO_SDIO0),
		.LO_P                (),

		.RF_CS               (),
		.RF_PD               (),
		.RF_UPDATE           (COM_AD_RF_AD9911_RF_UPDATE),
		.RF_MRSET            (COM_AD_RF_AD9911_RF_MRSET),
		.RF_SCLK             (COM_AD_RF_AD9911_RF_SCLK),
		.RF_SDIO             (COM_AD_RF_AD9911_RF_SDIO0),
		.RF_P                (COM_AD_RF_AD9911_RF_P)
	);

	wire    [15:0]     Reveiver_ADDR;
	wire    [31:0]     Reveiver_DATA;
	wire               Reveiver_TR;
	wire               Reveiver_FIFO_ACLR;
	wire               Reveiver_OVER;

	Receiver R(
        .CLK                    (CLOCK_10M),
        .RESET_N                (GEN),
        .AD_DATA                (LTC2202_DATA),
        .AD_CLK                 (LTC2202_CLKOUT_n),
        .PULSE_LEN              (PULSE_LEN),
        .Reveiver_ADDR          (Reveiver_ADDR),
        .Reveiver_DATA          (Reveiver_DATA),
        .Reveiver_TR            (Reveiver_TR),
        .Reveiver_FIFO_ACLR     (Reveiver_FIFO_ACLR),
        .Reveiver_OVER          (Reveiver_OVER)
    );



    DeviceData_Collector DC(
        .CLK                         (CLOCK_10M),
        .RESET_N                     (RESET_N_PROBE),
        .Reveiver_ADDR               (Reveiver_ADDR),
        .Reveiver_DATA               (Reveiver_DATA),
        .Reveiver_TR                 (Reveiver_TR),
        .Reveiver_FIFO_ACLR          (Reveiver_FIFO_ACLR),
        .GPS_1PPS                    (GPS_1PPS),
        .GPS_lockded                 (),
        .GPS_year                    (),
        .GPS_mouth                   (),
        .GPS_day                     (),
        .GPS_hour                    (),
        .GPS_minutes                 (),
        .GPS_second                  (),
        .GPS_latitude                (),
        .GPS_longitude               (),
        .GPS_height                  (),
        .GPS_altitude                (),
        .GPS_visible_satellites      (),
        .GPS_tracking_satellites     (),
        .Frequency_Accuracy          (),
        .TR_CLK                      (CLOCK_50M),
        .TR_IN                       (TR_IN),
        .ADDR_IN                     (ADDR_IN),
        .DATA_IN                     (DATA_IN),
        .TR_IN_BUSY                  (TR_IN_BUSY)
    );

	Switch_Group SwG(
		.CLOCK_10M      (CLOCK_10M),
		.RESET_N        (RESET_N_PROBE),
		.TR             (TR_OUT),
		.ADDR           (ADDR_OUT),
		.DATA           (DATA_OUT),
		.PROBE_MODE     (PROBE_MODE),
		.PRE_GEN        (PRE_GEN),
		.LO_MA          (COM_AD_RF_AD9911_LO_P[3]),
		.RECEIVE_SW     (RECEIVE_SW)
    );

    /*
    Receive_Switch #(.ON(0), .OFF(1)) SW(
        .CLOCK_10M             (CLOCK_10M),
		.TR                    (TR_OUT),
		.ADDR                  (ADDR_OUT),
		.DATA                  (DATA_OUT),
        .SW_EN                 (RESET_N_PROBE),
        .PROBE_MODE            (PROBE_MODE),
        .PRE_GEN               (PRE_GEN),
        .RF_MA                 (COM_AD_RF_AD9911_RF_P[3]),
		.LO_MA                 (COM_AD_RF_AD9911_LO_P[3]),
        .RECEIVE_SW            (RECEIVE_SW)
    );*/

    Filter_Selector FS(
        .FREQW                 (FREQW),
        .FILTER_SELECT         (FILTER_SELECT)
    );

endmodule


   