`timescale 1ps/1ps
`define CLOCK_PERIOD 10
`define DELTA 1

module tb #(
    parameter DATA_WIDTH = 4,
    parameter FIFO_DEPTH = 8,
    parameter how_many_cnt = 5,
    parameter how_many_delay = 10
    )
    (
    // No Port
    );
    reg   clk;
    reg   reset_n;
    reg   counter_go;
    reg   acc_go;

    wire  valid_o;
    wire  [DATA_WIDTH-1:0]    result_o;
    wire full_o;
    wire empty_o;
    
    top_module#(
        .DATA_WIDTH ( DATA_WIDTH ),
        .FIFO_DEPTH ( FIFO_DEPTH )
    )u_top_module(
        .clk        ( clk        ),
        .reset_n    ( reset_n    ),
        .counter_go ( counter_go ),
        .acc_go     ( acc_go     ),
        .valid_o    ( valid_o    ),
        .result_o   ( result_o   ),
        .full_o     ( full_o     ),
        .empty_o    ( empty_o    )
    );

    // clock signal
    initial begin
        clk = 1'b0;
        forever begin
            #(`CLOCK_PERIOD/2) clk = ~clk;
        end
    end

    integer i;

    initial begin
        
        // 0. initialize
        reset_n = 1'b1;
        counter_go = 1'b0;
        acc_go = 1'b0;
        
        // 1. reset
        @(posedge clk);
        #(`DELTA)
        reset_n = 1'b0;   // reset on
        
        @(posedge clk);
        #(`DELTA)
        reset_n = 1'b1;   // reset off
        
        @(posedge clk);

        // 2. Write activation
        #(`DELTA)
        counter_go = 1'b1;
        for (i=0; i < how_many_cnt; i=i+1) begin
            @(posedge clk);
        end
        #(`DELTA)
        counter_go = 1'b0;

        for (i=0; i < how_many_delay; i=i+1) begin
            @(posedge clk);
        end
        
        // 4. Read activation
        #(`DELTA)
        acc_go = 1'b1;
        for (i=0; i < how_many_cnt; i=i+1) begin
            @(posedge clk);
        end
        #(`DELTA)
        acc_go = 1'b0;
        
    end    

endmodule
