module acc_core
# (
    parameter IN_DATA_WIDTH = 8,  
    parameter DWIDTH = 16 // 256 MEM Size -> log2(256) = 8, 8 + 8 = 16
) 
(
    input clk, reset_n,

    input [IN_DATA_WIDTH - 1 : 0] number_i,

    input valid_i,

    output valid_o,
    output [DWIDTH - 1 : 0] result_o
);

    reg                  r_valid;
    reg [DWIDTH - 1 : 0] r_result, r_result_n;

    always @(posedge clk or negedge reset_n) begin
        if(!reset_n) begin
            r_valid <= 1'b0;
        end else begin
            r_valid <= valid_i;
        end
    end

    always@(posedge clk or negedge reset_n) begin
        if(!reset_n) begin
            r_result <= 0;
        end else begin
            r_result <= r_result_n;
        end
    end

    always@(*) begin
        if(valid_i) begin
            r_result_n = r_result + number_i;
        end else begin 
            r_result_n = r_result;
        end
    end

    assign valid_o = r_valid;
    assign result_o = r_result;
endmodule