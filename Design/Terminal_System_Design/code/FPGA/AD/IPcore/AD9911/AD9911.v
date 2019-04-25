/*

Fo = FTW * Fs / 2^32



Address Offset   |    Name    |      Description
----------------------------------------------------------------
0x00	              CSR            Channel Select Register
0x01	              FR1	         Function Register 1
0x02	              FR2	         Function Register 2
0x03	              CFR	         Channel Function
0x04	              CTW0	         Channel Frequency Tuning Word 0
0x05	              CPOW0	         Channel Phase1 Offset Word 0
0x06	              ACR	         Amplitude Control
0x07	              LSR	         Linear Sweep Ramp Rate
0x08	              RDW	         LSR Rising Delta
0x09	              FDW	         LSR Falling Delta
0x0A	              CTW1	         Channel Word 1
0x0B	              CTW2	         Channel Word 2
0x0C	              CTW3	         Channel Word 3
0x0D	              CTW4	         Channel Word 4
0x0E	              CTW5	         Channel Word 5
0x0F	              CTW6	         Channel Word 6
0x10	              CTW7	         Channel Word 7
0x11	              CTW8	         Channel Word 8
0x12	              CTW9	         Channel Word 9
0x13	              CTW10	         Channel Word 10
0x14	              CTW11	         Channel Word 11
0x15	              CTW12	         Channel Word 12
0x16	              CTW13	         Channel Word 13
0x17	              CTW14	         Channel Word 14
0x18	              CTW15	         Channel Word 15

ref : AD9911 DATASHEET__35p

=======================================================================================================

CSR <0> LSB-first
    @value:
        0    accepts data in MSB-first format (default)
        1    accepts data in LSB-first format

CSR <2:1> I/O mode select
    @value:
        00    single bit serial (2-wire mode)
        01    single bit serial (3-wire mode)
        10    2-bit mode
        11    4-bit mode

CSR <3> 0
    @descr:
        must be cleared to 0

CSR <7:4> channel enable bits
    @descr:
        bits are active immediately once written. They do not require an I/O update to take effect
    @value:
        0000    only auxiliary Channel 0 receives commands from the channel registers and profile registers
        0010    only primary Channel 1 receives commands from the channel registers and profile registers
        0011    both Channel 0 and Channel 1 receive commands from the channel registers and profile registers

=======================================================================================================

FR1 <1> Manual hardware synchronization bit
    @value:
        0    the manual hardware synchronization feature is inactive (default)
        1    the manual hardware synchronization feature is active

FR1 <2> Test-tone modulation enable
    @value:
        0    disables (default)
        1    enables

FR1 <3> open

FR1 <4> DAC reference power-down
    @value:
        0    The DAC reference is enabled (default)
        1    DAC reference is disabled and powered down

FR1 <5> SYNC_CLK disable
    @value:
        0    the SYNC_CLK pin is active (default)
        1    The SYNC_CLK pin assumes a static Logic 0 state (disabled). The pin drive logic is shut down. The synchronization circuitry remains active internally (necessary for normal device operation)

FR1 <6> external power-down mode
    @value:
        0    The external power-down mode is in the fast recovery power-down mode. When the PWR_DWN_CTL input pin is high, the digital logic and the DAC digital logic are powered down. The DACs bias circuitry, PLL, oscillator, and clock input circuitry are not powered down (default)
        1    The external power down mode is in the full power-down mode. When the PWR_DWN_CTL input pin is high, all functions are powered down. This includes the DAC and PLL, which take a significant amount of time to power up

FR1 <7> clock input power-down
    @value:
        0    The clock input circuitry is enabled for operation (default)
        1    The clock input circuitry is disabled and is in a low power dissipation state

FR1 <9:8> modulation level bits
    @descr:
        The modulation (FSK, PSK, and ASK) level bits control the level (2/4/8/16) of modulation to be performed. See Table 7 for settings.
    @value:
        00    2-level modulation
        01    4-level modulation
        10    8-level modulation
        11    16-level modulation

FR1 <11:10> RU/RD(ramp up/ramp down) bits
    @value:
        00    RU/RD disabled
        01    Profile Pin 2 and Pin 3 configured for RU/RD operation
        10    Profile Pin 3 configured for RU/RD operation
        11    SDIO Pin 1, Pin 2, and Pin 3 configured for RU/RD operation, Forces the I/O to be used only in 1-bit mode


*/

