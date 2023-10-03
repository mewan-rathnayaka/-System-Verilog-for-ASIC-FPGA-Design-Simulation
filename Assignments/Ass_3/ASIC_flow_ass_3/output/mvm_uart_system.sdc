###################################################################

# Created by write_sdc on Sat Apr 29 15:42:33 2023

###################################################################
set sdc_version 2.1

set_units -time ns -resistance MOhm -capacitance fF -voltage V -current uA
create_clock [get_ports clk]  -period 0.7  -waveform {0 0.35}
set_input_delay -clock clk  0.2  [get_ports rstn]
set_input_delay -clock clk  0.2  [get_ports rx]
set_output_delay -clock clk  0.2  [get_ports tx]
