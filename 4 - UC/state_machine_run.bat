ghdl -a tff_1bit.vhd
ghdl -e tff_1bit
ghdl -a state_machine.vhd
ghdl -e state_machine
ghdl -a state_machine_tb.vhd
ghdl -e state_machine_tb
ghdl -r state_machine_tb --stop-time=1500ns --wave=state_machine_e_tb.ghw
gtkwave state_machine_e_tb.ghw
pause