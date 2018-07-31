ghdl -a tff_1bit.vhd
ghdl -e tff_1bit
ghdl -a tff_1bit_tb.vhd
ghdl -e tff_1bit_tb
ghdl -r tff_1bit_tb --stop-time=1000ns --wave=tff_1bit_e_tb.ghw
gtkwave tff_1bit_e_tb.ghw
pause