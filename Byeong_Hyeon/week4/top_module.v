module top_module 
# (
    parameter DATA_WIDTH = 4,
    parameter FIFO_DEPTH = 8
)
(
    input clk, reset_n,

    input counter_go,
    input acc_go,

    output valid_o,
    output [DATA_WIDTH - 1 : 0] result_o,

    output                      full_o,
    output                      empty_o
);

wire [DATA_WIDTH-1 : 0] cnt_o_wdata_i;
counter#(
    .CNT_WIDTH ( DATA_WIDTH )
)u_counter(
    .clk   ( clk   ),
    .rst_n ( reset_n ),
    .en    ( counter_go && !full_o    ),
    .cnt_o ( cnt_o_wdata_i )
);

wire [DATA_WIDTH -1 : 0] rdata_o_number_i;
FIFO#(
    .DATA_WIDTH ( DATA_WIDTH ),
    .FIFO_DEPTH ( FIFO_DEPTH )
)u_FIFO(
    .clk        ( clk        ),
    .rst_n      ( reset_n      ),
    .wren_i     (  counter_go && !full_o     ),
    .rden_i     (  acc_go && !empty_o    ),
    .wdata_i    ( cnt_o_wdata_i    ),
    .rdata_o    (   rdata_o_number_i  ),
    .full_o     ( full_o     ),
    .empty_o    (  empty_o   )
);



acc_core#(
    .IN_DATA_WIDTH ( DATA_WIDTH ),
    .DWIDTH        ( DATA_WIDTH )
)u_acc_core(
    .clk           ( clk           ),
    .reset_n       ( reset_n       ),
    .number_i      ( rdata_o_number_i      ),
    .valid_i       ( acc_go && !empty_o       ),
    .valid_o       ( valid_o       ),
    .result_o      ( result_o      )
);

endmodule
