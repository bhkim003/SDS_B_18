module Counter_TOP #(
    parameter CNT_WIDTH = 7
    )
    (
    input clk,
    input rst_n,
    input start_i,
    input [CNT_WIDTH-1:0] cnt_val_i,
    
    output [CNT_WIDTH-1:0] cnt_o,
    output done_o
    );

    // wire for linking counter & counter_fsm
    wire run_w, done_w;
    wire [CNT_WIDTH - 1:0] cnt_w;
    
    // Counter inst
    Counter#(
        .CNT_WIDTH ( CNT_WIDTH )
    )u_Counter(
        .clk   ( clk   ),
        .rst_n ( rst_n ),
        .en    ( run_w ),
        .done_i(done_w ),
        .cnt_o ( cnt_w )
    );

    // fsm inst
    Counter_controller#(
        .CNT_WIDTH ( CNT_WIDTH )
    )u_Counter_controller(
        .clk       ( clk       ),
        .rst_n     ( rst_n     ),
        .start_i   ( start_i   ),
        .cnt_val_i ( cnt_val_i ),
        .cnt_i     ( cnt_w     ),
        .run_o     ( run_w     ),
        .done_o    ( done_w    )
    );

    // output logic
    assign cnt_o = cnt_w;
    assign done_o = done_w; 

endmodule