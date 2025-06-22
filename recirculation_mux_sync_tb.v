`timescale 1ns / 1ps

module recirculation_mux_sync_tb;

  // Inputs
  reg clk1 = 0;
  reg clk2 = 0;
  reg rst_clk1 = 1;
  reg rst_clk2 = 1;
  reg EN = 0;
  reg data_in = 0;

  // Output
  wire data_out;

  // Instantiate the Unit Under Test (UUT)
  recirculation_mux_sync uut (
    .clk1(clk1),
    .clk2(clk2),
    .rst_clk1(rst_clk1),
    .rst_clk2(rst_clk2),
    .EN(EN),
    .data_in(data_in),
    .data_out(data_out)
  );

  // Clock generation
  always #5 clk1 = ~clk1;  // 100MHz
  always #7 clk2 = ~clk2;  // ~71.4MHz (asynchronous to clk1)

  // Test sequence
  initial begin
    $display("Starting simulation...");
    $dumpfile("recirculation_mux_sync.vcd");  // For GTKWave
    $dumpvars(0, recirculation_mux_sync_tb);

    // Initial reset
    #10 rst_clk1 = 0;
    #10 rst_clk2 = 0;

    // Test 1: No enable, data should not transfer
    data_in = 1;
    EN = 0;
    #50;

    // Test 2: Enable = 1, should transfer latched data
    EN = 1;
    data_in = 1;
    #20 data_in = 0;
    EN = 0;
    #100;

    // Test 3: Change data without enable
    data_in = 0;
    EN = 0;
    #50;

    // Test 4: Another transfer
    data_in = 1;
    EN = 1;
    #20 EN = 0;

    // Finish test
    #100;
    $display("Simulation finished.");
    $finish;
  end

endmodule
