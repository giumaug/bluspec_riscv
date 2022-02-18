module testbench;

  reg clk = 0;
  reg rst = 1;
  reg[3:0] t_led = 0;
  
  mkBluespecRiscv mkBluespecRiscv_inst(.led(t_led), .CLK(clk), .RST_N(rst));
  
  always #5 clk = !clk;
  always #5 rst = !rst;

  always @(posedge(int_clk))
    begin
    	$display("led is %d", led);
    end
endmodule
