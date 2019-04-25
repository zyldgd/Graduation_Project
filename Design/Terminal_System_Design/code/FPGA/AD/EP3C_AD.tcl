# FILE: EP3C_AD.tcl
# NAME: AD USB PIN DEFINE
# DATE: 2018-10-16
#       _____ZYL


#================================================================================================
# FPGA CLOCK IN
#================================================================================================
set_location_assignment PIN_G1     -to    CLOCK_50M
set_location_assignment PIN_A11    -to    CLOCK_10M
#================================================================================================
# 2x6 LED
#================================================================================================
set_location_assignment PIN_V8     -to    LED[0] 
set_location_assignment PIN_W8     -to    LED[1]
set_location_assignment PIN_W6     -to    LED[2]
set_location_assignment PIN_W7     -to    LED[3]
set_location_assignment PIN_AA8    -to    LED[4]
set_location_assignment PIN_AA9    -to    LED[5] 
set_location_assignment PIN_Y8     -to    LED[6] 
set_location_assignment PIN_Y7     -to    LED[7] 
set_location_assignment PIN_Y6     -to    LED[8] 
set_location_assignment PIN_AB10   -to    LED[9] 
set_location_assignment PIN_AB9    -to    LED[10] 
set_location_assignment PIN_AB8    -to    LED[11]

#================================================================================================
# AD to Analog front-end
#================================================================================================
set_location_assignment PIN_V2     -to    FLITER_SELECT[0]
set_location_assignment PIN_W1     -to    FLITER_SELECT[1]
set_location_assignment PIN_W2     -to    FLITER_SELECT[2]
set_location_assignment PIN_Y1     -to    FLITER_TRIGGER

#================================================================================================
# AD to DE1
#================================================================================================
set_location_assignment PIN_AB6    -to    COM_AD_DE1[0]
set_location_assignment PIN_AA6    -to    COM_AD_DE1[1]
set_location_assignment PIN_AB5    -to    COM_AD_DE1[2]
set_location_assignment PIN_AA5    -to    COM_AD_DE1[3]
set_location_assignment PIN_AA4    -to    COM_AD_DE1[4]
set_location_assignment PIN_AB4    -to    COM_AD_DE1[5] 
set_location_assignment PIN_AA3    -to    COM_AD_DE1[6] 
set_location_assignment PIN_AB3    -to    COM_AD_DE1[7] 
set_location_assignment PIN_AA1    -to    COM_AD_DE1[8] 
set_location_assignment PIN_Y2     -to    COM_AD_DE1[9] 
set_location_assignment PIN_V1     -to    COM_AD_DE1[10]
set_location_assignment PIN_AA2    -to    COM_AD_DE1[11]

#================================================================================================
# AD to RF
#================================================================================================
# set_location_assignment PIN_Y10    -to    COM_AD_RF[0]
# set_location_assignment PIN_W10    -to    COM_AD_RF[1]
# set_location_assignment PIN_Y13    -to    COM_AD_RF[2]
# set_location_assignment PIN_Y14    -to    COM_AD_RF[3]
# set_location_assignment PIN_W14    -to    COM_AD_RF[4]
# set_location_assignment PIN_AB13   -to    COM_AD_RF[5]
# set_location_assignment PIN_AA13   -to    COM_AD_RF[6]
# set_location_assignment PIN_AA14   -to    COM_AD_RF[7]
# set_location_assignment PIN_AB15   -to    COM_AD_RF[8]
# set_location_assignment PIN_AB16   -to    COM_AD_RF[9]
# set_location_assignment PIN_AA16   -to    COM_AD_RF[10]
# set_location_assignment PIN_AA17   -to    COM_AD_RF[11]
# set_location_assignment PIN_AB18   -to    COM_AD_RF[12]
# set_location_assignment PIN_M19    -to    COM_AD_RF[13]
# set_location_assignment PIN_M20    -to    COM_AD_RF[14]
# set_location_assignment PIN_K19    -to    COM_AD_RF[15]
# set_location_assignment PIN_H19    -to    COM_AD_RF[16]
# set_location_assignment PIN_F20    -to    COM_AD_RF[17]

