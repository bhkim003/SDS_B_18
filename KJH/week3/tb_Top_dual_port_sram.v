`timescale 1ns/1ps
`define DELTA 2

module tb_Top_dual_port_sram; 

    parameter           RAM_DATA_WIDTH          = 272;
    parameter           RAM_ADDR_WIDTH          = 8;
    parameter           RAM_DEPTH               = 256;

    reg                                 clk;          
    reg                                 rst_n;
    reg                                 rd_en;     
    reg                                 wr_en;

    reg       [RAM_ADDR_WIDTH-1:0]      addr_in_0;    
    reg       [RAM_ADDR_WIDTH-1:0]      addr_in_1;    
    reg       [RAM_DATA_WIDTH-1:0]      data_in;

    reg                                 port_en_0;    
    reg                                 port_en_1;    

    wire       [RAM_DATA_WIDTH-1:0]     Top_data_out_0;


    always #5 clk   = ~clk;

    initial begin
        clk         = 0;
        rst_n       = 0;
        rd_en       = 0;
        wr_en       = 0;

        addr_in_0 = {(RAM_ADDR_WIDTH){1'b0}};
        addr_in_1 = {(RAM_ADDR_WIDTH){1'b0}};
        data_in   = {(RAM_DATA_WIDTH){1'b0}};

        port_en_0 = 0;
        port_en_1 = 0;      
    end

    initial begin
        repeat(4)
            @(posedge clk);

        @(posedge clk); 
        #(`DELTA)
        rst_n = 1'b1;

        //input 1234 in the address 01 
        @(posedge clk); 
        #(`DELTA)
        addr_in_1 = 'd01;
        wr_en = 1'b1;
        data_in = 'd1234;
        port_en_1 = 1'b1;

        //reset
        @(posedge clk); 
        #(`DELTA)
        addr_in_1 = 0;
        wr_en = 0;
        data_in = 0;
        port_en_1 = 0;

        //read data which is in the address 01
        repeat(4)
            @(posedge clk);

        @(posedge clk); 
        #(`DELTA)
        addr_in_0 = 'd01;
        rd_en = 1'b1;
        port_en_0 = 1'b1;

        //reset
        @(posedge clk); 
        #(`DELTA)
        addr_in_0 = 0;
        rd_en = 0;
        port_en_0 = 0;

        //put another data and continually read and write the sram.
        repeat(4)
            @(posedge clk);

        @(posedge clk); 
        #(`DELTA)
        data_in = 'd1235;

        addr_in_1 = 'd01;
        wr_en = 1'b1;
        port_en_1 = 1'b1;

        addr_in_0 = 'd01;
        rd_en = 1'b1;
        port_en_0 = 1'b1;

        @(posedge clk); 
        #(`DELTA)
        data_in = 0;

        addr_in_1 = 0;
        wr_en = 0;
        port_en_1 = 0;

        addr_in_0 = 0;
        rd_en = 0;
        port_en_0 = 0;
    end


    TOP_dual_port_sram#(
        .RAM_DATA_WIDTH ( RAM_DATA_WIDTH ),
        .RAM_ADDR_WIDTH ( RAM_ADDR_WIDTH ),
        .RAM_DEPTH      ( RAM_DEPTH )
    )u_TOP_dual_port_sram(
        .clk            ( clk            ),
        .rst_n          ( rst_n          ),
        .rd_en          ( rd_en          ),
        .wr_en          ( wr_en          ),
        .addr_in_0      ( addr_in_0      ),
        .addr_in_1      ( addr_in_1      ),
        .data_in        ( data_in        ),
        .port_en_0      ( port_en_0      ),
        .port_en_1      ( port_en_1      ),
        .Top_data_out_0 ( Top_data_out_0  )
    );


endmodule