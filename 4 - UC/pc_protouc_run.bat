ghdl -a pc.vhd
ghdl -e pc
ghdl -a protouc.vhd
ghdl -e protouc
ghdl -a pc_protouc.vhd
ghdl -e pc_protouc
ghdl -a pc_protouc_tb.vhd
ghdl -e pc_protouc_tb
ghdl -r pc_protouc_tb --stop-time=2500ns --wave=pc_protouc_e_tb.ghw
gtkwave pc_protouc_e_tb.ghw
pause