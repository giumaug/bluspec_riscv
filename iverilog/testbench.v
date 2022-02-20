//`timescale 10ms/1ms

module testbench;

  reg clk = 0;
  reg rst = 0;
  wire[3:0] t_led;
  
  mkBluespecRiscv mkBluespecRiscv_inst(.led(t_led), .CLK(clk), .RST_N(rst));
  
  always #5 clk = !clk;
  //always #5 rst = !rst;

  always @(posedge(clk))
    begin
    	$display("led is %d", t_led);
    	$display("clk is %d", clk);
    	if (rst == 0) rst <= 1;
    end
    
    always @(negedge(clk))
    begin
    	$display("clk is %d", clk);
    	$display("led is %d", t_led);
    end
endmodule