module AD9911(
    input     wire              CLK,
    input     wire              RESET_N,
    output    wire              AD_CS,        // 0
    output    wire              AD_PD,         // 0
    output    wire              AD_UPDATE,
    output    reg               AD_MRSET,
    output    wire              AD_SCLK,
    output    wire   [ 3:0]     AD_SDIO,
    output    wire   [ 3:0]     AD_P,
    output    wire              SW_AD_LO      // 0
    );

    assign AD_PD = 0;
    //assign AD_P  = 4'b0001;
    assign SW_AD_LO = 0;

    reg  [ 7:0]   ADDR = 0;
    reg  [31:0]   DATA = 0;
    reg           TR = 0;

    wire          OVER;


    reg  [ 3:0]  state = 0;
    reg  [31:0]  REGS[20:0];
    reg  [ 3:0]  NUM = 0;

    /********** CSR **********/
    parameter LSB_first                  = 1'b0;     // MSB mdoe
    parameter mode_select                = 2'b00;    // Single bit serial mode (2-wire mode)
    parameter channel_select             = 4'b0010;  // only primary Channel 1 receives commands from the channel and profile registers

    /********** FR1 **********/
    parameter manual_software_sync       = 1'b0;
    parameter manual_hardware_sync       = 1'b0;
    parameter test_tone_en               = 1'b0;
    parameter DAC_ref_powerdown          = 1'b0;
    parameter sync_clk_disable           = 1'b0;
    parameter external_powerdown_mode    = 1'b0;
    parameter ref_clkinput_powerdown     = 1'b0;
    parameter modulation_level           = 2'b00;    // 2-level modulation
    parameter RURD                       = 2'b00;    
    parameter profile_pin_config         = 3'b000;   // P1 - CH1
    parameter charge_pump_ctrl           = 2'b11;    // 110 charge pump current is 150 uA
    parameter PLL_div                    = 5'd12;    // fer_sysclk : M
    parameter VCO_gain                   = 1'b1;     // FR1 <23> = 0 (default), the low range (system clock below 160 MHz). FR1 <23> = 1, the high range (system clock above 255 MHz).

    /********** CFR **********/
    parameter sin_wave                   = 1'b0;     // 0:cos  1:sin
    parameter clr_phase_acc              = 1'b0;
    parameter auto_clr_phase_acc         = 1'b0;
    parameter clr_sweep_acc              = 1'b0;
    parameter auto_clr_sweep_acc         = 1'b0;
    parameter pipe_delay                 = 1'b0;
    parameter DAC_powerdown              = 1'b0;
    parameter digital_powerdown          = 1'b0;
    parameter DAC_scale                  = 2'b11;    // 11: Full-scale
    parameter load_SRR_at_update         = 1'b0;
    parameter linear_sweep               = 1'b0;
    parameter linear_sweep_nodwell       = 1'b0;
    parameter data_align_spuklmode       = 3'b000;
    parameter A_F_P                      = 2'b11;    // [premise : linear_sweep = 1]  00:N/A    01:Amplitude sweep   10:Frequency sweep   11:Phase sweep

    /********** CTW0 **********/
    parameter  frequency_tuning_word     = 8947848.5*65; //fre_out : f*2^32/(M*40)

    /********** CPOW0 **********/
    parameter phase_offset_word          = 14'd0;

    /********** ACR **********/
    parameter amplitude_scale_factor     = 10'd500;  // [0-1023]
    parameter load_ARR_at_update         = 1'b1;
    parameter RURD_en                    = 1'b1;     // [premise: amplitude_multiplier_en = 1]
    parameter amplitude_multiplier_en    = 1'b1;
    parameter in_de_stepsize             = 2'b11;    // 00:1  01:2  10:4  11:8
    parameter amplitude_ramp_rate        = 8'd1;     // [0-255]


