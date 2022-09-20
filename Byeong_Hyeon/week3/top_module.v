module top_module # (
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

    // output: not real register!
    output      reg     [RAM_DATA_WIDTH-1:0]    data_out_0_final    //output data from port 0.
);

    wire    [RAM_DATA_WIDTH-1:0]    sramout_to_finalout;

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
        .data_out_0     ( sramout_to_finalout     )
    );

    // sram에 들어가는 setup input들이 모두 켜지고, address가 같으면
    // 쓰는값이 바로 output으로 들어간다.
    always @(*) begin
        if (port_en_1 && wr_en && addr_in_0 == addr_in_1 && rd_en && port_en_0) begin
            data_out_0_final = data_in;
        end else begin
            data_out_0_final = sramout_to_finalout;
        end
    end

endmodule