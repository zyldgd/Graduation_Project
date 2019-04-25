/*
SIGNAL.v  186
RECEIVER.v  16

*/

module EXECUT(
    input     wire               CLOCK_10M,
    input     wire               RESET_N,

    input     wire               START,
    input     wire               UART_OVER,
    input     wire     [15:0]    AD_DATA,

    input     wire     [ 7:0]    PROBE_MODE,    //1: send & receive  2: send-only    3: receive-only   4:close test 
    input     wire     [31:0]    FREQW ,        // freq words
    input     wire     [31:0]    FREQW_STEP,
    input     wire     [15:0]    STEP_NUM,
    input     wire     [15:0]    SFT,               //  signle freq times    //input     wire     [15:0]    NG,  //  number of group

    input     wire     [31:0]    CODE0,
    input     wire     [31:0]    CODE1,
    input     wire     [31:0]    CODE2,
    input     wire     [31:0]    CODE3,
    input     wire     [ 1:0]    CODE_NUM,
    input     wire     [ 7:0]    CODE_LEN,
    input     wire     [15:0]    PULSE_LEN,

    output    wire               LO_CS,  
    output    wire               LO_PD,  
    output    wire               LO_UPDATE,
    output    wire               LO_MRSET,
    output    wire               LO_SCLK,
    output    wire   [ 3:0]      LO_SDIO,
    output    wire   [ 3:0]      LO_P,
 
    output    wire               RF_CS,  
    output    wire               RF_PD,  
    output    wire               RF_UPDATE,
    output    wire               RF_MRSET,
    output    wire               RF_SCLK,
    output    wire   [ 3:0]      RF_SDIO,
    output    wire   [ 3:0]      RF_P,
 
    output    wire    [ 2:0]     FLITER_SELECT,
    output    wire               FLITER_TR,
    output    reg                OVER
    );


    reg   [ 3:0]  state = 0;

    reg   [ 7:0]  probeMode = 0;
    reg   [15:0]  pulseLen = 0;
    reg   [ 7:0]  codeLen = 0;

    reg   [31:0]  code [3:0];
    reg   [31:0]  curCode = 0;

    reg   [ 1:0]  codeNum = 0;
    reg   [ 1:0]  curCodeNum = 0;

    reg   [31:0]  freqw = 0;
    reg   [31:0]  curFreqw = 0;

    reg   [31:0]  freqwStep = 0;
    reg   [31:0]  curFreqwStep = 0;

    reg   [15:0]  stepNum = 0;
    reg   [15:0]  curStepNum = 0;

    reg   [15:0]  sft = 0;
    reg   [15:0]  curSFT = 0;


    reg           SIGNAL_RESET_N = 0; 
    reg           SIGNAL_RF_OUTPUT_EN = 0;
    reg           SIGNAL_GEN = 0;
    wire          SIGNAL_GEN_OVER;
    reg   [31:0]  SIGNAL_FREQW = 0;
    reg           SIGNAL_FREQW_UPDATE = 0;
    wire          SIGNAL_FREQW_UPDATE_OVER;
    reg   [31:0]  SIGNAL_CODE = 0;
    reg   [ 7:0]  SIGNAL_CODE_LEN = 0;
    reg   [15:0]  SIGNAL_PULSE_LEN = 0;


    reg   [15:0]  delay = 0;
    wire RE_BUSY;

    initial begin
        OVER <= 1;
    end

