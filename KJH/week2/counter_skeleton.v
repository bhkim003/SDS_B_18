module Counter #(
    // parameter
    parameter CNT_WIDTH = 7     // we purpose addr 100(2^7 = 128)
    )
    (
    // input output
    
    input clk,
    input rst_n,
    input en,
    input done_i,            // use in etc section
    
    output [CNT_WIDTH-1:0] cnt_o
    );
    
    reg [CNT_WIDTH - 1:0] cnt, cnt_n;

    // 1. counter seq logic
    always @(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            cnt <= {(CNT_WIDTH){1'b0}};
        end else begin
            cnt <= cnt_n;
        end
    end 
    // 2. counter comb logic
    always @(*) begin
        cnt_n = cnt;
        if(en) begin
            cnt_n = cnt + 'd1;
        end else if(done_i) begin
            cnt_n = {(CNT_WIDTH){1'b0}};
        end
    end
    
    // 3. output assign statement
    assign cnt_o = cnt;
    
endmodule

