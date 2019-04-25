#include "isounder_z.h"




isounder::isounder()
{
}

isounder::~isounder()
{
}

void isounder::setProbeParam(ProbeParams p)
{
    this->probeParams = p;
}

void isounder::setProbeParam(E_probe_mode PM ,FrequencyParams FP)
{
    this->probeParams.timingParams = {0, 0, 0, 0, 0, 0, 0};
    this->probeParams.codeParams.code_type = E_code_type::CCode;
    this->probeParams.codeParams.code_number = 2;
    this->probeParams.codeParams.code_length = 16;
    this->probeParams.codeParams.code_duration = 256;
    this->probeParams.codeParams.pulse_lenght = 320;
    this->probeParams.codeParams.codes[0] = isounder::createCode(C16ACode, 16);
    this->probeParams.codeParams.codes[1] = isounder::createCode(C16BCode, 16);

    this->probeParams.frequencyParams = FP;
    this->probeParams.probe_mode = PM;
    this->probeParams.trigger_mode = E_trigger_mode::immediately;

}

void isounder::writeProbeParam()
{
    write_data(ADDR_probe_mode  , (unsigned int)(this->probeParams).probe_mode);
    write_data(ADDR_trigger_mode  , (unsigned int)(this->probeParams).trigger_mode);
    write_data(ADDR_timing_year  , (this->probeParams).timingParams.year);
    write_data(ADDR_timing_mouth  , (this->probeParams).timingParams.mouth);
    write_data(ADDR_timing_day  , (this->probeParams).timingParams.day);
    write_data(ADDR_timing_hour  , (this->probeParams).timingParams.hour);
    write_data(ADDR_timing_minutes  , (this->probeParams).timingParams.minutes);
    write_data(ADDR_timing_second  , (this->probeParams).timingParams.second);
    write_data(ADDR_frequency_mode , (unsigned int)(this->probeParams).frequencyParams.frequency_mode);
    write_data(ADDR_starting_freqw , (this->probeParams).frequencyParams.starting_freqw);
    write_data(ADDR_stepping_freqw , (this->probeParams).frequencyParams.stepping_freqw);
    write_data(ADDR_stepping_number , (this->probeParams).frequencyParams.stepping_number);
    write_data(ADDR_repetition_number , (this->probeParams).frequencyParams.repetition_number);
    write_data(ADDR_code_type , (unsigned int)(this->probeParams).codeParams.code_type);
    write_data(ADDR_code_number , (this->probeParams).codeParams.code_number);
    write_data(ADDR_code_length , (this->probeParams).codeParams.code_length);
    write_data(ADDR_code_duration , (this->probeParams).codeParams.code_duration);
    write_data(ADDR_pulse_lenght , (this->probeParams).codeParams.pulse_lenght);

    for (unsigned int i = 0; i < (this->probeParams).codeParams.code_number; ++i)
    {
        write_data(ADDR_codes+i , (this->probeParams).codeParams.codes[i]);
    }
    
}

void isounder::resetDDS()
{
    write_data(ADDR_init_dds, 0);
    write_data(ADDR_init_dds, 1);
}

void isounder::resetProbe()
{
    write_data(ADDR_reset_n_probe, 0);
    write_data(ADDR_reset_n_probe, 1);
}
void isounder::resetAll()
{
    write_data(ADDR_all_reset_n, 0);
    write_data(ADDR_all_reset_n, 1);
}

void isounder::startProbe()
{
    write_data(ADDR_start_probe, 1);
}


void isounder::stopProbe()
{
    write_data(ADDR_start_probe, 0);
}


bool isounder::getCurProbeStatus()
{
    return read_data(ADDR_probe_status);
}

void isounder::resetDevice()
{
    write_data(ADDR_all_reset_n, 0);
    write_data(ADDR_all_reset_n, 1);
}


void isounder::setSwDelay()
{
    write_data(ADDR_pre_delay_GEN           , 5*256);
    write_data(ADDR_pre_delay_LO_MA         , 1);
    write_data(ADDR_pre_delay_Filter_Switch , 1);
    uint32_t duration_LO_MA = this->probeParams.codeParams.code_length * this->probeParams.codeParams.code_duration;
    
    write_data(ADDR_post_delay_LO_MA        , 5*256 + duration_LO_MA + 6*256);
    write_data(ADDR_post_delay_Filter_Switch, 5*256 + duration_LO_MA + 1*256);
}


void isounder::useDefaultValue(bool LO_MA, bool SW)
{
    write_data(ADDR_default_LO_MA, (unsigned int)LO_MA);
    write_data(ADDR_default_RECEIVE_SW, (unsigned int)SW);
}

GPSParams isounder::getCurGPSParams()
{
    GPSParams G;
    G.lockded = read_data(ADDR_GPS_lockded);
    G.year = read_data(ADDR_GPS_year);
    G.mouth = read_data(ADDR_GPS_mouth);
    G.day = read_data(ADDR_GPS_day);
    G.hour = read_data(ADDR_GPS_hour);
    G.minutes = read_data(ADDR_GPS_minutes);
    G.second = read_data(ADDR_GPS_second);
    G.nanosecond = read_data(ADDR_GPS_nanosecond);
    G.latitude = read_data(ADDR_GPS_latitude);
    G.longitude = read_data(ADDR_GPS_longitude);
    G.height = read_data(ADDR_GPS_height);
    G.altitude = read_data(ADDR_GPS_altitude);
    G.visible_satellites = read_data(ADDR_GPS_visible_satellites);
    G.tracking_satellites = read_data(ADDR_GPS_tracking_satellites);
    return G;
}


