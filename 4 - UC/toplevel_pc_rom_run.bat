ghdl -a pc.vhd
ghdl -e pc
ghdl -a protouc.vhd
ghdl -e protouc
ghdl -a pc_protouc.vhd
ghdl -e pc_protouc
ghdl -a rom.vhd
ghdl -e rom
ghdl -a toplevel_pc_rom.vhd
ghdl -e toplevel_pc_rom
ghdl -a toplevel_pc_rom_tb.vhd
ghdl -e toplevel_pc_rom_tb
ghdl -r toplevel_pc_rom_tb --stop-time=2000ns --wave=toplevel_pc_rom_e_tb.ghw
gtkwave toplevel_pc_rom_e_tb.ghw
pause