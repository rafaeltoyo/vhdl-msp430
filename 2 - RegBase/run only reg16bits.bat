ghdl -a reg16bits.vhd
ghdl -e reg16bits
ghdl -a reg16bits_tb.vhd
ghdl -e reg16bits_tb
ghdl -r reg16bits_tb --stop-time=3000ns --wave=reg16bits_e_tb.ghw
gtkwave reg16bits_e_tb.ghw
pause