unsigned int isounder::createCode(const int *code, unsigned int len)
{
    unsigned int C = 0;
    
    if (len>32) 
    {
        return 0;    
    }

    for (unsigned int i = 0; i < len; ++i)
    {
        if (*(code+i)==1)
        {
            C |= (0x00000001 << i);
        }
    }

    return C;
}

// C,1,2.000000_50.000000_20.000000,16_320_1,20161222_111100,22.74N_101.05E,ch_1.cos
void isounder::init()
{
    TimingParams     TP = {0, 0, 0, 0, 0, 0, 0};
    FrequencyParams  FP;
    CodeParams       CP;
    ProbeParams      PP;

    FP.frequency_mode = E_frequency_mode::single;
    FP.starting_freqw = AD9911_FREQW_FACTOR*2;      // 2    MHz
    FP.stepping_freqw = AD9911_FREQW_FACTOR*0.05;   // 0.05 MHz
    FP.stepping_number = 360;
    FP.repetition_number = 1;

    CP.code_type = E_code_type::CCode;
    CP.code_number = 2;
    CP.code_length = 16;
    CP.code_duration = 256;
    CP.pulse_lenght = 320;
    CP.codes[0] = isounder::createCode(C16ACode, 16);
    CP.codes[1] = isounder::createCode(C16BCode, 16);


    PP.trigger_mode = E_trigger_mode::immediately;
    PP.probe_mode = E_probe_mode::close;
    PP.timingParams = TP;
    PP.frequencyParams = FP;
    PP.codeParams = CP;
    
    this->probeParams = PP;
}


void isounder::show()
{
    printf("trigger_mode          %d \n" ,(this->probeParams).trigger_mode);
    printf("probe_mode            %d \n" ,(this->probeParams).probe_mode);
       
    printf("year                  %d \n" ,(this->probeParams).timingParams.year);
    printf("mouth                 %d \n" ,(this->probeParams).timingParams.mouth);
    printf("day                   %d \n" ,(this->probeParams).timingParams.day);
    printf("hour                  %d \n" ,(this->probeParams).timingParams.hour);
    printf("minutes               %d \n" ,(this->probeParams).timingParams.minutes);
    printf("second                %d \n" ,(this->probeParams).timingParams.second);

    printf("frequency_mode        %d \n" ,(this->probeParams).frequencyParams.frequency_mode);
    printf("starting_freqw        %d \n" ,(this->probeParams).frequencyParams.starting_freqw);
    printf("stepping_freqw        %d \n" ,(this->probeParams).frequencyParams.stepping_freqw);
    printf("stepping_number       %d \n" ,(this->probeParams).frequencyParams.stepping_number);
    printf("repetition_number     %d \n" ,(this->probeParams).frequencyParams.repetition_number);

    printf("code_type             %d \n" ,(this->probeParams).codeParams.code_type);
    printf("code_number           %d \n" ,(this->probeParams).codeParams.code_number);
    printf("code_length           %d \n" ,(this->probeParams).codeParams.code_length);
    printf("code_duration         %d \n" ,(this->probeParams).codeParams.code_duration);
    printf("pulse_lenght          %d \n" ,(this->probeParams).codeParams.pulse_lenght);

    printf("codes                 %d \n" ,(this->probeParams).codeParams.codes[0]);
    printf("codes                 %d \n" ,(this->probeParams).codeParams.codes[1]);

}

void isounder::sendGotSignal()
{
    write_data(ADDR_got, 1);
}

bool isounder::isSampled()
{
    return (read_data(ADDR_sampled) == 1);
}

bool isounder::saveDataFromDevice()
{
    
    unsigned int stepping_number    =  this->probeParams.frequencyParams.stepping_number;  // S
    unsigned int repetition_number  =  this->probeParams.frequencyParams.repetition_number;// R
    unsigned int code_number        =  this->probeParams.codeParams.code_number;           // C
    unsigned int pulse_lenght       =  this->probeParams.codeParams.pulse_lenght;          // P
    unsigned int S = 0;  
    unsigned int R = 0; 
    unsigned int C = 0; 
    unsigned int P = 0; 
    unsigned int *data = new unsigned int[pulse_lenght];
    short Idata = 0;
    short Qdata = 0;


    char fileName[256]; 

    if (this->probeParams.frequencyParams.frequency_mode == E_frequency_mode::scan)
    {
        sprintf(fileName, "/home/root/C,%d,2_50_20,16_320_1,20161222_111100,22.74N_101.05E,ch_1.cos", repetition_number);
  
    }
    else
    {
        sprintf(fileName, "/home/root/C,%d,%d,16_320_1,20170618_201050,30.54N_114.37E,ch_1.sos",this->probeParams.frequencyParams.starting_freqw/AD9911_FREQW_FACTOR,repetition_number);
 
    }

    FILE *fp = NULL;
    fp = fopen(fileName, "wb");

    
    for(S = 0; S < stepping_number; S++)
    {   
        for(R = 0; R < repetition_number; R++)
        {   
            for(C = 0; C < code_number; C++)
            {   
                while(!isSampled());
                for(P = 0; P < pulse_lenght; P++)
                {
                    data[P] = readRawData(P);
                }
                fwrite(data, sizeof(unsigned int) , pulse_lenght, fp );
                this->sendGotSignal();
            }
        }
        printf("curS: %d\r",S);
        fflush(stdout);
    }
    
    printf("\n-------------end-------------\n");
    //fclose(fp);
    delete [] data;
    return true;
}

unsigned int isounder::readRawData(unsigned int addr)
{
    return read_data(500+addr);
}