set_location_assignment PIN_Y10      -to    COM_AD_RF_GPS_RX
set_location_assignment PIN_W10      -to    COM_AD_RF_GPS_TX
set_location_assignment PIN_Y13      -to    COM_AD_RF_GPS_1PPS
set_location_assignment PIN_Y14      -to    COM_AD_RF_DAC8531_CLK
set_location_assignment PIN_W14      -to    COM_AD_RF_DAC8531_DIN
set_location_assignment PIN_AB13     -to    COM_AD_RF_DAC8531_CS 
set_location_assignment PIN_AA13     -to    COM_AD_RF_AD9911_RF_UPDATE
set_location_assignment PIN_AA14     -to    COM_AD_RF_AD9911_RF_SCLK
set_location_assignment PIN_AB15     -to    COM_AD_RF_AD9911_RF_SDIO0
set_location_assignment PIN_AB16     -to    COM_AD_RF_AD9911_RF_P1
set_location_assignment PIN_AA16     -to    COM_AD_RF_AD9911_RF_P3
set_location_assignment PIN_AA17     -to    COM_AD_RF_AD9911_LO_UPDATE
set_location_assignment PIN_AB18     -to    COM_AD_RF_AD9911_LO_SCLK
set_location_assignment PIN_M19      -to    COM_AD_RF_AD9911_LO_SDIO0
set_location_assignment PIN_M20      -to    COM_AD_RF_AD9911_RF_MRSET
set_location_assignment PIN_K19      -to    COM_AD_RF_AD9911_LO_MRSET

#     DEFINE          AD         RF
# -------------------------------------------------------
#   COM_AD_RF[0]      Y10        V1             GPS_RX
#   COM_AD_RF[1]      W10        V2             GPS_TX
#   COM_AD_RF[2]      Y13        V3             GPS_1PPS
#   COM_AD_RF[3]      Y14        U1             DAC8531_CLK
#   COM_AD_RF[4]      W14        U2             DAC8531_DIN
#   COM_AD_RF[5]      AB13       T3             DAC8531_CS 
#   COM_AD_RF[6]      AA13       R1             AD9911_RF_UPDATE
#   COM_AD_RF[7]      AA14       R2             AD9911_RF_SCLK
#   COM_AD_RF[8]      AB15       T1             AD9911_RF_SDIO[0]
#   COM_AD_RF[9]      AB16       P2             AD9911_RF_P[1]
#   COM_AD_RF[10]     AA16       P3             AD9911_RF_P[3]
#   COM_AD_RF[11]     AA17       P4             AD9911_LO_UPDATE
#   COM_AD_RF[12]     AB18       N1             AD9911_LO_SCLK
#   COM_AD_RF[13]     M19        N2             AD9911_LO_SDIO[0]
#   COM_AD_RF[14]     M20        P1             AD9911_RF_MRSET
#   COM_AD_RF[15]     K19        M1             AD9911_LO_MRSET
#   COM_AD_RF[16]     H19        M2             
#   COM_AD_RF[17]     F20        M3     


#================================================================================================
# ADC LTC2202 interfaces 
#================================================================================================
set_location_assignment PIN_AA21   -to    LTC2202_DATA[15]
set_location_assignment PIN_Y22    -to    LTC2202_DATA[14]
set_location_assignment PIN_W21    -to    LTC2202_DATA[13]
set_location_assignment PIN_W22    -to    LTC2202_DATA[12]
set_location_assignment PIN_V21    -to    LTC2202_DATA[11]
set_location_assignment PIN_V22    -to    LTC2202_DATA[10]
set_location_assignment PIN_U21    -to    LTC2202_DATA[9]
set_location_assignment PIN_U22    -to    LTC2202_DATA[8]
set_location_assignment PIN_R21    -to    LTC2202_DATA[7]
set_location_assignment PIN_R22    -to    LTC2202_DATA[6]
set_location_assignment PIN_P21    -to    LTC2202_DATA[5]
set_location_assignment PIN_P22    -to    LTC2202_DATA[4]
set_location_assignment PIN_N21    -to    LTC2202_DATA[3]
set_location_assignment PIN_N22    -to    LTC2202_DATA[2]
set_location_assignment PIN_M21    -to    LTC2202_DATA[1]
set_location_assignment PIN_M22    -to    LTC2202_DATA[0]
set_location_assignment PIN_T22    -to    LTC2202_CLKOUT_n
set_location_assignment PIN_T21    -to    LTC2202_CLKOUT_p



#================================================================================================
# IO_STANDARD
#================================================================================================
set_instance_assignment -name IO_STANDARD "2.5-V" -to CLOCK_50M
set_instance_assignment -name IO_STANDARD "2.5-V" -to CLOCK_10M

