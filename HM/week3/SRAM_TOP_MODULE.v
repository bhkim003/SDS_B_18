module SRAM_TOP_MODULE # (
            parameter           RAM_DATA_WIDTH          = 272,
            parameter           RAM_ADDR_WIDTH          = 8,
            parameter           RAM_DEPTH               = 256
        )
        (   
            input       wire                            clk,          //clock
            input       wire                            rst_n,
            input       wire                            rd_en,        //read enable for port 0
            input       wire                            wr_en,        //write enable for port 1

            input       wire    [RAM_ADDR_WIDTH-1:0]    addr_in_0,    //address for port 0

            input       wire    [RAM_ADDR_WIDTH-1:0]    addr_in_1,    //address for port 1
            input       wire    [RAM_DATA_WIDTH-1:0]    data_in,      //Input data to port 1
        

            input       wire                            port_en_0,    //enable port 0
            input       wire                            port_en_1,    //enable port 1

            output      wire    [RAM_DATA_WIDTH-1:0]    data_out_0    //output data from port 0.
        );

dual_port_sram#(
    .RAM_DATA_WIDTH ( 272 ),
    .RAM_ADDR_WIDTH ( 8 ),
    .RAM_DEPTH      ( 256 )
)u_dual_port_sram(
    .clk            ( clk             ),
    .rst_n          ( rst_n          ),
    .rd_en          ( rd_en          ),
    .wr_en          ( wr_en          ),
    .addr_in_0      ( addr_in_0      ),
    .addr_in_1      ( addr_in_1      ),
    .data_in        ( data_in        ),
    .port_en_0      ( port_en_0      ),
    .port_en_1      ( port_en_1      ),
    .data_out_0     ( data_out_0     )
);

  always @(*) begin
    case ( addr_in_0 == addr_in_1 )
      1'b0 : data_in = data_in;
      1'b1 : data_in = data_out;
    endcase
  end



endmodule  