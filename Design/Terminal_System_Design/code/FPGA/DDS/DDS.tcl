# FILE: DDS.tcl
# NAME: RF GPS PIN DEFINE
# DATE: 2018-10-16
#       _____ZYL


#================================================================================================
# CLOCK_IN
#================================================================================================
# CLOCK_10M from  (CH2 ocxo 10MHz)
# CLOCK_40M from  (CH1 extenal J3=10MHZ via CDCV304 -> 40MHZ)

set_location_assignment PIN_AB11   -to    CLOCK_10M
set_location_assignment PIN_AB12   -to    CLOCK_40M 

#================================================================================================
# CLOCK_IN_SELECT
#================================================================================================
# CLOCK_SELECT[0] == ~CLOCK_SELECT[1]
# CLOCK_SELECT[0] = 0 ---> CH2(extenal J3)
# CLOCK_SELECT[0] = 1 ---> CH1(ocxo 10MHz)

set_location_assignment PIN_AB10   -to    CLOCK_SELECT[0]
set_location_assignment PIN_AA9    -to    CLOCK_SELECT[1]

#================================================================================================
# 1x4 LED
#================================================================================================
set_location_assignment PIN_W22    -to    LED[0] 
set_location_assignment PIN_V22    -to    LED[1]
set_location_assignment PIN_U22    -to    LED[2]
set_location_assignment PIN_R22    -to    LED[3]

#================================================================================================
# GPS interfaces
#================================================================================================
set_location_assignment PIN_Y21    -to    GPS_RX
set_location_assignment PIN_Y22    -to    GPS_TX
set_location_assignment PIN_AA22   -to    GPS_1PPS 
set_location_assignment PIN_AA21   -to    GPS_RTCM_IN

#================================================================================================
# DAC 8531 interfaces
#================================================================================================
set_location_assignment PIN_AB13   -to    DAC8531_CLK
set_location_assignment PIN_AA13   -to    DAC8531_DIN
set_location_assignment PIN_AA14   -to    DAC8531_CS 



#================================================================================================
# DDS AD9911_LOCAL interfaces
#================================================================================================
#                                         AD9911_LO_SYNC_IN
#                                         AD9911_LO_SYNC_OUT
#                                         AD9911_LO_SYNC_CLK
set_location_assignment PIN_A15    -to    AD9911_LO_CS
set_location_assignment PIN_A20    -to    AD9911_LO_PD
set_location_assignment PIN_B14    -to    AD9911_LO_UPDATE
set_location_assignment PIN_B19    -to    AD9911_LO_MRSET 
set_location_assignment PIN_B15    -to    AD9911_LO_SCLK
set_location_assignment PIN_A16    -to    AD9911_LO_SDIO[0]
set_location_assignment PIN_B16    -to    AD9911_LO_SDIO[1]
set_location_assignment PIN_A17    -to    AD9911_LO_SDIO[2]
set_location_assignment PIN_B18    -to    AD9911_LO_SDIO[3]
set_location_assignment PIN_C13    -to    AD9911_LO_P[0]
set_location_assignment PIN_A13    -to    AD9911_LO_P[1]
set_location_assignment PIN_B13    -to    AD9911_LO_P[2]
set_location_assignment PIN_A14    -to    AD9911_LO_P[3]

set_location_assignment PIN_B20    -to    SW_AD9911_LO

#    PIN          DIRCTION          DEFINE          DEFAULT   
# ---------------------------------------------------------------
#    SYNC_IN      *
#    SYNC_OUT     *
#    SYNC_CLK     *
#    CS           FPGA -> DDS                       0 enable
#    PD           FPGA -> DDS                       0 power-down
#    UPDATE       FPGA -> DDS
#    MRSET        FPGA -> DDS
#    SCLK         FPGA -> DDS
#    SDIO[0]      FPGA -> DDS
#    SDIO[1]      FPGA <> DDS
#    SDIO[2]      FPGA <> DDS
#    SDIO[3]      FPGA <> DDS
#    P[0]         FPGA -> DDS
#    P[1]         FPGA -> DDS
#    P[2]         FPGA -> DDS
#    P[3]         FPGA -> DDS
#    SW_AD9911    FPGA -> DDS                       0 enable