/*
    initial begin
        REGS[0] <= {{24'b0},{4'b1111 & channel_select},{1'b0 },{2'b11 & mode_select},{1'b1 & LSB_first}}; //CSR
        REGS[1] <= {{8'b0},{1'b1 & VCO_gain},{5'b11111 & PLL_div},{2'b11 & charge_pump_ctrl},{1'b0 },{3'b111 & profile_pin_config},{2'b11 & RURD},{2'b11 & modulation_level },{1'b1 & ref_clkinput_powerdown},{1'b1 & external_powerdown_mode},{1'b1 & sync_clk_disable},{1'b1 & DAC_ref_powerdown},{1'b0 },{1'b1 & test_tone_en},{1'b1 & manual_hardware_sync},{1'b1 & manual_software_sync}}; //FR1
        REGS[2] <= 0; //FR2
        REGS[3] <= {{8'b0 },{2'b11 & A_F_P},{3'b000 },{3'b111 & data_align_spuklmode},{1'b1 & linear_sweep_nodwell},{1'b1 & linear_sweep},{1'b1 & load_SRR_at_update},{3'b000 },{2'b11 & DAC_scale},{1'b1 & digital_powerdown},{1'b1 & DAC_powerdown},{1'b1 & pipe_delay},{1'b1 & auto_clr_sweep_acc},{1'b1 & clr_sweep_acc},{1'b1 & auto_clr_phase_acc},{1'b1 & clr_phase_acc},{1'b1 & sin_wave}}; //CFR
        REGS[4] <= frequency_tuning_word;//CTW0
        REGS[5] <= {16'b0, 2'b00, 14'b11111111111111 & phase_offset_word}; //CPOW0
        REGS[6] <= {{8'b0 },{8'b11111111 & amplitude_ramp_rate},{2'b11 & in_de_stepsize},{1'b0 },{1'b1 & amplitude_multiplier_en},{1'b1 & RURD_en}, {1'b1 & load_ARR_at_update},{10'b1111111111 & amplitude_scale_factor}}; //ACR
        REGS[7] <= 0; //LSR
        REGS[8] <= 0; //RDW
        REGS[9] <= 0; //FDW
        REGS[10]<= 32'b10000000_00000000_00000000_00000000; //CTW1
    end
*/

    initial begin
        REGS[0] <= 32'b00000000_00000000_00000000_00100000; //CSR
        REGS[1] <= 32'b00000000_10110011_00000100_00000000; //FR1
        REGS[2] <= 0;                                  //FR2
        REGS[3] <= 32'b00000000_11000000_00000011_00000000; //CFR
        REGS[4] <= 8947849*2;//f/480*2^32                 //CTW0
        REGS[5] <= 0;                                       //CPOW0
        REGS[6] <= 32'b00000000_00000001_11011111_11111111; //ACR
        REGS[7] <= 32'b00000000_00000000_00000000_00000000; //LSR
        REGS[8] <= 32'b00000000_00000000_00000000_00000000; //RDW
        REGS[9] <= 32'b00000000_00000000_00000000_00000000; //FDW
        REGS[10]<= 32'b10000000_00000000_00000000_00000000; //CTW1
    end


    always @(posedge CLK) begin
        if (!RESET_N) begin
            AD_MRSET <= 1;
            NUM <= 0;
            state <= 0;
            TR <= 0;
        end else begin
            case (state)
                0 :
                    begin
                        AD_MRSET <= 0;
                        NUM <= 0;
                        state <= 1;
                    end
                1 :
                    begin
                        if (NUM>=11) begin
                            state <= 15;
                        end else begin
                            state <= 2;
                        end
                    end
                2 :
                    begin
                        ADDR = NUM;
                        DATA = REGS[NUM];
                        state <= 3;
                    end
                3 :
                    begin
                        TR <= 1;
                        state <= 4;
                    end
                4 :
                    begin
                        NUM <= NUM+1;
                        state <= 5;
                    end
                5 :
                    begin
                        if (OVER) begin
                            state <= 1;
                        end else begin
                            TR <= 0;
                        end
                    end
                //default: state <= 0;
            endcase
        end
    end



    AD9911_DATA_ACCESS ins1(
        .CLK         (CLK),
        .RESET_N     (RESET_N),
      //.R_W         (),
        .TR          (TR),
        .REG_ADDR    (ADDR),
        .DATA_IN     (DATA),
      //.DATA_OUT    (),
        .AD_CS       (AD_CS),
        .AD_SCLK     (AD_SCLK),
        .AD_SDIO0    (AD_SDIO[0]),
        .AD_UPADTE   (AD_UPDATE),
        .OVER        (OVER)
    );


endmodule