/*
* CODE_NUM  = 2 : A & B
* SFT       = n
* STEP_NUM  = N
*
*
*
*      |-----------------------   STEP_NUM   -----------------------|
*      ┌──┐┌──┐     ┌──┐┌──┐                    ┌──┐┌──┐     ┌──┐┌──┐                                   
*      │A1││B1│ ... │An││Bn│                    │A1││B1│ ... │An││Bn│                                   
*  ────┘  └┘  └─────┘  └┘  └────────────────────┘  └┘  └─────┘  └┘  └──────────────
*             FREQW_0                ...               FREQW_N
*/


    always @(posedge CLOCK_10M or negedge RESET_N) begin
        if (!RESET_N) begin
            state <= 0;
            SIGNAL_RESET_N <= 0;
            SIGNAL_GEN <= 0;
            OVER <= 1;
            delay <= 0;
        end else begin
            case (state)
                0 : begin
                        OVER <= 1;
                        SIGNAL_GEN     <= 0;
                        SIGNAL_RESET_N <= 1;
                        delay          <= delay+1;
                        if (delay>2000) begin // delay 200us for AD9911 being stable
                            state <= 1;
                        end
                    end
                1 : begin
                        if (START) begin
                            probeMode    <= PROBE_MODE;
                            pulseLen     <= PULSE_LEN;
                            codeLen      <= CODE_LEN;
                            code[0]      <= CODE0;
                            code[1]      <= CODE1;
                            code[2]      <= CODE2;
                            code[3]      <= CODE3;
                            curCode      <= 0;

                            codeNum      <= CODE_NUM;   // 码长
                            curCodeNum   <= 0;

                            freqw        <= FREQW;      // 起始频率
                            curFreqw     <= FREQW;

                            freqwStep    <= FREQW_STEP; // 步进频率
                            curFreqwStep <= 0;

                            stepNum      <= STEP_NUM;   // 步进次数
                            curStepNum   <= 0;

                            sft          <= SFT;
                            curSFT       <= 0;

                            OVER <= 0;
                            state <= 2;
                        end else begin
                            OVER <= 1;
                        end
                    end
                2 : begin
                        //1: send & receive    2: send-only    3: receive-only    4: close test 
                        if (probeMode == 1 || probeMode == 2 || probeMode == 4) begin
                            SIGNAL_RF_OUTPUT_EN <= 1;
                            state <= 3;
                        end else if (probeMode == 3) begin
                            SIGNAL_RF_OUTPUT_EN <= 0;
                            state <= 3;
                        end else begin
                            state <= 0;
                        end
                    end
                3 : begin // 扫频频点 3 - 11
                        if (curStepNum < stepNum) begin
                            state <= 4;
                        end else begin
                            OVER <= 1;
                            state <= 12;
                        end
                    end
                4 : begin // 更新频率字 4 - 7
                        if (SIGNAL_FREQW_UPDATE_OVER) begin
                            SIGNAL_FREQW <= curFreqw;
                            SIGNAL_CODE_LEN <= codeLen;
                            SIGNAL_PULSE_LEN <= pulseLen;
                            state <= 5;
                        end
                    end
                5 : begin
                        SIGNAL_FREQW_UPDATE <= 1;
                        state <= 6;
                    end
                6 : begin
                        state <= 7;
                    end
                7 : begin
                        SIGNAL_FREQW_UPDATE <= 0;
                        curSFT <= 0;
                        if (SIGNAL_FREQW_UPDATE_OVER) begin
                            state <= 8;
                        end
                    end
                8 : begin // 单点发送 8 - 11
                        if (curSFT < sft) begin
                            curCodeNum <= 0;
                            state <= 9;
                        end else begin
                            curStepNum <= curStepNum+1;
                            curFreqw <= curFreqw + freqwStep;
                            state <= 3;//^
                        end
                    end
                9 : begin // 发送码字 9 - 11
                        if (curCodeNum < codeNum) begin
                            SIGNAL_CODE <= code[curCodeNum];
                            state <= 10;
                        end else begin
                            curSFT <= curSFT+1;
                            state <= 8;//^
                        end
                    end
                10: begin // 产生信号 10 - 11
                        if (SIGNAL_GEN_OVER) begin //if (SIGNAL_GEN_OVER & SIGNAL_FREQW_UPDATE_OVER & !RE_BUSY) begin
                            curCodeNum <= curCodeNum+1;
                            SIGNAL_GEN <= 1;
                            state <= 11;
                        end
                    end
                11: begin
                        if (SIGNAL_GEN_OVER) begin
                            if (!SIGNAL_GEN) begin
                                state <= 9;//^
                            end
                        end else begin
                            SIGNAL_GEN <= 0;
                        end
                    end
                12: begin
                        OVER <= 1;
                        state <= 1;//^                       
                    end
                default: state <= 0;
            endcase
        end      
    end



    FLITER_SW FLITER_SW0(
        .CLOCK_10M             (CLOCK_10M),
        .SW_EN                 (RESET_N),
        .PROBE_MODE            (probeMode),
        .GEN                   (SIGNAL_GEN),
        .MA                    (RF_P[3]),
        .FLITER_TR             (FLITER_TR)
    );

    FLITERS_SELECT FLITERS_SELECT0(
        .FREQW                 (SIGNAL_FREQW),
        .FLITER_SELECT         (FLITER_SELECT)
    );


    SIGNAL SIGNAL0(
        .CLOCK_10M              (CLOCK_10M),
        .RESET_N                (SIGNAL_RESET_N),

        .RF_OUTPUT_EN           (SIGNAL_RF_OUTPUT_EN),
        .GEN                    (SIGNAL_GEN),
        .GEN_OVER               (SIGNAL_GEN_OVER),  
        
        .FREQW                  (SIGNAL_FREQW),
        .FREQW_UPDATE           (SIGNAL_FREQW_UPDATE),
        .FREQW_UPDATE_OVER      (SIGNAL_FREQW_UPDATE_OVER),
        .CODE                   (SIGNAL_CODE),
        .CODE_LEN               (SIGNAL_CODE_LEN),
        .PULSE_LEN              (SIGNAL_PULSE_LEN),

        .LO_CS                  (LO_CS    ),  
        .LO_PD                  (LO_PD    ),  
        .LO_UPDATE              (LO_UPDATE),
        .LO_MRSET               (LO_MRSET ),
        .LO_SCLK                (LO_SCLK  ),
        .LO_SDIO                (LO_SDIO  ),
        .LO_P                   (LO_P     ),

        .RF_CS                  (RF_CS    ),  
        .RF_PD                  (RF_PD    ),  
        .RF_UPDATE              (RF_UPDATE),
        .RF_MRSET               (RF_MRSET ),
        .RF_SCLK                (RF_SCLK  ),
        .RF_SDIO                (RF_SDIO  ),
        .RF_P                   (RF_P     )
    );

    wire  [31:0]  DATA0;
    wire  [31:0]  DATA1;

    RECEIVER RECEIVER0(
        .CLK           (CLOCK_10M),
        .RESET_N       (RESET_N),
        .GEN           (SIGNAL_GEN),
        .PULSE_NUM     (SIGNAL_PULSE_LEN),
        .DATA0         (DATA0),
        .DATA1         (DATA1),
        .VALID         (VALID0),
        .BUSY          (RE_BUSY),
        .ADDR          (),
        .DATA          ()
    );

    DDC ddc0(
        .CLK           (CLOCK_10M),
        .RESET_N       (RESET_N),
        .NCO_PIF       (601295421),//phase increment Frequency : 601295421 - 1.4Mhz
        .AD_DATA       (AD_DATA),
        .DATA0         (DATA0),
        .VALID0        (VALID0),
        .DATA1         (DATA1),
        .VALID1        ()
    );

endmodule

