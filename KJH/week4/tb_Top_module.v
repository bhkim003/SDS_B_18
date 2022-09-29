`timescale 1ps/1ps
`define DELTA 1

module tb_Top_module;
    parameter DWIDTH = 4;
    parameter FIFO_DEPTH = 8;

    reg clk;
    reg reset_n;
    reg en;
    reg acc_en;

    wire empty_o;
    wire full_o;
    wire valid_o;
    wire [DWIDTH - 1 : 0] result_o;

    always #5 clk   = ~clk;

    initial begin
        clk = 0;
        reset_n = 0;
        en = 0;
        acc_en = 0;
    end

    initial begin
        repeat(4)
            @(posedge clk);

        @(posedge clk); 
        #(`DELTA)
        reset_n = 1'b1;

        //write
        @(posedge clk); 
        #(`DELTA)
        en = 1'b1;

        repeat(4)
            @(posedge clk);

        @(posedge clk); 
        #(`DELTA)
        en = 1'b0;

        //delay
        repeat(10)
            @(posedge clk);

        //read
        @(posedge clk); 
        #(`DELTA)
        acc_en = 1'b1;

        repeat(4)
            @(posedge clk);

        @(posedge clk); 
        #(`DELTA)
        acc_en = 1'b0;      
    end

    Top_module#(
        .DWIDTH  ( DWIDTH ),
        .FIFO_DEPTH ( FIFO_DEPTH )
    )u_Top_module(
        .clk     ( clk     ),
        .reset_n ( reset_n ),
        .en      ( en      ),
        .acc_en  ( acc_en  ),
        .empty_o ( empty_o ),
        .full_o  ( full_o  ),
        .valid_o ( valid_o ),
        .result_o  ( result_o  )
    );

    
endmodule