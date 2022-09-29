module FIFO #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 8
    )
    (
    input                       clk,
    input                       rst_n,
    input                       wren_i,
    input                       rden_i,
    input   [DATA_WIDTH-1:0]    wdata_i,
    output  [DATA_WIDTH-1:0]    rdata_o,
    output full_o,
    output empty_o
    );

    localparam FIFO_DEPTH_LG2 = $clog2(FIFO_DEPTH);
    
    // Address width param (clog2)
    reg [FIFO_DEPTH_LG2:0] wrptr;
    reg [FIFO_DEPTH_LG2:0] rdptr;
    
    // 1. Counter part 
        
    // 1-1) Write pointer counter logic
    always @(posedge clk, negedge rst_n) begin
        if (rst_n) begin
            wrptr <= {(FIFO_DEPTH_LG2+1){1'b0}};
        end
    end
    
    // 1-3) Read pointer counter logic   
    
    // 2. Memory Part
    reg [DATA_WIDTH-1:0] mem [0:FIFO_DEPTH-1];
    
    // 2-1) FIFO Storage HW declaration
    // (This part is replace with inst mem, current is filpflop)

    // 2-2) Write activation
    always @(posedge clk) begin
        if (wren_i) begin
            mem[wrptr[FIFO_DEPTH_LG2-1:0]] <= wdata_i;
        end
    end
    
    // 2-3) Read activation
    assign rdata_o = mem[rdptr[FIFO_DEPTH_LG2-1:0]]
    // 3. FIFO state signal 
    
    // 3-1) full signal
    
    // 3-2) empty signal
    assign 

endmodule