#================================================================================================
# DDS AD9911_RF interfaces
#================================================================================================
#                                        AD9911_RF_SYNC_IN
#                                        AD9911_RF_SYNC_OUT
#                                        AD9911_RF_SYNC_CLK
set_location_assignment PIN_A5    -to    AD9911_RF_CS
set_location_assignment PIN_A9    -to    AD9911_RF_PD
set_location_assignment PIN_B5    -to    AD9911_RF_UPDATE
set_location_assignment PIN_B9    -to    AD9911_RF_MRSET 
set_location_assignment PIN_B6    -to    AD9911_RF_SCLK
set_location_assignment PIN_A6    -to    AD9911_RF_SDIO[0]
set_location_assignment PIN_B7    -to    AD9911_RF_SDIO[1]
set_location_assignment PIN_A7    -to    AD9911_RF_SDIO[2]
set_location_assignment PIN_B8    -to    AD9911_RF_SDIO[3]
set_location_assignment PIN_B3    -to    AD9911_RF_P[0]
set_location_assignment PIN_A3    -to    AD9911_RF_P[1]
set_location_assignment PIN_B4    -to    AD9911_RF_P[2]
set_location_assignment PIN_A4    -to    AD9911_RF_P[3]

set_location_assignment PIN_C10   -to    SW_AD9911_RF

#================================================================================================
#  RF to AD
#================================================================================================
# set_location_assignment PIN_V1    -to    COM_AD_RF[0]
# set_location_assignment PIN_V2    -to    COM_AD_RF[1]
# set_location_assignment PIN_V3    -to    COM_AD_RF[2]
# set_location_assignment PIN_U1    -to    COM_AD_RF[3]
# set_location_assignment PIN_U2    -to    COM_AD_RF[4]
# set_location_assignment PIN_T3    -to    COM_AD_RF[5]
# set_location_assignment PIN_R1    -to    COM_AD_RF[6]
# set_location_assignment PIN_R2    -to    COM_AD_RF[7]
# set_location_assignment PIN_T1    -to    COM_AD_RF[8]
# set_location_assignment PIN_P2    -to    COM_AD_RF[9]
# set_location_assignment PIN_P3    -to    COM_AD_RF[10]
# set_location_assignment PIN_P4    -to    COM_AD_RF[11]
# set_location_assignment PIN_N1    -to    COM_AD_RF[12]
# set_location_assignment PIN_N2    -to    COM_AD_RF[13]
# set_location_assignment PIN_P1    -to    COM_AD_RF[14]
# set_location_assignment PIN_M1    -to    COM_AD_RF[15]
# set_location_assignment PIN_M2    -to    COM_AD_RF[16]
# set_location_assignment PIN_M3    -to    COM_AD_RF[17]

