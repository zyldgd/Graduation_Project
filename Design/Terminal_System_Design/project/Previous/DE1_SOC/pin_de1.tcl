#============================================================
# CLOCK
#============================================================
set_location_assignment PIN_AF14 -to CLOCK_50M
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to CLOCK_50M
set_location_assignment PIN_AA16 -to CLOCK2_50M
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to CLOCK2_50M
set_location_assignment PIN_Y26 -to CLOCK3_50M
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to CLOCK3_50M
set_location_assignment PIN_K14 -to CLOCK4_50M
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to CLOCK4_50M

#============================================================
# SDRAM
#============================================================
set_location_assignment PIN_AK14 -to DRAM_ADDR[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[0]
set_location_assignment PIN_AH14 -to DRAM_ADDR[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[1]
set_location_assignment PIN_AG15 -to DRAM_ADDR[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[2]
set_location_assignment PIN_AE14 -to DRAM_ADDR[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[3]
set_location_assignment PIN_AB15 -to DRAM_ADDR[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[4]
set_location_assignment PIN_AC14 -to DRAM_ADDR[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[5]
set_location_assignment PIN_AD14 -to DRAM_ADDR[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[6]
set_location_assignment PIN_AF15 -to DRAM_ADDR[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[7]
set_location_assignment PIN_AH15 -to DRAM_ADDR[8]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[8]
set_location_assignment PIN_AG13 -to DRAM_ADDR[9]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[9]
set_location_assignment PIN_AG12 -to DRAM_ADDR[10]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[10]
set_location_assignment PIN_AH13 -to DRAM_ADDR[11]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[11]
set_location_assignment PIN_AJ14 -to DRAM_ADDR[12]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[12]
set_location_assignment PIN_AF13 -to DRAM_BA[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_BA[0]
set_location_assignment PIN_AJ12 -to DRAM_BA[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_BA[1]
set_location_assignment PIN_AF11 -to DRAM_CAS_N
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_CAS_N
set_location_assignment PIN_AK13 -to DRAM_CKE
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_CKE
set_location_assignment PIN_AG11 -to DRAM_CS_N
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_CS_N
set_location_assignment PIN_AH12 -to DRAM_CLK
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_CLK
set_location_assignment PIN_AK6 -to DRAM_DQ[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[0]
set_location_assignment PIN_AJ7 -to DRAM_DQ[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[1]
set_location_assignment PIN_AK7 -to DRAM_DQ[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[2]
set_location_assignment PIN_AK8 -to DRAM_DQ[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[3]
set_location_assignment PIN_AK9 -to DRAM_DQ[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[4]
set_location_assignment PIN_AG10 -to DRAM_DQ[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[5]
set_location_assignment PIN_AK11 -to DRAM_DQ[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[6]
set_location_assignment PIN_AJ11 -to DRAM_DQ[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[7]
set_location_assignment PIN_AH10 -to DRAM_DQ[8]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[8]
set_location_assignment PIN_AJ10 -to DRAM_DQ[9]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[9]
set_location_assignment PIN_AJ9 -to DRAM_DQ[10]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[10]
set_location_assignment PIN_AH9 -to DRAM_DQ[11]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[11]
set_location_assignment PIN_AH8 -to DRAM_DQ[12]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[12]
set_location_assignment PIN_AH7 -to DRAM_DQ[13]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[13]
set_location_assignment PIN_AJ6 -to DRAM_DQ[14]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[14]
set_location_assignment PIN_AJ5 -to DRAM_DQ[15]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[15]
set_location_assignment PIN_AB13 -to DRAM_LDQM
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_LDQM
set_location_assignment PIN_AE13 -to DRAM_RAS_N
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_RAS_N
set_location_assignment PIN_AK12 -to DRAM_UDQM
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_UDQM
set_location_assignment PIN_AA13 -to DRAM_WE_N
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_WE_N

#============================================================
# SEG7
#============================================================
set_location_assignment PIN_AE26 -to HEX0[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX0[0]
set_location_assignment PIN_AE27 -to HEX0[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX0[1]
set_location_assignment PIN_AE28 -to HEX0[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX0[2]
set_location_assignment PIN_AG27 -to HEX0[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX0[3]
set_location_assignment PIN_AF28 -to HEX0[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX0[4]
set_location_assignment PIN_AG28 -to HEX0[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX0[5]
set_location_assignment PIN_AH28 -to HEX0[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX0[6]
set_location_assignment PIN_AJ29 -to HEX1[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX1[0]
set_location_assignment PIN_AH29 -to HEX1[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX1[1]
set_location_assignment PIN_AH30 -to HEX1[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX1[2]
set_location_assignment PIN_AG30 -to HEX1[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX1[3]
set_location_assignment PIN_AF29 -to HEX1[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX1[4]
set_location_assignment PIN_AF30 -to HEX1[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX1[5]
set_location_assignment PIN_AD27 -to HEX1[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX1[6]
set_location_assignment PIN_AB23 -to HEX2[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX2[0]
set_location_assignment PIN_AE29 -to HEX2[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX2[1]
set_location_assignment PIN_AD29 -to HEX2[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX2[2]
set_location_assignment PIN_AC28 -to HEX2[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX2[3]
set_location_assignment PIN_AD30 -to HEX2[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX2[4]
set_location_assignment PIN_AC29 -to HEX2[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX2[5]
set_location_assignment PIN_AC30 -to HEX2[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX2[6]
set_location_assignment PIN_AD26 -to HEX3[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX3[0]
set_location_assignment PIN_AC27 -to HEX3[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX3[1]
set_location_assignment PIN_AD25 -to HEX3[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX3[2]
set_location_assignment PIN_AC25 -to HEX3[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX3[3]
set_location_assignment PIN_AB28 -to HEX3[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX3[4]
set_location_assignment PIN_AB25 -to HEX3[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX3[5]
set_location_assignment PIN_AB22 -to HEX3[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX3[6]
set_location_assignment PIN_AA24 -to HEX4[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX4[0]
set_location_assignment PIN_Y23 -to HEX4[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX4[1]
set_location_assignment PIN_Y24 -to HEX4[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX4[2]
set_location_assignment PIN_W22 -to HEX4[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX4[3]
set_location_assignment PIN_W24 -to HEX4[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX4[4]
set_location_assignment PIN_V23 -to HEX4[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX4[5]
set_location_assignment PIN_W25 -to HEX4[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX4[6]
set_location_assignment PIN_V25 -to HEX5[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX5[0]
set_location_assignment PIN_AA28 -to HEX5[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX5[1]
set_location_assignment PIN_Y27 -to HEX5[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX5[2]
set_location_assignment PIN_AB27 -to HEX5[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX5[3]
set_location_assignment PIN_AB26 -to HEX5[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX5[4]
set_location_assignment PIN_AA26 -to HEX5[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX5[5]
set_location_assignment PIN_AA25 -to HEX5[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HEX5[6]

#============================================================
# KEY
#============================================================
set_location_assignment PIN_AA14 -to KEY[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to KEY[0]
set_location_assignment PIN_AA15 -to KEY[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to KEY[1]
set_location_assignment PIN_W15 -to KEY[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to KEY[2]
set_location_assignment PIN_Y16 -to KEY[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to KEY[3]

#============================================================
# LED
#============================================================
set_location_assignment PIN_V16 -to LEDR[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[0]
set_location_assignment PIN_W16 -to LEDR[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[1]
set_location_assignment PIN_V17 -to LEDR[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[2]
set_location_assignment PIN_V18 -to LEDR[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[3]
set_location_assignment PIN_W17 -to LEDR[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[4]
set_location_assignment PIN_W19 -to LEDR[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[5]
set_location_assignment PIN_Y19 -to LEDR[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[6]
set_location_assignment PIN_W20 -to LEDR[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[7]
set_location_assignment PIN_W21 -to LEDR[8]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[8]
set_location_assignment PIN_Y21 -to LEDR[9]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[9]

#============================================================
# SW
#============================================================
set_location_assignment PIN_AB12 -to SW[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[0]
set_location_assignment PIN_AC12 -to SW[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[1]
set_location_assignment PIN_AF9 -to SW[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[2]
set_location_assignment PIN_AF10 -to SW[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[3]
set_location_assignment PIN_AD11 -to SW[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[4]
set_location_assignment PIN_AD12 -to SW[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[5]
set_location_assignment PIN_AE11 -to SW[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[6]
set_location_assignment PIN_AC9 -to SW[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[7]
set_location_assignment PIN_AD10 -to SW[8]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[8]
set_location_assignment PIN_AE12 -to SW[9]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[9]

#============================================================
# HPS
#============================================================
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_ADDR[0]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_ADDR[1]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_ADDR[2]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_ADDR[3]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_ADDR[4]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_ADDR[5]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_ADDR[6]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_ADDR[7]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_ADDR[8]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_ADDR[9]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_ADDR[10]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_ADDR[11]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_ADDR[12]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_ADDR[13]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_ADDR[14]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_BA[0]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_BA[1]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_BA[2]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_DM[0]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_DM[1]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_DM[2]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_DM[3]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_DQ[0]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_DQ[1]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_DQ[2]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_DQ[3]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_DQ[4]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_DQ[5]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_DQ[6]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_DQ[7]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_DQ[8]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_DQ[9]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_DQ[10]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_DQ[11]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_DQ[12]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_DQ[13]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_DQ[14]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_DQ[15]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_DQ[16]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_DQ[17]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_DQ[18]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_DQ[19]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_DQ[20]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_DQ[21]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_DQ[22]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_DQ[23]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_DQ[24]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_DQ[25]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_DQ[26]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_DQ[27]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_DQ[28]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_DQ[29]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_DQ[30]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_DQ[31]
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_CAS_N
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_CKE
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_CS_N
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_ODT
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_RAS_N
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_WE_N
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_RESET_N
set_instance_assignment -name IO_STANDARD "SSTL-15 Class I" -to HPS_DDR3_RZQ
set_instance_assignment -name IO_STANDARD "Differential 1.5-V SSTL Class I" -to HPS_DDR3_DQS_P[0]
set_instance_assignment -name IO_STANDARD "Differential 1.5-V SSTL Class I" -to HPS_DDR3_DQS_N[0]
set_instance_assignment -name IO_STANDARD "Differential 1.5-V SSTL Class I" -to HPS_DDR3_DQS_P[1]
set_instance_assignment -name IO_STANDARD "Differential 1.5-V SSTL Class I" -to HPS_DDR3_DQS_N[1]
set_instance_assignment -name IO_STANDARD "Differential 1.5-V SSTL Class I" -to HPS_DDR3_DQS_P[2]
set_instance_assignment -name IO_STANDARD "Differential 1.5-V SSTL Class I" -to HPS_DDR3_DQS_N[2]
set_instance_assignment -name IO_STANDARD "Differential 1.5-V SSTL Class I" -to HPS_DDR3_DQS_P[3]
set_instance_assignment -name IO_STANDARD "Differential 1.5-V SSTL Class I" -to HPS_DDR3_DQS_N[3]
set_instance_assignment -name IO_STANDARD "Differential 1.5-V SSTL Class I" -to HPS_DDR3_CK_P
set_instance_assignment -name IO_STANDARD "Differential 1.5-V SSTL Class I" -to HPS_DDR3_CK_N
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_GTX_CLK
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_INT_N
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_MDC
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_MDIO
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_RX_CLK
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_RX_DATA[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_RX_DATA[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_RX_DATA[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_RX_DATA[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_RX_DV
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_TX_DATA[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_TX_DATA[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_TX_DATA[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_TX_DATA[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_ENET_TX_EN
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_FLASH_DATA[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_FLASH_DATA[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_FLASH_DATA[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_FLASH_DATA[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_FLASH_DCLK
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_FLASH_NCSO
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_GPIO[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_GPIO[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_GSENSOR_INT
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_I2C1_SCLK
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_I2C1_SDAT
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_I2C2_SCLK
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_I2C2_SDAT
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_I2C_CONTROL
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_KEY
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_LED
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_SD_CLK
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_SD_CMD
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_SD_DATA[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_SD_DATA[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_SD_DATA[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_SD_DATA[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_SPIM_CLK
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_SPIM_MISO
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_SPIM_MOSI
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_SPIM_SS
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_UART_RX
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_UART_TX
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_USB_CLKOUT
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_USB_DATA[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_USB_DATA[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_USB_DATA[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_USB_DATA[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_USB_DATA[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_USB_DATA[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_USB_DATA[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_USB_DATA[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_USB_DIR
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_USB_NXT
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_USB_STP
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to HPS_CONV_USB_N

#============================================================
# GPIO_0, GPIO_0 connect to GPIO Default
#============================================================
set_location_assignment PIN_AC18 -to GPIO0[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO0[0]
set_location_assignment PIN_Y17 -to GPIO0[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO0[1]
set_location_assignment PIN_AD17 -to GPIO0[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO0[2]
set_location_assignment PIN_Y18 -to GPIO0[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO0[3]
set_location_assignment PIN_AK16 -to GPIO0[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO0[4]
set_location_assignment PIN_AK18 -to GPIO0[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO0[5]
set_location_assignment PIN_AK19 -to GPIO0[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO0[6]
set_location_assignment PIN_AJ19 -to GPIO0[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO0[7]
set_location_assignment PIN_AJ17 -to GPIO0[8]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO0[8]
set_location_assignment PIN_AJ16 -to GPIO0[9]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO0[9]
set_location_assignment PIN_AH18 -to GPIO0[10]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO0[10]
set_location_assignment PIN_AH17 -to GPIO0[11]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO0[11]
set_location_assignment PIN_AG16 -to GPIO0[12]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO0[12]
set_location_assignment PIN_AE16 -to GPIO0[13]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO0[13]
set_location_assignment PIN_AF16 -to GPIO0[14]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO0[14]
set_location_assignment PIN_AG17 -to GPIO0[15]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO0[15]
set_location_assignment PIN_AA18 -to GPIO0[16]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO0[16]
set_location_assignment PIN_AA19 -to GPIO0[17]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO0[17]
set_location_assignment PIN_AE17 -to GPIO0[18]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO0[18]
set_location_assignment PIN_AC20 -to GPIO0[19]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO0[19]
set_location_assignment PIN_AH19 -to GPIO0[20]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO0[20]
set_location_assignment PIN_AJ20 -to GPIO0[21]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO0[21]
set_location_assignment PIN_AH20 -to GPIO0[22]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO0[22]
set_location_assignment PIN_AK21 -to GPIO0[23]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO0[23]
set_location_assignment PIN_AD19 -to GPIO0[24]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO0[24]
set_location_assignment PIN_AD20 -to GPIO0[25]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO0[25]
set_location_assignment PIN_AE18 -to GPIO0[26]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO0[26]
set_location_assignment PIN_AE19 -to GPIO0[27]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO0[27]
set_location_assignment PIN_AF20 -to GPIO0[28]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO0[28]
set_location_assignment PIN_AF21 -to GPIO0[29]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO0[29]
set_location_assignment PIN_AF19 -to GPIO0[30]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO0[30]
set_location_assignment PIN_AG21 -to GPIO0[31]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO0[31]
set_location_assignment PIN_AF18 -to GPIO0[32]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO0[32]
set_location_assignment PIN_AG20 -to GPIO0[33]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO0[33]
set_location_assignment PIN_AG18 -to GPIO0[34]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO0[34]
set_location_assignment PIN_AJ21 -to GPIO0[35]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO0[35]

#============================================================
# GPIO_1, GPIO_1 connect to GPIO Default
#============================================================
set_location_assignment PIN_AB17 -to GPIO1[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO1[0]
set_location_assignment PIN_AA21 -to GPIO1[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO1[1]
set_location_assignment PIN_AB21 -to GPIO1[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO1[2]
set_location_assignment PIN_AC23 -to GPIO1[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO1[3]
set_location_assignment PIN_AD24 -to GPIO1[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO1[4]
set_location_assignment PIN_AE23 -to GPIO1[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO1[5]
set_location_assignment PIN_AE24 -to GPIO1[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO1[6]
set_location_assignment PIN_AF25 -to GPIO1[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO1[7]
set_location_assignment PIN_AF26 -to GPIO1[8]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO1[8]
set_location_assignment PIN_AG25 -to GPIO1[9]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO1[9]
set_location_assignment PIN_AG26 -to GPIO1[10]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO1[10]
set_location_assignment PIN_AH24 -to GPIO1[11]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO1[11]
set_location_assignment PIN_AH27 -to GPIO1[12]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO1[12]
set_location_assignment PIN_AJ27 -to GPIO1[13]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO1[13]
# set_location_assignment PIN_AK29 -to GPIO1[14]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO1[14]
# set_location_assignment PIN_AK28 -to GPIO1[15]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO1[15]
# set_location_assignment PIN_AK27 -to GPIO1[16]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO1[16]
# set_location_assignment PIN_AJ26 -to GPIO1[17]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO1[17]
# set_location_assignment PIN_AK26 -to GPIO1[18]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO1[18]
# set_location_assignment PIN_AH25 -to GPIO1[19]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO1[19]
# set_location_assignment PIN_AJ25 -to GPIO1[20]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO1[20]
# set_location_assignment PIN_AJ24 -to GPIO1[21]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO1[21]
# set_location_assignment PIN_AK24 -to GPIO1[22]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO1[22]
# set_location_assignment PIN_AG23 -to GPIO1[23]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO1[23]
# set_location_assignment PIN_AK23 -to GPIO1[24]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO1[24]
# set_location_assignment PIN_AH23 -to GPIO1[25]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO1[25]
set_location_assignment PIN_AK22 -to GPIO1[26]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO1[26]
set_location_assignment PIN_AJ22 -to GPIO1[27]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO1[27]
set_location_assignment PIN_AH22 -to GPIO1[28]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO1[28]
set_location_assignment PIN_AG22 -to GPIO1[29]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO1[29]
set_location_assignment PIN_AF24 -to GPIO1[30]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO1[30]
set_location_assignment PIN_AF23 -to GPIO1[31]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO1[31]
set_location_assignment PIN_AE22 -to GPIO1[32]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO1[32]
set_location_assignment PIN_AD21 -to GPIO1[33]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO1[33]
set_location_assignment PIN_AA20 -to GPIO1[34]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO1[34]
set_location_assignment PIN_AC22 -to GPIO1[35]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to GPIO1[35]



#============================================================
# COM_AD_DE1_0
#============================================================

# GPIO1[14] : COM_AD_DE1_1 
# GPIO1[15] : COM_AD_DE1_0 
# GPIO1[16] : COM_AD_DE1_3 
# GPIO1[17] : COM_AD_DE1_2 
# GPIO1[18] : COM_AD_DE1_5 
# GPIO1[19] : COM_AD_DE1_4 
# GPIO1[20] : COM_AD_DE1_7 
# GPIO1[21] : COM_AD_DE1_6 
# GPIO1[22] : COM_AD_DE1_9 
# GPIO1[23] : COM_AD_DE1_8 
# GPIO1[24] : COM_AD_DE1_11
# GPIO1[25] : COM_AD_DE1_10

set_location_assignment PIN_AK29 -to COM_AD_DE1_1 
set_location_assignment PIN_AK28 -to COM_AD_DE1_0 
set_location_assignment PIN_AK27 -to COM_AD_DE1_3 
set_location_assignment PIN_AJ26 -to COM_AD_DE1_2 
set_location_assignment PIN_AK26 -to COM_AD_DE1_5 
set_location_assignment PIN_AH25 -to COM_AD_DE1_4 
set_location_assignment PIN_AJ25 -to COM_AD_DE1_7 
set_location_assignment PIN_AJ24 -to COM_AD_DE1_6 
set_location_assignment PIN_AK24 -to COM_AD_DE1_9 
set_location_assignment PIN_AG23 -to COM_AD_DE1_8 
set_location_assignment PIN_AK23 -to COM_AD_DE1_11
set_location_assignment PIN_AH23 -to COM_AD_DE1_10
  

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to COM_AD_DE1_0
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to COM_AD_DE1_1
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to COM_AD_DE1_2
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to COM_AD_DE1_3
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to COM_AD_DE1_4
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to COM_AD_DE1_5
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to COM_AD_DE1_6
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to COM_AD_DE1_7
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to COM_AD_DE1_8
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to COM_AD_DE1_9
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to COM_AD_DE1_10
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to COM_AD_DE1_11