cd arquivos vhdl
ghdl -a alu.vhd
ghdl -e alu
ghdl -a rom.vhd
ghdl -e rom
ghdl -a ram.vhd
ghdl -e ram
ghdl -a reg_base.vhd
ghdl -e reg_base
ghdl -a reg_instr.vhd
ghdl -e reg_instr
ghdl -a reg_bank.vhd
ghdl -e reg_bank
ghdl -a state_machine.vhd
ghdl -e state_machine
ghdl -a control_unit.vhd
ghdl -e control_unit
ghdl -a pr_instruction_fetch.vhd
ghdl -e pr_instruction_fetch
ghdl -a pr_instruction_decode.vhd
ghdl -e pr_instruction_decode
ghdl -a pr_memory.vhd
ghdl -e pr_memory
ghdl -a pr_execute.vhd
ghdl -e pr_execute
ghdl -a processador.vhd
ghdl -e processador
ghdl -a processador_tb.vhd
ghdl -e processador_tb
ghdl -r processador_tb --stop-time=250000ns --wave=processador_e_tb.ghw
gtkwave processador_e_tb.ghw
pause