set_location_assignment PIN_V1    -to    COM_AD_RF_GPS_RX
set_location_assignment PIN_V2    -to    COM_AD_RF_GPS_TX
set_location_assignment PIN_V3    -to    COM_AD_RF_GPS_1PPS
set_location_assignment PIN_U1    -to    COM_AD_RF_DAC8531_CLK
set_location_assignment PIN_U2    -to    COM_AD_RF_DAC8531_DIN
set_location_assignment PIN_T3    -to    COM_AD_RF_DAC8531_CS 
set_location_assignment PIN_R1    -to    COM_AD_RF_AD9911_RF_UPDATE
set_location_assignment PIN_R2    -to    COM_AD_RF_AD9911_RF_SCLK
set_location_assignment PIN_T1    -to    COM_AD_RF_AD9911_RF_SDIO0
set_location_assignment PIN_P2    -to    COM_AD_RF_AD9911_RF_P1
set_location_assignment PIN_P3    -to    COM_AD_RF_AD9911_RF_P3
set_location_assignment PIN_P4    -to    COM_AD_RF_AD9911_LO_UPDATE
set_location_assignment PIN_N1    -to    COM_AD_RF_AD9911_LO_SCLK
set_location_assignment PIN_N2    -to    COM_AD_RF_AD9911_LO_SDIO0
set_location_assignment PIN_P1    -to    COM_AD_RF_AD9911_RF_MRSET 
set_location_assignment PIN_M1    -to    COM_AD_RF_AD9911_LO_MRSET 



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
# IO_STANDARD
#================================================================================================
set_instance_assignment -name IO_STANDARD "2.5-V" -to CLOCK_10M
set_instance_assignment -name IO_STANDARD "2.5-V" -to CLOCK_40M 
set_instance_assignment -name IO_STANDARD "2.5-V" -to CLOCK_SELECT[0]
set_instance_assignment -name IO_STANDARD "2.5-V" -to CLOCK_SELECT[1]
set_instance_assignment -name IO_STANDARD "2.5-V" -to LED[0] 
set_instance_assignment -name IO_STANDARD "2.5-V" -to LED[1]
set_instance_assignment -name IO_STANDARD "2.5-V" -to LED[2]
set_instance_assignment -name IO_STANDARD "2.5-V" -to LED[3]
set_instance_assignment -name IO_STANDARD "2.5-V" -to GPS_RX
set_instance_assignment -name IO_STANDARD "2.5-V" -to GPS_TX
set_instance_assignment -name IO_STANDARD "2.5-V" -to GPS_1PPS 
set_instance_assignment -name IO_STANDARD "2.5-V" -to GPS_RTCM_IN
set_instance_assignment -name IO_STANDARD "2.5-V" -to DAC8531_CLK
set_instance_assignment -name IO_STANDARD "2.5-V" -to DAC8531_DIN
set_instance_assignment -name IO_STANDARD "2.5-V" -to DAC8531_CS 
set_instance_assignment -name IO_STANDARD "2.5-V" -to AD9911_LO_CS
set_instance_assignment -name IO_STANDARD "2.5-V" -to AD9911_LO_PD
set_instance_assignment -name IO_STANDARD "2.5-V" -to AD9911_LO_UPDATE
set_instance_assignment -name IO_STANDARD "2.5-V" -to AD9911_LO_MRSET 
set_instance_assignment -name IO_STANDARD "2.5-V" -to AD9911_LO_SCLK
set_instance_assignment -name IO_STANDARD "2.5-V" -to AD9911_LO_SDIO[0]
set_instance_assignment -name IO_STANDARD "2.5-V" -to AD9911_LO_SDIO[1]
set_instance_assignment -name IO_STANDARD "2.5-V" -to AD9911_LO_SDIO[2]
set_instance_assignment -name IO_STANDARD "2.5-V" -to AD9911_LO_SDIO[3]
set_instance_assignment -name IO_STANDARD "2.5-V" -to AD9911_LO_P[0]
set_instance_assignment -name IO_STANDARD "2.5-V" -to AD9911_LO_P[1]
set_instance_assignment -name IO_STANDARD "2.5-V" -to AD9911_LO_P[2]
set_instance_assignment -name IO_STANDARD "2.5-V" -to AD9911_LO_P[3]
set_instance_assignment -name IO_STANDARD "2.5-V" -to SW_AD9911_LO
set_instance_assignment -name IO_STANDARD "2.5-V" -to AD9911_RF_CS
set_instance_assignment -name IO_STANDARD "2.5-V" -to AD9911_RF_PD
set_instance_assignment -name IO_STANDARD "2.5-V" -to AD9911_RF_UPDATE
set_instance_assignment -name IO_STANDARD "2.5-V" -to AD9911_RF_MRSET 
set_instance_assignment -name IO_STANDARD "2.5-V" -to AD9911_RF_SCLK
set_instance_assignment -name IO_STANDARD "2.5-V" -to AD9911_RF_SDIO[0]
set_instance_assignment -name IO_STANDARD "2.5-V" -to AD9911_RF_SDIO[1]
set_instance_assignment -name IO_STANDARD "2.5-V" -to AD9911_RF_SDIO[2]
set_instance_assignment -name IO_STANDARD "2.5-V" -to AD9911_RF_SDIO[3]
set_instance_assignment -name IO_STANDARD "2.5-V" -to AD9911_RF_P[0]
set_instance_assignment -name IO_STANDARD "2.5-V" -to AD9911_RF_P[1]
set_instance_assignment -name IO_STANDARD "2.5-V" -to AD9911_RF_P[2]
set_instance_assignment -name IO_STANDARD "2.5-V" -to AD9911_RF_P[3]
set_instance_assignment -name IO_STANDARD "2.5-V" -to SW_AD9911_RF

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
set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_RF_AD9911_RF_MRSET
set_instance_assignment -name IO_STANDARD "2.5-V" -to COM_AD_RF_AD9911_LO_MRSET

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