ghdl -a control_unit.vhd
ghdl -e control_unit
ghdl -a control_unit_tb.vhd
ghdl -e control_unit_tb
ghdl -r control_unit_tb --wave=control_unit_e_tb.ghw
gtkwave control_unit_e_tb.ghw
pause