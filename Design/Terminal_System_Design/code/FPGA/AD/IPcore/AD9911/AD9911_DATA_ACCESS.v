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
    inout  reg             AD_SDIO0,
  //output reg             AD_MSATEREST,
    output reg             AD_UPADTE, 
    output reg             OVER
    );


    reg  [ 3:0]   state = 0;
    reg  [ 7:0]   addr = 0;
    reg  [31:0]   data = 0;
    reg  [ 7:0]   regBitWide = 0;
    reg  [ 7:0]   curBit = 0;
	 
    initial begin
        AD_CS <= 1;
        AD_SCLK <= 0;
        AD_SDIO0 <= 0;
        AD_UPADTE <= 0;
        OVER <= 0;
    end


    // transfer instructions and data by default mode in operation:
    //     1. Single-bit serial 2-wire mode ( CSR<2:1> = 00 )
    //     2. MSB-first: High fisrt, Low Last ( CSR<0> = 0 )
    //     3. wirte date to AD9911 on the rising edge of SCLK
    //     4. read date from AD9911 on the falling edge of SCLK
    always @(posedge CLK) begin
        if (!RESET_N) begin
            state <= 0;
        end else begin
            case(state)
                0:	begin
                        AD_CS <= 1;    
                        AD_SCLK <= 0;
                        AD_UPADTE <= 0; 
                        OVER <= 0;
                        state <= 1;
                    end
                1:	begin
                        if (TR) begin
                            data <= DATA_IN;
                            addr <= REG_ADDR;
                            AD_CS <= 0;  // chip select on low level
                            case(REG_ADDR)
                                0 : regBitWide <= 7;   // 8   CSR  
                                1 : regBitWide <= 23;  // 24  FR1	
                                2 : regBitWide <= 15;  // 16  FR2	
                                3 : regBitWide <= 23;  // 24  CFR	
                                4 : regBitWide <= 31;  // 32  CTW0
                                5 : regBitWide <= 15;  // 16  CPOW0
                                6 : regBitWide <= 23;  // 24  ACR	
                                7 : regBitWide <= 15;  // 16  LSR	
                                8 : regBitWide <= 31;  // 32  RDW	
                                9 : regBitWide <= 31;  // 32  FDW
                                10: regBitWide <= 31;  // 32  CTW1
                                /*
                                11: regBitWide <= 31;  // 32  CTW2
                                12: regBitWide <= 31;  // 32  CTW3
                                13: regBitWide <= 31;  // 32  CTW4
                                14: regBitWide <= 31;  // 32  CTW5
                                15: regBitWide <= 31;  // 32  CTW6
                                16: regBitWide <= 31;  // 32  CTW7
                                17: regBitWide <= 31;  // 32  CTW8
                                18: regBitWide <= 31;  // 32  CTW9
                                19: regBitWide <= 31;  // 32  CTW10
                                20: regBitWide <= 31;  // 32  CTW11
                                21: regBitWide <= 31;  // 32  CTW12
                                22: regBitWide <= 31;  // 32  CTW13
                                23: regBitWide <= 31;  // 32  CTW14
                                24: regBitWide <= 31;  // 32  CTW15 
                                */
                            endcase 
                            state <= 2;
                        end
                    end
                /******************** WRITE INSTRUCTIONS ********************/
                2:	begin
                        curBit <= 7; // address(instructions) bit wide = 7
                        state <= 3;
                    end
                3:	begin 
                        AD_SCLK <= 0;
                        AD_SDIO0 <= addr[curBit];
                        state <= 4;
                    end
                4:	begin
                        if (curBit==0) begin
                            state <= 5;
                        end else begin
                            curBit <= curBit - 1;
                            state <= 3;
                        end
                        AD_SCLK <= 1;
                    end
                /************************ WRITE DATA ************************/
                5:  begin
                        AD_SCLK <= 0;
                        curBit <= regBitWide; // data bit wide = regBitWide
                        state <= 6;
                    end
                6:	begin
                        AD_SCLK <= 0;
                        AD_SDIO0 <= data[curBit];
                        state <= 7;
                    end
                7:	begin
                        if (curBit==0) begin
                            state <= 8;
                        end else begin
                            curBit <= curBit - 1;
                            state <= 6;
                        end
                        AD_SCLK <= 1;
                    end  
                8:	begin
                        AD_SCLK <= 0;
                        state <= 9;
                    end
                /************************ UPADTE/OVER ************************/
                9:	begin
                        AD_UPADTE <= 1; 
                        state <= 10;
                    end
                10:	begin 
                        state <= 11;
                    end
                11:	begin 
                        AD_UPADTE <= 0;  
                        OVER <= 1;
                        state <= 12;
                    end
                12:	begin 
                        state <= 13;
                    end
                13:	begin 
                        OVER <= 0;
                        state <= 0;
                    end
                default:state <= 0;
		    endcase
        end
    end


endmodule // AD9911_DATA_ACCESS
