ghdl -a ALU.vhd
ghdl -e ALU
ghdl -a ALU_tb.vhd
ghdl -e ALU_tb
ghdl -r ALU_tb --wave=ALU_e_tb.ghw
gtkwave ALU_e_tb.ghw