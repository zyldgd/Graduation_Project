/*
Frequency Calibration
f=10MHZ
DAC8531 16bit(0~65535) 0~5V
LED for Freq :
1: 1HZ
2: 0.6HZ
3: 0.2HZ
4: 0.1HZ
5: 0.02HZ
6: 0.01HZ
7: 0.008HZ
*/
module FREQ_CALIB(
    input  wire              CLK_10M,
    input  wire              PPS,
    input  wire              GPS_LOCKED,
    input  wire              CLKsw,
    output reg               DA_CS,
    output reg               DA_SCLK,
    output reg               DA_SDO,
    output reg    [ 3:0]     LED);


reg clk1;
reg [7:0]cnt100;
reg [7:0]tmp3=0;

reg [5:0]rstcnt=0;
reg rstflag=0;

always @ (posedge PPS) begin
	if((!GPS_LOCKED) && (CLKsw == 0)) begin 
        rstcnt <= 1'b0;
        rstflag <= 1'b0;
	end else if(rstcnt <= 5)
		rstcnt <= rstcnt + 1'b1;
	else 
        rstflag <= 1'b1;
end

always @(posedge CLK_10M) begin
	clk1 <= ~clk1;
end

reg DAstart=1;
reg DAstop=1; 
reg [ 5:0] index;
reg [23:0] DAdat24 = 32768;
reg [23:0] DAdata;//32768;
reg [ 2:0] sstate = 0;

always @ (posedge clk1) begin//DA8531 data tansform
	if(DAstart && sstate==0 && CLKsw == 0) begin
        sstate <= 1;
	end else if(DAstart && sstate==0 && CLKsw == 1) begin
		DAstop <= 0;
		sstate <= 0;
	end else begin
        case (sstate)
            0:  begin
                    DA_CS <= 1;
                    DA_SCLK <= 0;
                    DA_SDO <= 0;
                    DAstop <= 1;
                end

            1:  begin 
                    DA_CS <= 0;
                    DAstop <= 0;
                    DAdata <= DAdat24 & 24'b000000001111111111111111;
                    index <= 23;
                    sstate <=2;
                end

            2:  begin 
                    DA_SDO <= DAdata[index];
                    DA_SCLK <= 1;
                    sstate <= 3;
                end

            3:  begin
                    DA_SCLK <= 0;
                    if(index>0) begin
                        index <= index - 1;
                        sstate <= 2;
                    end else begin
                        sstate <= 4;
                    end
                end

            4:  begin
                    DA_CS <= 1;
                    sstate <= 0;
                end
            default: sstate <= 0;
        endcase
    end
end


reg PPSflag=0;
reg [2:0]CPstatus=0;
reg [11:0]PPScnt=1;
reg [3:0] differ=0;
reg[3:0] state;
parameter	S_0=0, S_1=1, S_2=2, S_3=3,
			S_4=4, S_5=5, S_6=6, S_7=7,
			S_8=8, S_9=9, S_10=10, S_11=11;
			


