module Top_module # (
    parameter DWIDTH = 4,
    parameter FIFO_DEPTH = 8
)
(
    input clk,
    input reset_n,
    input en,
    input acc_en,

    output empty_o,
    output full_o,
    output valid_o,
    output [DWIDTH - 1 : 0] result_o
);  

    wire en_w;
    wire [DWIDTH - 1 : 0] cnt_w;
    wire [DWIDTH - 1 : 0] rdata_w;

    Counter#(
        .CNT_WIDTH ( DWIDTH )
    )u_Counter(
        .clk   ( clk   ),
        .rst_n ( rst_n ),
        .en    ( en    ),
        .en_o  (en_w   ),
        .cnt_o  (cnt_w )
    );

    wire empty_w, full_w;
    
    FIFO#(
        .DATA_WIDTH ( DWIDTH ),
        .FIFO_DEPTH ( FIFO_DEPTH )
    )u_FIFO(
        .clk        ( clk        ),
        .rst_n      ( reset_n      ),
        .wren_i     ( en_w     ),
        .rden_i     ( acc_en     ),
        .wdata_i    ( cnt_w    ),
        .rdata_o    ( rdata_w    ),
        .full_o     ( full_w     ),
        .empty_o    ( empty_w    )
    );

    wire valid_w;
    wire [DWIDTH - 1 : 0] result_w; 

    acc_core#(
        .IN_DATA_WIDTH ( DWIDTH ),
        .DWIDTH        ( DWIDTH * 2 )
    )u_acc_core(
        .clk           ( clk           ),
        .reset_n       ( reset_n       ),
        .number_i      ( rdata_w      ),
        .valid_i       ( acc_en       ),
        .run_i         ( empty_o || full_o),
        .valid_o       ( valid_w       ),
        .result_o      ( result_w      )
    );

    assign empty_o = empty_w;
    assign full_o = full_w;
    assign valid_o = valid_w;
    assign result_o = result_w;

endmodule
