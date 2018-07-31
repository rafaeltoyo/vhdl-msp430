ghdl -a ALU.vhd
ghdl -e ALU
ghdl -a reg16bits.vhd
ghdl -e reg16bits
ghdl -a regbase.vhd
ghdl -e regbase
ghdl -a toplevel.vhd
ghdl -e toplevel
ghdl -a toplevel_tb.vhd
ghdl -e toplevel_tb
ghdl -r toplevel_tb --stop-time=3000ns --wave=toplevel_e_tb.ghw
gtkwave toplevel_e_tb.ghw
pause