always @(posedge CLK_10M) begin
	if(rstflag==0 || DAstop==0) begin
		state <= S_0;
		cnt100 <= 0;
		tmp3 <= 0;
		if(DAstop==0)begin
			DAstart <= 1'b0; 
		end
	end else begin
        case(state)
            S_0:begin
                if(CPstatus==0) PPScnt<=1;
                else if(CPstatus==1) PPScnt<=5;
                else if(CPstatus==2) PPScnt<=25;
                else if(CPstatus==3) PPScnt<=125;
                else if(CPstatus==4) PPScnt<=625;
                else if(CPstatus==5) PPScnt<=3125;
                else  begin	
                    PPScnt<= 0;
                    CPstatus <=0;
                end
                
                cnt100 <= 0;
                tmp3 <= 0;
                PPSflag <=PPS;
                
                if(DAstop==0)begin
                    DAstart <= 1'b0;
                    state <= S_0;
                end
                else if(DAstart==1'b0)
                    state <= S_1;
                else state <=S_0;
                
            end
            S_1:begin
                if(PPS==1'b0) begin 
                    PPSflag<=0;
                    state <= S_1;
                end
                else if(PPS==1'b1 && PPSflag==0)begin
                    state <= S_2;
                    PPScnt <= PPScnt - 1'b1;
                    PPSflag <= 1'b1;
                end
                else state <= S_1;
            end
            S_2:begin
                cnt100 <= cnt100 + 1'b1;
                if(PPS==1'b0)begin
                    PPSflag <= 1'b0;
                    state <= S_2;
                end
                else if(PPS==1'b1 && PPSflag==0 && PPScnt==0) begin 
                    state <= S_3;
                    PPSflag <= 1'b1;
                end
                else if(PPS==1'b1 && PPSflag==0 && PPScnt > 0)begin
                    PPScnt <= PPScnt-1'b1;
                    PPSflag <= 1'b1;
                    state <= S_2;
                end
                else state <= S_2;
            end
            S_3:begin
                tmp3<=cnt100;
                state<=S_4;
            end
            S_4:begin //1PPS 5PPS 25PPS 125PPS 625PPS  3125 PPS
                state <= S_5;
                if(tmp3<=122) begin  // 6~
                    differ <= 1;
                end
                else if(tmp3<=124) begin// 4~5
                    differ <= 2;
                end
                else if(tmp3<=126) begin// 2~3
                    differ <= 3;
                end
                else if(tmp3==127) begin//1
                    differ <= 4;
                end
                else if(tmp3==128) begin  //0
                    differ <= 5;
                end
                else if(tmp3==129)begin // 1
                    differ <= 6;
                end
                else if(tmp3<=131)begin // 2~3
                    differ <= 7;
                end
                else if(tmp3<=133)begin //4~5
                    differ <= 8;
                end
                else begin //6~
                    differ <= 9;
                end

            end
            S_5:begin
                if(CPstatus==0)state <= S_6; //1PPS
                else if(CPstatus==1) state <= S_7; //5PPS
                else if(CPstatus==2) state <= S_8; //25PPS
                else if(CPstatus==3) state <= S_9; //125PPS
                else if(CPstatus==4) state <= S_10; //625PPS
                else if(CPstatus==5) state <= S_11; //3125 PPS
                else begin
                    state <= S_0;
                    CPstatus<=0;
                end
            end
            S_6:begin //1PPS
                state <= S_0;
                
                if(differ==1) //-6Hz ~
                begin
                    DAdat24 <= (DAdat24 + 24'd12000);
                    DAstart <= 1'b1;
                    LED <= 0;
                end
                else if(differ==2) //-4,5HZ
                begin
                    DAdat24 <= (DAdat24 + 24'd8000);
                    DAstart <= 1'b1;
                    LED <= 0;
                end
                else if(differ==3) //-2,3HZ
                begin
                    DAdat24 <= (DAdat24 + 24'd4000);
                    DAstart <= 1'b1;
                    LED <= 0;
                end
                else if(differ==4) //-1HZ
                begin
                    DAdat24 <= (DAdat24 + 24'd2000);
                    DAstart <= 1'b1;
                    LED <= 0;
                end
                else if(differ==5) //0HZ
                begin
                    CPstatus <= 1;
                    LED <= 1;
                end
                else if(differ==6) //+1HZ
                begin
                    DAdat24 <= (DAdat24 - 24'd2000);
                    DAstart <= 1'b1;
                    LED <= 0;
                end
                else if(differ==7) //+2,3HZ
                begin
                    DAdat24 <= (DAdat24 - 24'd4000);
                    DAstart <= 1'b1;
                    LED <= 0;
                end
                else if(differ==8) //+4,5HZ
                begin
                    DAdat24 <= (DAdat24 - 24'd8000);
                    DAstart <= 1'b1;
                    LED <= 0;
                end
                else if(differ==9) //+6,~HZ
                begin
                    DAdat24 <= (DAdat24 - 24'd12000);
                    DAstart <= 1'b1;
                    LED <= 0;
                end
                else
                begin
                    differ <= 1'b0;
                    LED <= 0;
                end
            end
            S_7:begin //5PPS
                state <= S_0;
                
                if(differ==1) //-1.2 Hz ~
                begin
                    DAdat24 <= (DAdat24 + 24'd2400);
                    DAstart <= 1'b1;
                    LED <= 1;
                    CPstatus <= 0;
                end
                else if(differ==2) //-0.8,1HZ
                begin
                    DAdat24 <= (DAdat24 + 24'd1600);
                    DAstart <= 1'b1;
                    LED <= 1;
                end
                else if(differ==3) //-0.4,0.6HZ
                begin
                    DAdat24 <= (DAdat24 + 24'd800);
                    DAstart <= 1'b1;
                    LED <= 2;
                end
                else if(differ==4) //-0.2HZ
                begin
                    DAdat24 <= (DAdat24 + 24'd400);
                    DAstart <= 1'b1;
                    LED <= 2;
                end
                else if(differ==5) //0HZ
                begin
                    CPstatus <= 2;
                    LED <= 3;
                end
                else if(differ==6) //+0.2HZ
                begin
                    DAdat24 <= (DAdat24 - 24'd400);
                    DAstart <= 1'b1;
                    LED <= 2;
                end
                else if(differ==7) //+0.4,0.6HZ
                begin
                    DAdat24 <= (DAdat24 - 24'd800);
                    DAstart <= 1'b1;
                    LED <= 2;
                end
                else if(differ==8) //+0.8,1HZ
                begin
                    DAdat24 <= (DAdat24 - 24'd1600);
                    DAstart <= 1'b1;
                    LED <= 1;
                end
                else if(differ==9) //+1.2,~HZ
                begin
                    DAdat24 <= (DAdat24 - 24'd2400);
                    DAstart <= 1'b1;
                    LED <= 1;
                    CPstatus <= 0;
                end
                else
                begin
                    differ <= 1'b0;
                    LED <= 0;
                end
            end
            S_8:begin //25PPS
                state <= S_0;
                
                if(differ==1) //-0.24 Hz ~
                begin
                    DAdat24 <= (DAdat24 + 24'd960);
                    DAstart <= 1'b1;
                    LED <= 3;
                    CPstatus <= 1;
                end
                else if(differ==2) //-0.16,0.2HZ
                begin
                    DAdat24 <= (DAdat24 + 24'd640);
                    DAstart <= 1'b1;
                    LED <= 3;
                end
                else if(differ==3) //-0.08,0.12HZ
                begin
                    DAdat24 <= (DAdat24 + 24'd320);
                    DAstart <= 1'b1;
                    LED <= 4;
                end
                else if(differ==4) //-0.04HZ
                begin
                    DAdat24 <= (DAdat24 + 24'd160);
                    DAstart <= 1'b1;
                    LED <= 4;
                end
                else if(differ==5) //0HZ
                begin
                    CPstatus <= 3;
                    LED <= 5;
                end
                else if(differ==6) //+0.04HZ
                begin
                    DAdat24 <= (DAdat24 - 24'd160);
                    DAstart <= 1'b1;
                    LED <= 4;
                end
                else if(differ==7) //+0.08,0.12HZ
                begin
                    DAdat24 <= (DAdat24 - 24'd320);
                    DAstart <= 1'b1;
                    LED <= 4;
                end
                else if(differ==8) //+0.16,0.2HZ
                begin
                    DAdat24 <= (DAdat24 - 24'd640);
                    DAstart <= 1'b1;
                    LED <= 3;
                end
                else if(differ==9) //+0.24,~HZ
                begin
                    DAdat24 <= (DAdat24 - 24'd960);
                    DAstart <= 1'b1;
                    LED <= 3;
                    CPstatus <= 1'b1;
                end
                else
                begin
                    differ <= 1'b0;
                    LED <= 0;
                end
            end	
            S_9:begin //125PPS
                state <= S_0;

                if(differ==1) //-0.048 Hz ~
                begin
                    DAdat24 <= (DAdat24 + 24'd96);
                    DAstart <= 1'b1;
                    LED <= 5;
                    CPstatus <= 2;
                end
                else if(differ==2) //-0.016,0.024HZ
                begin
                    DAdat24 <= (DAdat24 + 24'd64);
                    DAstart <= 1'b1;
                    LED <= 5;
                end
                else if(differ==3) //0.008
                begin
                    DAdat24 <= (DAdat24 + 24'd32);
                    DAstart <= 1'b1;
                    LED <= 6;
                end
                else if(differ==4) //0.008
                begin
                    DAdat24 <= (DAdat24 + 24'd16);
                    DAstart <= 1'b1;
                    LED <= 6;
                end
                else if(differ==5) //0HZ
                begin
                    CPstatus <= 4;
                    LED <= 7;
                end
                else if(differ==6) //0.008
                begin
                    DAdat24 <= (DAdat24 - 24'd16);
                    DAstart <= 1'b1;
                    LED <= 6;
                end
                else if(differ==7) //+0.016,0.024HZ
                begin
                    DAdat24 <= (DAdat24 - 24'd32);
                    DAstart <= 1'b1;
                    LED <= 6;
                end
                else if(differ==8) //+0.032,0.04HZ
                begin
                    DAdat24 <= (DAdat24 - 24'd64);
                    DAstart <= 1'b1;
                    LED <= 5;
                end
                else if(differ==9) //+0.048,~HZ
                begin
                    DAdat24 <= (DAdat24 - 24'd96);
                    DAstart <= 1'b1;
                    LED <= 5;
                    CPstatus <= 2;
                end
                else
                begin
                    differ <= 1'b0;
                    LED <= 0;
                end
            end
            S_10:begin //625PPS
                state <= S_0;

                if(differ==1) //-0.0024 Hz ~
                begin
                    DAdat24 <= (DAdat24 + 24'd20);
                    DAstart <= 1'b1;
                    LED <= 7;
                    CPstatus <= 3;
                end
                else if(differ==2) //
                begin
                    DAdat24 <= (DAdat24 + 24'd13);
                    DAstart <= 1'b1;
                    LED <= 8;
                end
                else if(differ==3) //
                begin
                    DAdat24 <= (DAdat24 + 24'd6);
                    DAstart <= 1'b1;
                    LED <= 9;
                end
                else if(differ==4) //
                begin
                    DAdat24 <= (DAdat24 + 24'd3);
                    DAstart <= 1'b1;
                    LED <= 10;
                end
                else if(differ==5) //0HZ
                begin
                    CPstatus <= 5;
                    LED <= 11;
                end
                else if(differ==6) //
                begin
                    DAdat24 <= (DAdat24 - 24'd3);
                    DAstart <= 1'b1;
                    LED <= 10;
                end
                else if(differ==7) 
                begin
                    DAdat24 <= (DAdat24 - 24'd6);
                    DAstart <= 1'b1;
                    LED <= 9;
                end
                else if(differ==8) 
                begin
                    DAdat24 <= (DAdat24 - 24'd13);
                    DAstart <= 1'b1;
                    LED <= 8;
                end
                else if(differ==9) 
                begin
                    DAdat24 <= (DAdat24 - 24'd20);
                    DAstart <= 1'b1;
                    LED <= 7;
                    CPstatus <= 3;
                end
                else
                begin
                    differ <= 1'b0;
                    LED <= 0;
                end
            end
            S_11:begin //3125PPS
                state <= S_0;

                if(differ==1) //-0.00012 Hz ~
                begin
                    DAdat24 <= (DAdat24 + 24'd2);
                    DAstart <= 1'b1;
                    LED <= 11;
                    CPstatus <= 4;
                end
                else if(differ==2) //
                begin
                    DAdat24 <= (DAdat24 + 24'd2);
                    DAstart <= 1'b1;
                    LED <= 12;
                end
                else if(differ==3) //
                begin
                    DAdat24 <= (DAdat24 + 24'd1);
                    DAstart <= 1'b1;
                    LED <= 13;
                end
                else if(differ==4) //
                begin
                    DAdat24 <= (DAdat24 + 24'd1);
                    DAstart <= 1'b1;
                    LED <= 14;
                end
                else if(differ==5) //0HZ
                begin
                    CPstatus <= 5;
                    LED <= 15;
                end
                else if(differ==6) //
                begin
                    DAdat24 <= (DAdat24 - 24'd1);
                    DAstart <= 1'b1;
                    LED <= 14;
                end
                else if(differ==7) 
                begin
                    DAdat24 <= (DAdat24 - 24'd1);
                    DAstart <= 1'b1;
                    LED <= 13;
                end
                else if(differ==8) 
                begin
                    DAdat24 <= (DAdat24 - 24'd2);
                    DAstart <= 1'b1;
                    LED <= 12;
                end
                else if(differ==9) 
                begin
                    DAdat24 <= (DAdat24 - 24'd2);
                    DAstart <= 1'b1;
                    LED <= 11;
                    CPstatus <= 4;
                end
                else
                begin
                    differ <= 1'b0;
                    LED <= 0;
                end
            end
        endcase
    end
end














endmodule 