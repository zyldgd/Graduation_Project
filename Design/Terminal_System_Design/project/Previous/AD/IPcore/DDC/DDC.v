module DDC(
    input   wire                   CLK,
    input   wire                   RESET_N,
    input   wire           [31:0]  NCO_PIF,//phase increment Frequency : 601295421 - 1.4Mhz
    input   wire   signed  [15:0]  AD_DATA,
    output  wire           [15:0]  DATA0,
    output  wire                   VALID0,
    output  wire           [15:0]  DATA1,
    output  wire                   VALID1
    );

    wire    signed      [15:0]  data_sin;
    wire    signed      [15:0]  data_cos;
    wire    signed      [31:0]  answ_sin;
    wire    signed      [31:0]  answ_cos;

    wire                [24:0]  cic_data0;
	wire                [24:0]  cic_data1;

    nco nco_inst0(
        .phi_inc_i            (NCO_PIF),//phase increment Frequency
        .clk                  (CLK),
        .reset_n              (RESET_N),
        .clken                (1),

        .fsin_o               (data_sin),
        .fcos_o               (data_cos),
        .out_valid            (nco_valid)
    );

    MULT MULT_inst0 (
        .dataa                (data_sin),
        .datab                (AD_DATA),
        .result               (answ_sin)
	);

    MULT MULT_inst1 (
        .dataa                (data_cos),
        .datab                (AD_DATA),
        .result               (answ_cos)
	);

    
    CIC CIC_inst0(
	    .clk                    (CLK),
	    .clken                  (1),
	    .reset_n                (RESET_N),
	    .in_data                (answ_sin[30:7]),
	    .in_valid               (nco_valid),
	    .out_ready              (sink_ready0),
	    .in_error               (),
        
	    .out_data               (cic_data0),
	    .in_ready               (),
	    .out_valid              (cic_valid0),
	    .out_error              () 
    );

	CIC CIC_inst1(
	    .clk                    (CLK),
	    .clken                  (1),
	    .reset_n                (RESET_N),
	    .in_data                (answ_cos[30:7]),
	    .in_valid               (nco_valid),
	    .out_ready              (sink_ready1),
	    .in_error               (),
        
	    .out_data               (cic_data1),
	    .in_ready               (),
	    .out_valid              (cic_valid1),
	    .out_error              () 
    );

    FIR FIR_inst0(
	    .clk                    (CLK),
	    .reset_n                (RESET_N),
	    .ast_sink_data          (cic_data0),
	    .ast_sink_valid         (cic_valid0),
	    .ast_source_ready       (1),
	    .ast_sink_error         (),
	    .ast_source_data        (DATA0[15:0]), 
	    .ast_sink_ready         (sink_ready0),
	    .ast_source_valid       (VALID0),
	    .ast_source_error       ()
    );

    FIR FIR_inst1(
	    .clk                    (CLK),
	    .reset_n                (RESET_N),
	    .ast_sink_data          (cic_data1),
	    .ast_sink_valid         (cic_valid1),
	    .ast_source_ready       (1),
	    .ast_sink_error         (),
	    .ast_source_data        (DATA1[15:0]), 
	    .ast_sink_ready         (sink_ready1),
	    .ast_source_valid       (VALID1),
	    .ast_source_error       ()
    );


/*
    CIC CIC_inst0(
        .clk                  (CLK),
        .clken                (1),
        .reset_n              (RESET_N),
        .in0_data             (answ_sin[30:7]),
        .in1_data             (answ_cos[30:7]),
        .in_valid             (nco_valid),
        .out_ready            (sink_ready),
        .in_error             (),

        .out_data             (cic_data),
        .out_channel          (),
        .out_startofpacket    (sop_),
        .out_endofpacket      (eop_),
        .in_ready             (),
        .out_valid            (cic_valid),
        .out_error            () 
    );

    FIR FIR_inst0(
        .clk                  (CLK),
        .reset_n              (RESET_N),
        .ast_sink_data        (cic_data),
        .ast_sink_valid       (cic_valid),
        .ast_source_ready     (1),
        .ast_sink_sop         (sop_),
        .ast_sink_eop         (eop_),
        .ast_sink_error       (),

        .ast_source_data      (DATA[15:0]),
        .ast_sink_ready       (sink_ready),
        .ast_source_valid     (VALID),
        .ast_source_sop       (SOP),
        .ast_source_eop       (EOP),
        .ast_source_channel   (),
        .ast_source_error     ()
    );

*/

endmodule // DDC