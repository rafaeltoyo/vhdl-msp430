ghdl -a rom.vhd
ghdl -e rom
ghdl -a rom_tb.vhd
ghdl -e rom_tb
ghdl -r rom_tb --stop-time=1400ns --wave=rom_e_tb.ghw
gtkwave rom_e_tb.ghw
pause