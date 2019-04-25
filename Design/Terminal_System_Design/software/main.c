#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>
#include <time.h>
#include <math.h>
#include <sys/mman.h>
#include <stdbool.h>
// #include "hwlib.h"
// #include "socal/socal.h"
// #include "socal/hps.h"
#include <pthread.h>
#include "isounder_z.h"
#include "hw.h"
  
extern volatile unsigned int *sysID;
// sounder2  C
//
//
int main(int argc, char **argv)
{
    isounder IS;

    if (!init_hps())
    {
        
        printf("init_hps fail !\n");
        exit(1);
    }

    printf("sysID: %X \n", *sysID);

    if (argc == 9 && (argv[2][0] == 'C' || argv[2][0] == 'c'))
    {
        uint32_t repetition_number = (uint32_t)atoi(argv[3]);
        double starting_freq = (double)atof(argv[4]);
        double steping_freq  = (double)atof(argv[5]);
        double ending_freq   = (double)atof(argv[6]);
        uint32_t def0   = (uint32_t)atoi(argv[7]);
        uint32_t def1   = (uint32_t)atoi(argv[8]);
        uint32_t starting_freqw = AD9911_FREQW_FACTOR*starting_freq;
        uint32_t stepping_freqw  = AD9911_FREQW_FACTOR*steping_freq;
        uint32_t stepping_number = (ending_freq-starting_freq)/steping_freq;

        E_probe_mode PM = (E_probe_mode)atoi(argv[1]);

        FrequencyParams FP;
        FP.frequency_mode = E_frequency_mode::scan;
        FP.starting_freqw = starting_freqw;
        FP.stepping_freqw = stepping_freqw;
        FP.stepping_number = stepping_number;
        FP.repetition_number = repetition_number;

        IS.setProbeParam(PM,FP);
        IS.show();
        
        IS.resetAll();  
        IS.stopProbe();  
        IS.resetProbe();
        IS.resetDDS();
        IS.writeProbeParam();
        IS.useDefaultValue(def0,def1);
        IS.setSwDelay();

        printf("loading! \n\n\n");
        IS.startProbe();
        IS.saveDataFromDevice();
        
    }
    else if (argc == 5 && (argv[2][0] == 'S' || argv[2][0] == 's'))
    {
        uint32_t repetition_number = (uint32_t)atoi(argv[3]);
        double starting_freq = (double)atof(argv[4]);
        uint32_t starting_freqw = AD9911_FREQW_FACTOR*starting_freq;
        E_probe_mode PM = (E_probe_mode)atoi(argv[1]);
        
        FrequencyParams FP;
        FP.frequency_mode = E_frequency_mode::single;
        FP.starting_freqw = starting_freqw;
        FP.stepping_freqw = 0;
        FP.stepping_number = 1;
        FP.repetition_number = repetition_number;
        IS.setProbeParam(PM,FP);
        IS.show();
        
        IS.resetAll();  
        IS.stopProbe();  
        IS.resetProbe();
        IS.resetDDS();
        IS.writeProbeParam();
        IS.useDefaultValue(true, false);
        IS.setSwDelay();
        printf("loading! \n\n");
        IS.startProbe();
        IS.saveDataFromDevice();
        
    }
    else
    {
        printf("--------------------------------------------------------------------------------\n");
        printf("sounder2   [1]   [2]   [3]   [4]   [5]   [6] \n");
        printf("  [1]: probe_mode       | (1)send/recv (2)send (3)near-recv (4)far-recv (5)close\n");
        printf("  [2]: frequency_mode   | (S)single (C)scan \n");
        printf("  [3]: repetition_number| 1 ~ 1024   \n");
        printf("  [4]: starting_freq    | 0 ~ 60 MHZ \n");
        printf("  [5]: steping_freq     | 0 ~ 1  MHZ \n");
        printf("  [6]: ending_freq      | 1 ~ 60 MHZ \n");

        printf("Example: \n");
        printf("  single frequency probe example: ./sounder2 5 S 32 2 \n");
        printf("    scan frequency probe example: ./sounder2 5 C 32 2 0.05 20 0 0\n");
        printf("--------------------------------------------------------------------------------\n");
    }

    

    return !term_hps();

}

/*
        10,000,000
320 * 256 = 81,920

61.03515625


*/