module Counter_controller #(
    parameter CNT_WIDTH = 7
    )
    (
    input clk,
    input rst_n,
    
    input start_i,
    
    input [CNT_WIDTH-1:0] cnt_val_i,  // purpose of count
    input [CNT_WIDTH-1:0] cnt_i,      // counter counting number
    
    output run_o,
    output done_o
);

    // 0. fsm state declare by localparam
    
    // 1. cnt val capture

    // 2. FSM seq logic
        
    // 3. FSM comb logic
    
    // 4. output assignment


endmodule