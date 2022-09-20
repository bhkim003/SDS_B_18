module delay # (
            parameter           RAM_DATA_WIDTH          = 272,
            parameter           RAM_ADDR_WIDTH          = 8,
            parameter           RAM_DEPTH               = 256
        )
        (   
            input         clk,                //clock
            input         rst_n,
            input         delay_en,        //enable when read addr and write addr are same

            input        [RAM_DATA_WIDTH - 1 : 0]    delay_in,      //Input data to port 1

            output      [RAM_DATA_WIDTH - 1 : 0]    delay_out    //output data from port 0.
        );

  reg [RAM_DATA_WIDTH - 1 : 0] delay_data, delay_data_n;


    // 1. seq logic
    always @(posedge clk, negedge rst_n) begin
      if (!rst_n) begin
        delay_data <= {(RAM_DATA_WIDTH - 1){1'b0}};
      end else begin
        delay_data <= delay_data_n;
      end
    end

    // 2. comb logic
    always @(*) begin
      delay_data_n = delay_data;
      if (delay_en) begin
        delay_data_n = delay_in;
      end
    end

    assign delay_out = delay_data;
endmodule