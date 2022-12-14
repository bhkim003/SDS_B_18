
module counter #(
    // parameter
    parameter CNT_WIDTH = 7 // we purpose addr 100(2^7 = 128)
    )
    (

    // special input
    input clk,
    input rst_n,
    
    // control input
    input en,
    
    // output
    output [CNT_WIDTH-1:0] cnt_o,
    output valid_o
    );
    
    // Local param
    
    // declare reg type variable(cnt -> flipflop, cnt_n -> comb)
    reg [CNT_WIDTH-1:0] cnt, cnt_n;
    
    // 1. counter seq logic
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            cnt <= {(CNT_WIDTH){1'b0}};
        end else begin
            cnt <= cnt_n;
        end
    end
    
    // 2. counter comb logic
    always @(*) begin
        if (en) begin
            cnt_n = cnt + 'd1;
        end else begin 
            cnt_n = {(CNT_WIDTH){1'b0}};   
        end
    end
    
    // 3. output assign statement
    assign cnt_o = cnt;
    assign valid_o = en;
    
endmodule