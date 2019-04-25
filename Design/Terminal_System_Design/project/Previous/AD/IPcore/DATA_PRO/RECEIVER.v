module RECEIVER(
    input    wire             CLOCK_10M,
    input    wire             RESET_N,
    input    wire             GEN,
    input    wire    [15:0]   DATA0,
    input    wire    [15:0]   DATA1,
    input    wire             VALID,
    output   wire             BUSY,
    input    wire    [9:0]    ADDR,
    output   reg     [31:0]   DATA
    );

    reg    [31:0]      RAM [511:0];
    reg    [15:0]      index = 0;
    reg    [15:0]      INDEX = 32768;
    wire   [15:0]      I = 0;
    wire               RE = 0;


    always @(posedge CLOCK_10M) begin
        DATA <= RAM[ADDR];
    end
   
/*
    assign   BUSY = (INDEX < PULSE_NUM) ? 1 : 0;

    always @(negedge VALID or posedge GEN) begin
        if (GEN) begin
            INDEX <= 0;
        end else begin
            if (INDEX < PULSE_NUM) begin
                RAM[INDEX] <= {DATA1[15:0], DATA0[15:0]};
                INDEX <= INDEX+1;
            end
        end
    end
*/
endmodule



