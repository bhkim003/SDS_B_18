module TOP_dual_port_sram # ( 
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

        output      wire    [RAM_DATA_WIDTH-1:0]    Top_data_out_0    
    );

    wire [RAM_DATA_WIDTH-1:0] data_out;

    reg [RAM_DATA_WIDTH-1:0] addr_check_out;
    reg [RAM_DATA_WIDTH-1:0] Top_data_out_0_n;

    dual_port_sram#(
        .RAM_DATA_WIDTH ( RAM_DATA_WIDTH ),
        .RAM_ADDR_WIDTH ( RAM_ADDR_WIDTH ),
        .RAM_DEPTH      ( RAM_DEPTH )
    )u_dual_port_sram(
        .clk            ( clk            ),
        .rst_n          ( rst_n          ),
        .rd_en          ( rd_en          ),
        .wr_en          ( wr_en          ),
        .addr_in_0      ( addr_in_0      ),
        .addr_in_1      ( addr_in_1      ),
        .data_in        ( data_in        ),
        .port_en_0      ( port_en_0      ),
        .port_en_1      ( port_en_1      ),
        .data_out_0     ( data_out       )
    );

    always @(*) begin
        if(addr_in_0 == addr_in_1) begin
            addr_check_out = data_in; 
        end else begin
            addr_check_out = data_out;
        end
    end 

    always @(*) begin
        if ((port_en_0 && port_en_1 && rd_en && wr_en) == 1) begin
            Top_data_out_0_n = addr_check_out;
        end else begin
            Top_data_out_0_n = data_out;
        end
    end

    assign Top_data_out_0 = Top_data_out_0_n;


endmodule