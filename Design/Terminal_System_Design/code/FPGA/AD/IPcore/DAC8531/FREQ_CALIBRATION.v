/*
500uHZ : 1

1       10M
10      100M
100     1000M
[35:0] count;u

f=10MHZ
DAC8531 16bit(0~65535) 0~5V
*/

module FREQ_CALIBRATION(
    input   wire                CLOCK_10M,
    input   wire                RESET_N,
    input   wire                GPS_PPS,
    input   wire                GPS_LOCK,
    output  wire                DA_CS,
    output  wire                DA_SCLK,
    output  wire                DA_SDO,
    output  reg    [ 3:0]       PRECISION
    );

   /*
    * [-------------------------------------  Chart Example  -------------------------------------]
    *
    *   10M in 1pps : level 0
    *                   ┌─────────────────┐                                              ┌─────────
    *                   │                 │                                              │         
    *   GPS_PPS  ───────┘                 └──────────────────────────────────────────────┘         
    *
    *                   ┌────────────────────────────────────────────────────────────────┐         
    *                   │ 0 │ 1 │      .........................................     │n-1│ n │       
    *   COUNT    ───────┘                                                                └─────────
    *
    *   err = standard_cnt - n
    *
    *   when (err < 0) : 
    *          n > standard_cnt
    *          Voltage Compensation decrease
    *
    *   when (err > 0) : 
    *          n < standard_cnt
    *          Voltage Compensation increase
    *
    *   when (err = 0) : 
    *          n = standard_cnt
    *          Voltage Compensation reaches standard and adjust the Voltage Compensation further(level ++)
    *
    *   Voltage Compensation = err*factor
    *          level 0 : factor = 2000
    *          level 1 : factor = 400 
    *          level 2 : factor = 80
    *          level 3 : factor = 16
    *
    * [-------------------------------------  Principle  -------------------------------------]
    *
    *  Count the number of CLOCK_10M'cycle in 1s, 5s, 25s and 125s. 
    *  Calculate the error between answer and the standard
    *  Adjust Voltage Compensation according to the error
    */
    
    wire                 OVER;
    reg          [15:0]  DATA = 0; 
    reg                  TR = 0;
    reg                  COUNTING = 0;   
    reg          [31:0]  COUNT;

    reg          [ 3:0]  state = 0;
    reg          [ 1:0]  level = 0;
    reg          [ 7:0]  pps_cnt = 1;

    reg          [ 7:0]  standard_pps[3:0];
    reg          [31:0]  standard_cnt[3:0];
    reg          [ 7:0]  standard_pps_reg;
    reg          [31:0]  standard_cnt_reg;

    reg          [15:0]  factor = 0;
    reg          [31:0]  cnt = 0;
    reg  signed  [15:0]  compensation = 0;// Voltage Compensation
    reg  signed  [31:0]  err = 0;
    reg  signed  [24:0]  ans = 0;


    initial begin
        standard_cnt[0] <= 10000000;     // 10M  in 1pps   : level 0
        standard_cnt[1] <= 50000000;     // 10M  in 5pps   : level 1
        standard_cnt[2] <= 250000000;    // 10M  in 25pps  : level 2
        standard_cnt[3] <= 1250000000;   // 100M in 125pps : level 3

        standard_pps[0] <= 1;  
        standard_pps[1] <= 5;  
        standard_pps[2] <= 25; 
        standard_pps[3] <= 125;
    end


    always @(posedge GPS_PPS) begin
        pps_cnt <= COUNTING ? pps_cnt+1 : 0;
    end


    always @(posedge CLOCK_10M) begin
        COUNT <= COUNTING ? COUNT+1 : 1;
    end


    always @(posedge CLOCK_10M) begin
        if (!RESET_N ) begin
            level <= 0;
            DATA <= 31200;
            COUNTING <= 0;
            state <= 0;
        end else begin
            if (!GPS_LOCK) begin
                COUNTING <= 0;
                TR <= 0;
                state <= 0;
            end else begin
                case (state)
                    0:  begin
                            COUNTING <= 0;
                            cnt <= 0;
                            TR <= 0;
                            state <= 1;
                        end
                    1:  begin
                            /*  ready to count */
                            if (pps_cnt==0 && COUNT==1 && GPS_PPS) begin
                                COUNTING <= 1;
                                standard_pps_reg <= standard_pps[level];
                                standard_cnt_reg <= standard_cnt[level];
                                state <= 2;
                            end
                        end
                    2:  begin
                            /* finish counting */
                            if (pps_cnt>=standard_pps_reg) begin
                                err <= standard_cnt_reg - COUNT;
                                state <= 3;
                            end
                        end
                    3:  begin
                            /* chose factor
                                1HZ/1   : 2000
                                1HZ/5   : 400 
                                1HZ/25  : 80
                                1HZ/125 : 16
                            */
                            if (level == 0) begin
                                factor <= 2000;
                            end else if (level == 1) begin
                                factor <= 400;
                            end else if (level == 2) begin
                                factor <= 80;
                            end else if (level == 3) begin
                                factor <= 16;
                            end else begin
                                factor <= 0;
                            end
                            /* limit err */
                            if (err>100) begin
                                err <= 100;
                                if (level == 0) begin
                                    state <= 4;
                                end else begin
                                    level <= level-1;
                                    state <= 0;
                                end
                            end else if (err<-100) begin
                                err <= -100;
                                if (level == 0) begin
                                    state <= 4;
                                end else begin
                                    level <= level-1;
                                    state <= 0;
                                end
                            end else begin
                                state <= 4;
                            end
                        end
                    4:  begin
                            /* upgrade */
                            if (err==0) begin
                                level <= (level == 3) ? level : level+1;
                                PRECISION <= 4'b0001 << level;
                            end
                            compensation <= err*factor;
                            state <= 5;
                        end
                    5:  begin
                            /* integral */
                            ans <=  ans + compensation;
                            state <= 6;
                        end
                    6:  begin
                            /* limit ans */
                            if (ans<0) begin
                                ans <= 0;
                            end else if (ans>65535) begin
                                ans <= 65535;
                            end
                            state <= 7;
                        end
                    7:  begin 
                            /* update the value of regs on DAC8531 */
                            DATA <= ans[15:0];
                            state <= 8;
                        end
                    8:  begin
                            /* waiting for beginning */
                            if (OVER) begin
                                TR <= 1;
                                state <= 9;
                            end
                        end
                    9:  begin
                            /* keep high */
                            state <= 10;
                        end
                    10: begin   
                            /* waiting for ending */
                            if (OVER) begin
                                state <= 0;
                            end
                            TR <= 0;
                        end
                    11: begin   
                            /* waiting for being stable in 3s */
                            if (cnt>30000000) begin
                                state <= 0;
                            end
                            cnt <= cnt+1;
                        end
                    default: state <= 0;
                endcase
            end
        end
    end

    DAC9531_DATA_ACCESS inst1(
        .CLK          (CLOCK_10M),
        .RESET_N      (RESET_N),
        .TR           (TR),
        .DATA         (DATA),
        .DA_CS        (DA_CS),
        .DA_SCLK      (DA_SCLK),
        .DA_SDO       (DA_SDO),
        .OVER         (OVER)
    );

endmodule
