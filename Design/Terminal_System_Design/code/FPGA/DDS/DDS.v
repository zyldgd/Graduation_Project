module DDS(
    input     wire            CLOCK_10M,
    input     wire            CLOCK_40M,
    output    wire   [ 1:0]   CLOCK_SELECT,
    output    reg    [ 3:0]   LED,

    output    wire            GPS_RX,
    input     wire            GPS_TX,
    input     wire            GPS_1PPS,

    output    wire            DAC8531_CLK,
    output    wire            DAC8531_DIN,
    output    wire            DAC8531_CS ,

    output    wire            AD9911_LO_CS,
    output    wire            AD9911_LO_PD,
    output    wire            AD9911_LO_UPDATE,
    output    wire            AD9911_LO_MRSET ,
    output    wire            AD9911_LO_SCLK,
    output    wire   [ 3:0]   AD9911_LO_SDIO,
    output    wire   [ 3:0]   AD9911_LO_P,
    output    wire            SW_AD9911_LO,

    output    wire            AD9911_RF_CS,
    output    wire            AD9911_RF_PD,
    output    wire            AD9911_RF_UPDATE,
    output    wire            AD9911_RF_MRSET ,
    output    wire            AD9911_RF_SCLK,
    output    wire   [ 3:0]   AD9911_RF_SDIO,
    output    wire   [ 3:0]   AD9911_RF_P,
    output    wire            SW_AD9911_RF,

    output    wire            COM_AD_RF_GPS_TX,
    output    wire            COM_AD_RF_GPS_1PPS,
    input     wire            COM_AD_RF_GPS_RX,
    input     wire            COM_AD_RF_DAC8531_CLK,
    input     wire            COM_AD_RF_DAC8531_DIN,
    input     wire            COM_AD_RF_DAC8531_CS,
    input     wire            COM_AD_RF_AD9911_RF_UPDATE,
    input     wire            COM_AD_RF_AD9911_RF_SCLK,
    input     wire            COM_AD_RF_AD9911_RF_SDIO0,
    input     wire            COM_AD_RF_AD9911_RF_P1,
    input     wire            COM_AD_RF_AD9911_RF_P3,
    input     wire            COM_AD_RF_AD9911_LO_UPDATE,
    input     wire            COM_AD_RF_AD9911_LO_SCLK,
    input     wire            COM_AD_RF_AD9911_LO_SDIO0,
    input     wire            COM_AD_RF_AD9911_RF_MRSET,
    input     wire            COM_AD_RF_AD9911_LO_MRSET

);

assign CLOCK_SELECT = 2'b10;
assign SW_AD9911_LO = 0;
assign SW_AD9911_RF = 0;

assign AD9911_LO_CS = 0;
assign AD9911_RF_CS = 0;
assign AD9911_LO_PD = 0;
assign AD9911_RF_PD = 0;
assign AD9911_LO_P[1] = 0;
assign AD9911_LO_P[3] = 1;

reg [31:0] count=0;
reg [7:0] val=1;
always @(posedge CLOCK_10M) begin
    count <= count +1;
    if (count == 32'b00000000100000000000000000000000) begin
        if (val == 5'b10000) begin
            val <= 1;
        end else begin
            val <= val<<1;
            LED <= val[3:0];
        end
        count <= 0;
    end
end


assign COM_AD_RF_GPS_TX             =   GPS_TX;
assign COM_AD_RF_GPS_1PPS           =   GPS_1PPS;
assign GPS_RX                       =   COM_AD_RF_GPS_RX;
assign DAC8531_CLK                  =   COM_AD_RF_DAC8531_CLK;
assign DAC8531_DIN                  =   COM_AD_RF_DAC8531_DIN;
assign DAC8531_CS                   =   COM_AD_RF_DAC8531_CS;
assign AD9911_RF_UPDATE             =   COM_AD_RF_AD9911_RF_UPDATE;
assign AD9911_RF_SCLK               =   COM_AD_RF_AD9911_RF_SCLK;
assign AD9911_RF_SDIO[0]            =   COM_AD_RF_AD9911_RF_SDIO0;
assign AD9911_RF_P[1]               =   COM_AD_RF_AD9911_RF_P1;
assign AD9911_RF_P[3]               =   COM_AD_RF_AD9911_RF_P3;
assign AD9911_LO_UPDATE             =   COM_AD_RF_AD9911_LO_UPDATE;
assign AD9911_LO_SCLK               =   COM_AD_RF_AD9911_LO_SCLK;
assign AD9911_LO_SDIO[0]            =   COM_AD_RF_AD9911_LO_SDIO0;
assign AD9911_RF_MRSET              =   COM_AD_RF_AD9911_RF_MRSET;
assign AD9911_LO_MRSET              =   COM_AD_RF_AD9911_LO_MRSET;



endmodule
