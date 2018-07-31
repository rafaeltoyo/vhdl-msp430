ghdl -a reg_base.vhd
ghdl -e reg_base
ghdl -a reg_pc.vhd
ghdl -e reg_pc
ghdl -a reg_pc_tb.vhd
ghdl -e reg_pc_tb
ghdl -r reg_pc_tb --stop-time=1600ns --wave=reg_pc_e_tb.ghw
gtkwave reg_pc_e_tb.ghw
pause