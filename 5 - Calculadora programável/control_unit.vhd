library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit is
	port(
		clk, rst, enable	: in  std_logic;
		instr				: in  unsigned(16 downto 0);
		enable_out_fetch	: out std_logic;
		enable_out_decode	: out std_logic;
		enable_out_write_reg: out std_logic;
		enable_out_write_pc	: out std_logic;
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
	
	signal jump_en_s, nop_s : std_logic;
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
	
	-- Trocar de estagio no multiciclo
	enable_out_fetch <= '1' when current_state = "00" else '0';
	enable_out_decode <= '1' when current_state = "01" else '0';
	enable_out_execute <= '1' when current_state = "10" else '0';
	enable_out_write_reg <= '1' when current_state = "10" else '0';
	enable_out_write_pc <= '1' when current_state = "10" else '0';

	-- MSP 430 Instruction => 16bits POREM nossa ROM será de 17bits (nao temos escolha) vamos jogar fora o MSB e codificar igual a ISA do MSP 430
	nop_s <=		'1' when instr = "00000000000000000" else
					'0';
	
	opcode <= 		instr(15 downto 12);
	condition <= 	instr(13 downto 11); -- Se for jump
	-- Operacao com 1 registrador: 
	-- 000 + 100 + opcode(3bits) + B/W(1bit) + As(2bits) + Reg(4bits)
	-- Nao usa por enquanto
	
	-- Jump: 
	-- 001 + 3bit (condition) + 10bit (offset)!
	-- cond = 111 -> unconditionally
	
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
						"10" when opcode(3 downto 1) = "001" and condition = "111" else
						"00";
end architecture;