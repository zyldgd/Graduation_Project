#include <stdio.h>
#include <iostream>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>
#include <time.h>
#include <math.h>
#include <sys/mman.h>
#include <stdbool.h>

#ifndef _HW_H
#define _HW_H

#define HW_REGS_BASE (0xC0000000)
#define HW_REGS_SPAN (0x04000000)
#define HW_REGS_MASK (HW_REGS_SPAN - 1)


#define AD9911_FREQW_FACTOR               8947849
/*****************************************************************************/

#define ADDR_all_reset_n                  0
#define ADDR_got                          1

#define ADDR_probe_status                 10
#define ADDR_wr_over                      11
#define ADDR_sampled                      12

#define ADDR_sys_ctrl_regs                100
#define ADDR_start_probe                  101
#define ADDR_reset_n_probe                102
#define ADDR_init_dds                     103

#define ADDR_trigger_mode                 110
#define ADDR_timing                       111
#define ADDR_timing_year                  112
#define ADDR_timing_mouth                 113
#define ADDR_timing_day                   114
#define ADDR_timing_hour                  115
#define ADDR_timing_minutes               116
#define ADDR_timing_second                117

#define ADDR_probe_mode                   120
#define ADDR_probe_interval               121
#define ADDR_groups_number                122
#define ADDR_repetition_number            123
#define ADDR_frequency_mode               124
#define ADDR_starting_freqw               125
#define ADDR_stepping_freqw               126
#define ADDR_stepping_number              127
#define ADDR_code_type                    128
#define ADDR_code_number                  129
#define ADDR_code_length                  130
#define ADDR_code_duration                131
#define ADDR_pulse_lenght                 132
#define ADDR_codes                        133
#define ADDR_codes_end                    164

#define ADDR_pre_delay_GEN                170

#define ADDR_pre_delay_LO_MA              172                     
#define ADDR_post_delay_LO_MA             173                      
#define ADDR_pre_delay_Filter_Switch      174                             
#define ADDR_post_delay_Filter_Switch     175                              
#define ADDR_default_LO_MA                176                         
#define ADDR_default_RECEIVE_SW           177                              
/*
#define ADDR_beforeMA                     170	    
#define ADDR_afterMA                      171	   
#define ADDR_LO_MA_SW_en                  172	   
*/
#define ADDR_LO_CSR                       200
#define ADDR_LO_FR1                       201
#define ADDR_LO_FR2                       202
#define ADDR_LO_CFR                       203
#define ADDR_LO_CTW0                      204
#define ADDR_LO_CPOW0                     205
#define ADDR_LO_ACR                       206
#define ADDR_LO_LSR                       207
#define ADDR_LO_RDW                       208
#define ADDR_LO_FDW                       209
#define ADDR_LO_CTW1                      210
#define ADDR_LO_CTW2                      211
#define ADDR_LO_CTW3                      212
#define ADDR_LO_CTW4                      213
#define ADDR_LO_CTW5                      214
#define ADDR_LO_CTW6                      215
#define ADDR_LO_CTW7                      216
#define ADDR_LO_CTW8                      217
#define ADDR_LO_CTW9                      218
#define ADDR_LO_CTW10                     219
#define ADDR_LO_CTW11                     220
#define ADDR_LO_CTW12                     221
#define ADDR_LO_CTW13                     222
#define ADDR_LO_CTW14                     223
#define ADDR_LO_CTW15                     224

#define ADDR_RF_CSR                       230
#define ADDR_RF_FR1                       231
#define ADDR_RF_FR2                       232
#define ADDR_RF_CFR                       233
#define ADDR_RF_CTW0                      234
#define ADDR_RF_CPOW0                     235
#define ADDR_RF_ACR                       236
#define ADDR_RF_LSR                       237
#define ADDR_RF_RDW                       238
#define ADDR_RF_FDW                       239
#define ADDR_RF_CTW1                      240
#define ADDR_RF_CTW2                      241
#define ADDR_RF_CTW3                      242
#define ADDR_RF_CTW4                      243
#define ADDR_RF_CTW5                      244
#define ADDR_RF_CTW6                      245
#define ADDR_RF_CTW7                      246
#define ADDR_RF_CTW8                      247
#define ADDR_RF_CTW9                      248
#define ADDR_RF_CTW10                     249
#define ADDR_RF_CTW11                     250
#define ADDR_RF_CTW12                     251
#define ADDR_RF_CTW13                     252
#define ADDR_RF_CTW14                     253
#define ADDR_RF_CTW15                     254
// read-only
#define ADDR_GPS_lockded                  300
#define ADDR_GPS_year                     301
#define ADDR_GPS_mouth                    302
#define ADDR_GPS_day                      303
#define ADDR_GPS_hour                     304
#define ADDR_GPS_minutes                  305
#define ADDR_GPS_second                   306
#define ADDR_GPS_nanosecond               307
#define ADDR_GPS_latitude                 308
#define ADDR_GPS_longitude                309
#define ADDR_GPS_height                   310
#define ADDR_GPS_altitude                 311
#define ADDR_GPS_visible_satellites       312
#define ADDR_GPS_tracking_satellites      313

#define ADDR_frequency_accuracy           320

#define ADDR_sampled_receive              499 // !
#define ADDR_sampled_data_regs            500

/*****************************************************************************/

using namespace std;

extern void *virtual_base;
extern volatile unsigned int *LED;
extern volatile unsigned int *sysID;
extern volatile unsigned int *CTRL;
extern int fd;

bool init_hps();
bool term_hps();
bool write_data(unsigned int addrOffset, unsigned int data);
unsigned int read_data(unsigned int addrOffset);


#endif
