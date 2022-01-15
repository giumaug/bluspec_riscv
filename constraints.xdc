## FPGA Configuration I/O Options
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

# CLOCK
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { CLK }];
create_clock -period 10.000 -name tck [get_ports clk]

# RESET
set_property -dict {PACKAGE_PIN A8  IOSTANDARD LVCMOS33} [get_ports RST_N];

# LED
set_property -dict { PACKAGE_PIN H5    IOSTANDARD LVCMOS33 } [get_ports { ledStatus[0] }];
set_property -dict { PACKAGE_PIN J5    IOSTANDARD LVCMOS33 } [get_ports { ledStatus[1] }]; 
set_property -dict { PACKAGE_PIN T9    IOSTANDARD LVCMOS33 } [get_ports { ledStatus[2] }];
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { ledStatus[3] }];