set_instance_assignment -name IO_STANDARD "2.5-V" -to LED[0] 
set_instance_assignment -name IO_STANDARD "2.5-V" -to LED[1]
set_instance_assignment -name IO_STANDARD "2.5-V" -to LED[2]
set_instance_assignment -name IO_STANDARD "2.5-V" -to LED[3]
set_instance_assignment -name IO_STANDARD "2.5-V" -to LED[4]
set_instance_assignment -name IO_STANDARD "2.5-V" -to LED[5] 
set_instance_assignment -name IO_STANDARD "2.5-V" -to LED[6] 
set_instance_assignment -name IO_STANDARD "2.5-V" -to LED[7] 
set_instance_assignment -name IO_STANDARD "2.5-V" -to LED[8] 
set_instance_assignment -name IO_STANDARD "2.5-V" -to LED[9] 
set_instance_assignment -name IO_STANDARD "2.5-V" -to LED[10] 
set_instance_assignment -name IO_STANDARD "2.5-V" -to LED[11]

set_instance_assignment -name IO_STANDARD "2.5-V" -to FLITER_SELECT[0]
set_instance_assignment -name IO_STANDARD "2.5-V" -to FLITER_SELECT[1]
set_instance_assignment -name IO_STANDARD "2.5-V" -to FLITER_SELECT[2]
set_instance_assignment -name IO_STANDARD "2.5-V" -to FLITER_TRIGGER

set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_DE1[0]
set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_DE1[1]
set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_DE1[2]
set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_DE1[3]
set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_DE1[4]
set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_DE1[5] 
set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_DE1[6] 
set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_DE1[7] 
set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_DE1[8] 
set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_DE1[9] 
set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_DE1[10]
set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_DE1[11]



set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_RF_GPS_RX
set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_RF_GPS_TX
set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_RF_GPS_1PPS
set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_RF_DAC8531_CLK
set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_RF_DAC8531_DIN
set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_RF_DAC8531_CS 
set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_RF_AD9911_RF_UPDATE
set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_RF_AD9911_RF_SCLK
set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_RF_AD9911_RF_SDIO0
set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_RF_AD9911_RF_P1
set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_RF_AD9911_RF_P3
set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_RF_AD9911_LO_UPDATE
set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_RF_AD9911_LO_SCLK
set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_RF_AD9911_LO_SDIO0
set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_RF_AD9911_LO_P1
set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_RF_AD9911_LO_P3

# set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_RF[0]
# set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_RF[1]
# set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_RF[2]
# set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_RF[3]
# set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_RF[4]
# set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_RF[5]
# set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_RF[6]
# set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_RF[7]
# set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_RF[8]
# set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_RF[9]
# set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_RF[10]
# set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_RF[11]
# set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_RF[12]
# set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_RF[13]
# set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_RF[14]
# set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_RF[15]
# set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_RF[16]
# set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_RF[17]

set_instance_assignment -name IO_STANDARD "2.5-V" -to LTC2202_DATA[15]
set_instance_assignment -name IO_STANDARD "2.5-V" -to LTC2202_DATA[14]
set_instance_assignment -name IO_STANDARD "2.5-V" -to LTC2202_DATA[13]
set_instance_assignment -name IO_STANDARD "2.5-V" -to LTC2202_DATA[12]
set_instance_assignment -name IO_STANDARD "2.5-V" -to LTC2202_DATA[11]
set_instance_assignment -name IO_STANDARD "2.5-V" -to LTC2202_DATA[10]
set_instance_assignment -name IO_STANDARD "2.5-V" -to LTC2202_DATA[9]
set_instance_assignment -name IO_STANDARD "2.5-V" -to LTC2202_DATA[8]
set_instance_assignment -name IO_STANDARD "2.5-V" -to LTC2202_DATA[7]
set_instance_assignment -name IO_STANDARD "2.5-V" -to LTC2202_DATA[6]
set_instance_assignment -name IO_STANDARD "2.5-V" -to LTC2202_DATA[5]
set_instance_assignment -name IO_STANDARD "2.5-V" -to LTC2202_DATA[4]
set_instance_assignment -name IO_STANDARD "2.5-V" -to LTC2202_DATA[3]
set_instance_assignment -name IO_STANDARD "2.5-V" -to LTC2202_DATA[2]
set_instance_assignment -name IO_STANDARD "2.5-V" -to LTC2202_DATA[1]
set_instance_assignment -name IO_STANDARD "2.5-V" -to LTC2202_DATA[0]
set_instance_assignment -name IO_STANDARD "2.5-V" -to LTC2202_CLKOUT_n
set_instance_assignment -name IO_STANDARD "2.5-V" -to LTC2202_CLKOUT_p


