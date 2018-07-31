library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit is
	port(
		clk, rst, enable	: in  std_logic;
		instr				: in  unsigned(16 downto 0);
		reg_state_in		: in  unsigned(15 downto 0);
		enable_out_fetch	: out std_logic;
		enable_out_decode	: out std_logic;
		enable_out_write_reg: out std_logic;
		enable_out_write_pc	: out std_logic;
		enable_out_write_ram: out std_logic;
		enable_out_execute	: out std_logic;
		sel_out_alu_op		: out unsigned(3 downto 0);
		sel_mux_b			: out std_logic;
		sel_mux_pc_add		: out unsigned(1 downto 0);
		debug_estado		: out unsigned(1 downto 0)
	);
end entity;

architecture a_control_unit of control_unit is
	component state_machine
	port(
		clk,rst,enb: in std_logic;
		state_out: out unsigned(1 downto 0)
	);
	end component;
	
	signal zero_flag_s, carry_flag_s, overflow_flag_s, negative_flag_s, flag_jmp_s : std_logic;
	signal current_state : unsigned(1 downto 0);
	signal condition : unsigned(2 downto 0);
	signal opcode : unsigned(3 downto 0);
begin
	state : state_machine port map (
			clk => clk,
			rst => rst,
			enb => enable,
			state_out => current_state
		);
	
	debug_estado <= current_state;
	
	zero_flag_s		<= reg_state_in(3);
	carry_flag_s 	<= reg_state_in(2);
	overflow_flag_s	<= reg_state_in(1);
	negative_flag_s	<= reg_state_in(0);
	
	-- Trocar de estagio no multiciclo
	enable_out_fetch <= '1' when current_state = "00" else '0';
	enable_out_decode <= '1' when current_state = "01" else '0';
	enable_out_execute <= '1' when current_state = "10" else '0';
	enable_out_write_reg <= '1' when current_state = "10" and instr(7) = '0' and not(instr = "00000000000000000") else '0'; -- Isso nao garante o congelamento em outros casos
	enable_out_write_ram <= '1' when current_state = "10" and instr(7) = '1' else '0';
	enable_out_write_pc <= '1' when current_state = "10" else '0';

	-- Pega o Opcode e a possivel condicao do jump
	opcode <= 		instr(15 downto 12);
	condition <= 	instr(12 downto 10); -- Se for jump
	-- Operacao com 1 registrador: 
	-- 000 + 100 + opcode(3bits) + B/W(1bit) + As(2bits) + Reg(4bits)
	-- Nao usa por enquanto
	
	-- Jump: 
	-- 001 + 3bit (condition) + 10bit (offset)!
	-- cond = 111 -> unconditionally
	-- not zero = 000 -> JNE/JNZ
	-- zero = 001 -> JEQ/JZ
	-- no carry = 010 -> JNC JLO
	-- carry = 011 -> JC/JHS
	-- negative = 100 -> JNC
	-- greater or equal = 101 -> JGE
	-- less = 110 -> JL
	
	flag_jmp_s <=	'1' when condition = "000" and zero_flag_s = '0' else
					'1' when condition = "001" and zero_flag_s = '1' else
					'1' when condition = "010" and carry_flag_s = '0' else
					'1' when condition = "011" and carry_flag_s = '1' else
					'1' when condition = "100" and negative_flag_s = '1' else
					'1' when condition = "101" and (negative_flag_s xor overflow_flag_s) = '0' else
					'1' when condition = "110" and (negative_flag_s xor overflow_flag_s) = '1' else
					'1' when condition = "111" else
					'0';
					
	
	-- Operacao com 2 registradores: 
	-- opcode(01 ou 10 ou 11 + 2bits) + reg_src(4bits) + Ad(1bit) + B/W(1bit) + As(2bits) + reg_dst(4bits) + 1bit Magic !
	
	-- Arrumar saidas
	
	sel_out_alu_op <=	"0101" when opcode = "0100" else -- Saida ULA = regB
						"0000" when opcode = "0101" else -- Saida ULA = regA + regB
						"0010" when opcode = "1000" else -- Saida ULA = regA - regB
						"0100"; -- Saida ULA = regA
						
	sel_mux_b <=		'0' when instr(5 downto 4) = "11" and instr(11 downto 9) = "0000" else -- Se for AS = 11, usa constante
						'1'; -- Se nao, usa regB
						
	sel_mux_pc_add <=	"01" when instr(5 downto 4) = "11" and instr(11 downto 9) = "0000" else
						"10" when opcode(3 downto 1) = "001" and flag_jmp_s = '1' else
						"00";
end architecture;