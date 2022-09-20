module Counter #(
    // parameter
    parameter CNT_WIDTH = 7     // we purpose addr 100(2^7 = 128)
    )
    (
    // input output
    
    input clk,
    input rst_n,
    // input done_i,            // use in etc section
    
    output [CNT_WIDTH-1:0] cnt_o
    );
    
    
    // 1. counter seq logic
    
    // 2. counter comb logic
    
    // 3. output assign statement
    
endmodule


