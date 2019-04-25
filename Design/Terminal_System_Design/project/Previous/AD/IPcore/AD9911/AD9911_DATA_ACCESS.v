/*
AD9911 SPI to REGs
*/


module AD9911_DATA_ACCESS(
    input  wire            CLK,
    input  wire            RESET_N,
  //input  wire            R_W,
    input  wire            TR,
    input  wire  [ 7:0]    REG_ADDR,
    input  wire  [31:0]    DATA_IN,

  //output reg   [31:0]    DATA_OUT,
    output reg             AD_CS,
    output reg             AD_SCLK,
    output reg             AD_SDIO0,
  //output reg             AD_MSATEREST,
    output reg             AD_UPADTE, 
    output wire            OVER
    );


    // one-hot code
    localparam S0 = 9'b000000001;
    localparam S1 = 9'b000000010;
    localparam S2 = 9'b000000100;
    localparam S3 = 9'b000001000;
    localparam S4 = 9'b000010000;
    localparam S5 = 9'b000100000;
    localparam S6 = 9'b001000000;
    localparam S7 = 9'b010000000;
    localparam S8 = 9'b100000000;

    reg  [ 9:0]   state = 0;
    
    reg  [ 7:0]   addr = 0;
    reg  [31:0]   data = 0;
    reg  [ 4:0]   regBitWide[24:0];
    reg  [ 4:0]   curBit_addr = 0;
    reg  [ 4:0]   curBit_data = 0;
	 

    assign  OVER = AD_CS;

    initial begin
        AD_CS <= 1;
        AD_SCLK <= 0;
        AD_SDIO0 <= 0;
        AD_UPADTE <= 0;
        regBitWide[0 ] <= 7; // 8   CSR  
        regBitWide[1 ] <= 23;// 24  FR1	
        regBitWide[2 ] <= 15;// 16  FR2	
        regBitWide[3 ] <= 23;// 24  CFR	
        regBitWide[4 ] <= 31;// 32  CTW0
        regBitWide[5 ] <= 15;// 16  CPOW0
        regBitWide[6 ] <= 23;// 24  ACR	
        regBitWide[7 ] <= 15;// 16  LSR	
        regBitWide[8 ] <= 31;// 32  RDW	
        regBitWide[9 ] <= 31;// 32  FDW
        regBitWide[10] <= 31;// 32  CTW1
        regBitWide[11] <= 31;// 32  CTW2
        regBitWide[12] <= 31;// 32  CTW3
        regBitWide[13] <= 31;// 32  CTW4
        regBitWide[14] <= 31;// 32  CTW5
        regBitWide[15] <= 31;// 32  CTW6
        regBitWide[16] <= 31;// 32  CTW7
        regBitWide[17] <= 31;// 32  CTW8
        regBitWide[18] <= 31;// 32  CTW9
        regBitWide[19] <= 31;// 32  CTW10
        regBitWide[20] <= 31;// 32  CTW11
        regBitWide[21] <= 31;// 32  CTW12
        regBitWide[22] <= 31;// 32  CTW13
        regBitWide[23] <= 31;// 32  CTW14
        regBitWide[24] <= 31;// 32  CTW15 
    end


    // transfer instructions and data by default mode in operation:
    //     1. Single-bit serial 2-wire mode ( CSR<2:1> = 00 )
    //     2. MSB-first: High fisrt, Low Last ( CSR<0> = 0 )
    //     3. wirte date to AD9911 on the rising edge of SCLK
    //     4. read date from AD9911 on the falling edge of SCLK
    always @(posedge CLK or negedge RESET_N) begin
        if (!RESET_N) begin
            state <= S0;
        end else begin
            case(state)
                S0:	begin
                        AD_CS <= 1;    
                        AD_SCLK <= 0;
                        AD_UPADTE <= 0; 
                        state <= S1;
                    end
                S1:	begin
                        if (TR) begin
                            data <= DATA_IN;
                            addr <= REG_ADDR;
                            curBit_addr <= 7; // address(instructions) bit wide = 7
                            AD_CS <= 0;  // chip select on low level
                            state <= S2;
                        end
                    end
                /******************** WRITE INSTRUCTIONS ********************/
                S2:	begin 
                        AD_SCLK <= 0;
                        AD_SDIO0 <= addr[curBit_addr];
                        state <= S3;
                    end
                S3:	begin
                        if (curBit_addr==0) begin
                            state <= S4;
                        end else begin
                            curBit_addr <= curBit_addr - 1;
                            state <= S2;
                        end
                        AD_SCLK <= 1;
                    end
                /************************ WRITE DATA ************************/
                S4: begin
                        AD_SCLK <= 0;
                        curBit_data <= regBitWide[addr]; // data bit wide = regBitWide
                        state <= S5;
                    end
                S5:	begin
                        AD_SCLK <= 0;
                        AD_SDIO0 <= data[curBit_data];
                        state <= S6;
                    end
                S6:	begin // MSB H->L
                        if (curBit_data==0) begin
                            state <= S7;
                        end else begin
                            curBit_data <= curBit_data - 1;
                            state <= S5;
                        end
                        AD_SCLK <= 1;
                    end  
                /************************ UPADTE/OVER ************************/
                S7:	begin
                        AD_SCLK <= 0;
                        AD_UPADTE <= 1; 
                        state <= S8;
                    end
                S8: begin 
                        state <= S0;
                    end
                default:state <= S0;
		    endcase
        end
    end


endmodule // AD9911_DATA_ACCESS
