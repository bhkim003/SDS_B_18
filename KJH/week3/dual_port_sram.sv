module dual_port_sram #(
        parameter           RAM_DATA_WIDTH          = 16,
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

    //memory declaration.
        reg                 [RAM_DATA_WIDTH-1:0]    ram [0:RAM_DEPTH-1];
        reg                 [RAM_DATA_WIDTH-1:0]    r_data_out_0;
    // read & write to the RAM

        always @(posedge clk) begin
            if(!rst_n) begin
                for(int i = 0; i < RAM_DEPTH; i = i + 1) begin
                    ram[i]                          <= {RAM_DATA_WIDTH{1'b0}};
                end
            end else begin
                if(port_en_0 == 1 && rd_en == 1) begin
                    r_data_out_0                    <= ram[addr_in_0];
                end
            
                if(port_en_1 == 1 && wr_en == 1) begin
                    ram[addr_in_1]                  <= data_in;
                end
            end
        end

        assign data_out_0                           = r_data_out_0;

endmodule