`timescale 1ns/1ps
`define DELTA 2

module tb_top_module;

    parameter           RAM_DATA_WIDTH          = 16;
    parameter           RAM_ADDR_WIDTH          = 8;
    parameter           RAM_DEPTH               = 256;


    reg                            clk;          //clock
    reg                               rst_n;
    reg                               rd_en;     //read enable for port 0
    reg                                 wr_en;        //write enable for port 1

    reg       [RAM_ADDR_WIDTH-1:0]    addr_in_0;    //address for port 0

    reg       [RAM_ADDR_WIDTH-1:0]    addr_in_1;    //address for port 1
    reg       [RAM_DATA_WIDTH-1:0]    data_in;      //Input data to port 1


    reg                               port_en_0;    //enable port 0
    reg                               port_en_1;    //enable port 1

    wire  [RAM_DATA_WIDTH-1:0]    data_out_0_final;    //output data from port 0.

    always #5 clk   = ~clk;

    //초기값세팅
    initial begin
        clk         = 0;
        rst_n       = 0;

        addr_in_0 = {(RAM_ADDR_WIDTH){1'b0}};
        rd_en = 0;
        port_en_0 = 0;
        
        addr_in_1 = {(RAM_ADDR_WIDTH){1'b0}};
        wr_en = 0; 
        port_en_1 = 0;      
        data_in = {(RAM_DATA_WIDTH){1'b0}};
    end

    initial begin
        //reset 한번해주고
        @(posedge clk); 
        @(posedge clk); 
        #(`DELTA)
        rst_n = 1;
        @(posedge clk); 
        #(`DELTA)
        rst_n = 0;
        @(posedge clk); 
        #(`DELTA)
        rst_n = 1;
        @(posedge clk); 

        //01번지에 1234넣는 코드
        @(posedge clk); 
        #(`DELTA)
        addr_in_1 = 8'h01;
        wr_en = 1;
        port_en_1 = 1;
        data_in = 16'h1234;

        @(posedge clk); 
        #(`DELTA)
        addr_in_1 = 0;
        wr_en = 0;
        port_en_1 = 0;
        data_in = 0;

        @(posedge clk); 
        @(posedge clk); 

        // 01번지에 1234 잘 들어갔나 확인
        @(posedge clk); 
        #(`DELTA)
        addr_in_0 = 8'h01;
        rd_en = 1;
        port_en_0 = 1;

        @(posedge clk); 
        #(`DELTA)
        addr_in_0 = 0;
        rd_en = 0;
        port_en_0 = 0;

        @(posedge clk); 
        @(posedge clk); 
        @(posedge clk); 
        
        //이제 동시에 읽고 쓰기 해보자! 
        @(posedge clk); 
        #(`DELTA)
        addr_in_1 = 8'h01;
        wr_en = 1;
        port_en_1 = 1;
        data_in = 16'h1235;

        addr_in_0 = 8'h01;
        rd_en = 1;
        port_en_0 = 1;

        @(posedge clk); 
        #(`DELTA)

        addr_in_1 = 0;
        wr_en = 0;
        port_en_1 = 0;
        data_in = 0;

        addr_in_0 = 0;
        rd_en = 0;
        port_en_0 = 0;
    end
    
top_module#(
    .RAM_DATA_WIDTH ( RAM_DATA_WIDTH ),
    .RAM_ADDR_WIDTH ( RAM_ADDR_WIDTH ),
    .RAM_DEPTH      ( RAM_DEPTH )
)u_top_module(
    .clk            ( clk            ),
    .rst_n          ( rst_n          ),
    .rd_en          ( rd_en          ),
    .wr_en          ( wr_en          ),
    .addr_in_0      ( addr_in_0      ),
    .addr_in_1      ( addr_in_1      ),
    .data_in        ( data_in        ),
    .port_en_0      ( port_en_0      ),
    .port_en_1      ( port_en_1      ),
    .data_out_0_final  ( data_out_0_final  )
);

endmodule