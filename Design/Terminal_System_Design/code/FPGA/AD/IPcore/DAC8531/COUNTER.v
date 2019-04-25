module COUNTER(
    input   wire                  CLK,
    input   wire                  COUNTING,
    output  reg    [31:0]         COUNT
    );

    always @(posedge CLK) begin
        COUNT <= COUNTING ? COUNT+1 : 0;
    end



endmodule
