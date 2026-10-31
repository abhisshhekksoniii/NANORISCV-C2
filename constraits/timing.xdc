create_clock -period 20.000 -name clk [get_ports clk]
set_input_delay -clock clk 2.000 [get_ports reset]
set_output_delay -clock clk 2.000 [get_ports debug_out]