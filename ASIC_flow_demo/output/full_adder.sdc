###################################################################

# Created by write_sdc on Wed Apr 26 19:29:19 2023

###################################################################
set sdc_version 2.1

set_units -time ns -resistance MOhm -capacitance fF -voltage V -current uA
create_clock -name vclk  -period 0.7  -waveform {0 0.35}
set_input_delay -clock vclk  0.2  [get_ports a]
set_input_delay -clock vclk  0.2  [get_ports b]
set_input_delay -clock vclk  0.2  [get_ports ci]
set_output_delay -clock vclk  0.2  [get_ports sum]
set_output_delay -clock vclk  0.2  [get_ports co]
