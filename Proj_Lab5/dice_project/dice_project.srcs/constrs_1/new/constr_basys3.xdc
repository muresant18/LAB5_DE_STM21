## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -add -name sys_clk_pin -period 20.00 -waveform {0 10} [get_ports clk]
 
## Pins
set_property PACKAGE_PIN V17 [get_ports {dice_dout_o[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {dice_dout_o[0]}]
set_property PACKAGE_PIN V16 [get_ports {dice_dout_o[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {dice_dout_o[1]}]
set_property PACKAGE_PIN W16 [get_ports {dice_dout_o[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {dice_dout_o[2]}]
set_property PACKAGE_PIN V2 [get_ports {dice_done_o}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {dice_done_o}]
set_property PACKAGE_PIN T3 [get_ports {trig_i}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {trig_i}]
set_property PACKAGE_PIN T2 [get_ports {reset_ni}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {reset_ni}]
	

set_input_delay -clock [get_clocks sys_clk_pin] -max -add_delay 2.000 [get_ports {trig_i}]
set_input_delay -clock [get_clocks sys_clk_pin] -min -add_delay 1.000 [get_ports {trig_i}]

set_output_delay -clock [get_clocks sys_clk_pin] -max -add_delay  2.000 [get_ports {dice_done_o}]
set_output_delay -clock [get_clocks sys_clk_pin] -min -add_delay -0.500 [get_ports {dice_done_o}]

set_output_delay -clock [get_clocks sys_clk_pin] -max -add_delay  2.000 [get_ports {dice_dout_o*}]
set_output_delay -clock [get_clocks sys_clk_pin] -min -add_delay -0.500 [get_ports {dice_dout_o*}]

