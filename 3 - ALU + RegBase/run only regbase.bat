ghdl -a reg16bits.vhd
ghdl -e reg16bits
ghdl -a regbase.vhd
ghdl -e regbase
ghdl -a regbase_tb.vhd
ghdl -e regbase_tb
ghdl -r regbase_tb --stop-time=3000ns --wave=regbase_e_tb.ghw
gtkwave regbase_e_tb.ghw
pause