module recirculation_mux_sync(
  input wire clk1,
  input wire clk2,
  input wire rst_clk1,
  input wire rst_clk2,
  input wire EN,
  input wire data_in,
  output reg data_out
);
 //synchronized  the enabl;e control signal
  reg async_en=0;
  always @(posedge clk1 or posedge rst_clk1)begin
    if (rst_clk1)
      async_en<=1'b0;
    else 
      async_en<=EN;
  end
  reg async_en_ff1=0,async_en_ff2=0;
  always@(posedge clk2 or posedge rst_clk2)begin
    if (rst_clk2)begin
      async_en_ff1<=1'b0;
      async_en_ff2<=1'b0;
    end else begin
      async_en_ff1<=async_en;
      async_en_ff2<=async_en_ff1;
    end
  end
  //latchging the data
  reg data_latched=0;
  always @(posedge clk1 or posedge rst_clk1)begin
    if (rst_clk1)
      data_latched<=1'b0;
    else 
      data_latched<=data_in;
  end
  
 //synchronized the data with mux
  reg data_out_mux;
  always @(posedge clk2 or posedge rst_clk2)begin
    if (rst_clk2)begin
      data_out_mux<=1'b0;
    end else if (async_en_ff2)
      data_out_mux<=data_latched;
    else 
      data_out_mux<=data_out;
  end
      
  always @(posedge clk2 or posedge rst_clk2)begin
    if (rst_clk2)
      data_out<=1'b0;
    else
      data_out<=data_out_mux;
  end
endmodule
