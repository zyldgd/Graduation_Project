#include <iostream>
#include <string>
#include <Cmath>
#include "hw.h"

#ifndef _ISOUNDER_Z_H
#define _ISOUNDER_Z_H


const int C16ACode[16] = { 1, 1, -1, 1, 1, 1, 1, -1,  1, -1, -1, -1,  1, -1,  1,  1 };
const int C16BCode[16] = { 1, 1, -1, 1, 1, 1, 1, -1, -1,  1,  1,  1, -1,  1, -1, -1 };

enum class E_trigger_mode : unsigned int
{
    immediately = 1,
    GPStrigger = 2
};

enum class E_probe_mode : unsigned int
{ 
    send_recv = 1,
    only_send = 2,
    near_recv = 3,
    far_recv = 4,
    close = 5
};

enum class E_frequency_mode : unsigned int
{
    single = 1,
    multi = 2,
    scan = 3
};

enum class E_code_type : unsigned int
{
    M_sequ = 1,// M-sequence
    CCode = 2, // complementary code
    CCCode = 3 // completely complementary code
};


typedef struct TimingParams
{
    unsigned int zone;
    unsigned int year;
    unsigned int mouth;
    unsigned int day;
    unsigned int hour;
    unsigned int minutes;
    unsigned int second;
} TimingParams;


typedef struct FrequencyParams
{
    E_frequency_mode frequency_mode;
    unsigned int     starting_freqw;
    unsigned int     stepping_freqw;
    unsigned int     stepping_number;
    unsigned int     repetition_number;
} FrequencyParams;


typedef struct CodeParams
{
    E_code_type  code_type;
    unsigned int code_number;
    unsigned int code_length;
    unsigned int code_duration;
    unsigned int pulse_lenght;
    unsigned int codes[32];
} CodeParams;


typedef struct ProbeParams
{
    E_trigger_mode   trigger_mode;
    E_probe_mode     probe_mode;
    TimingParams     timingParams;
    FrequencyParams  frequencyParams;
    CodeParams       codeParams;
} ProbeParams;

typedef struct GPSParams
{
    unsigned int lockded;
    unsigned int year;
    unsigned int mouth;
    unsigned int day;
    unsigned int hour;
    unsigned int minutes;
    unsigned int second;
    unsigned int nanosecond;
    unsigned int latitude;
    unsigned int longitude;
    unsigned int height;
    unsigned int altitude;
    unsigned int visible_satellites;
    unsigned int tracking_satellites;
} GPSParams;

class isounder
{
private:
    ProbeParams probeParams;

public:
    isounder();
    ~isounder();
    void setProbeParam(ProbeParams p);
    void setProbeParam(E_probe_mode PM ,FrequencyParams FP);
    void writeProbeParam();
    void startProbe();
    void stopProbe();
    void resetDDS();
    void resetProbe();
    void resetAll();
    void resetDevice();
    void setSwDelay();
    void useDefaultValue(bool LO_MA, bool SW);
    bool getCurProbeStatus();
    GPSParams getCurGPSParams();
    static unsigned int createCode(const int *code, unsigned int len);
    void init();
    void show();
    void sendGotSignal();
    bool isSampled();
    bool saveDataFromDevice();
    unsigned int readRawData(unsigned int addr);

};




#endif