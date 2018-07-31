ghdl -a control_unit.vhd
ghdl -e control_unit
ghdl -a pc.vhd
ghdl -e pc
ghdl -a rom.vhd
ghdl -e rom
ghdl -a tff_1bit.vhd
ghdl -e tff_1bit
ghdl -a state_machine.vhd
ghdl -e state_machine
ghdl -a toplevel_pc_rom_uc.vhd
ghdl -e toplevel_pc_rom_uc
ghdl -a toplevel_pc_rom_uc_tb.vhd
ghdl -e toplevel_pc_rom_uc_tb
ghdl -r toplevel_pc_rom_uc_tb --stop-time=4000ns --wave=toplevel_pc_rom_uc_e_tb.ghw
gtkwave toplevel_pc_rom_uc_e_tb.ghw
pause