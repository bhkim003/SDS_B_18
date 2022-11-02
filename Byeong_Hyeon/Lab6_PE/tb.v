`timescale 1ns/1ps
`define DELTA 2

module tb #(
    // Parameter
    parameter DATA_WIDTH = 8,
    parameter PSUM_WIDTH = 32
    )
    (

    );

    reg   clk;
    reg   rst_n;

    // Primitives(input)
    reg   [DATA_WIDTH-1:0]        ifmap_i;
    reg   [DATA_WIDTH-1:0]        weight_i;
    reg   [PSUM_WIDTH-1:0]        psum_i;

    // Register enable signal(output)
    reg                           ifmap_en_i;
    reg                           weight_en_i;
    reg                           psum_en_i;

    // Primitives(input)
    wire  [DATA_WIDTH-1:0]        ifmap_o;
    wire  [DATA_WIDTH-1:0]        weight_o;
    wire  [PSUM_WIDTH-1:0]        psum_o;

    // Register enable signal(output)
    wire                          weight_en_o;
    wire                          psum_en_o;

    // clock
    always #5 clk   = ~clk;

    integer count;
    initial begin
        clk = 0;
        rst_n = 0;

        @(posedge clk); 
        #(`DELTA)     
        rst_n     = 1;

        @(posedge clk); 
        #(`DELTA)       
        rst_n     = 0;

        @(posedge clk); 
        #(`DELTA)     
        rst_n     = 1;

        @(posedge clk); 
        #(`DELTA)     
        ifmap_en_i = 1;
        ifmap_i = 7;

        @(posedge clk); 
        #(`DELTA) 

        @(posedge clk); 
        #(`DELTA) 
        for (count = 5; count < 64; count = count +1) begin
            @(posedge clk); 
            #(`DELTA) 
            weight_en_i = 1;
            weight_i = count;
            psum_en_i = 1;
            psum_i = 64-count;
        end

        @(posedge clk); 
        #(`DELTA) 
        weight_en_i = 0;
        psum_en_i = 0;

        @(posedge clk); 
        #(`DELTA) 
        rst_n = 0;

    end

    PE#(
        .DATA_WIDTH  ( DATA_WIDTH ),
        .PSUM_WIDTH  ( PSUM_WIDTH )
    )u_PE(
        .clk         ( clk         ),
        .rst_n       ( rst_n       ),
        .ifmap_i     ( ifmap_i     ),
        .weight_i    ( weight_i    ),
        .psum_i      ( psum_i      ),
        .ifmap_en_i  ( ifmap_en_i  ),
        .weight_en_i ( weight_en_i ),
        .psum_en_i   ( psum_en_i   ),
        .ifmap_o     ( ifmap_o     ),
        .weight_o    ( weight_o    ),
        .psum_o      ( psum_o      ),
        .weight_en_o ( weight_en_o ),
        .psum_en_o   ( psum_en_o   )
    );


endmodule