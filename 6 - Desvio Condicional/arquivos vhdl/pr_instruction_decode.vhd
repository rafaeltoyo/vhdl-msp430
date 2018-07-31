library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity pr_instruction_decode is
	port(
		clk 		: in  std_logic;				-- Clock
		rst 		: in  std_logic;				-- Reset
		enable 		: in  std_logic;				-- Enable da etapa de decode
		instr_in	: in  unsigned(16 downto 0);	-- Entrada da instr. atual
		const_in	: in  unsigned(16 downto 0);	-- Entrada da possivel constante
		sel_reg_dst	: out unsigned(3 downto 0);		-- Saida do seletor do reg DST
		addr_dst	: out std_logic;				-- Saida do modo de enderecamento do reg DST
		sel_reg_src	: out unsigned(3 downto 0);		-- Saida do seletor do reg SRC
		addr_src	: out unsigned(1 downto 0);		-- Saida do modo de enderecamento do reg SRC ou reg DST em operacoes de unico reg
		offset_out	: out unsigned(9 downto 0);		-- Saida de possivel offset para um jump
		const_out	: out unsigned(15 downto 0)		-- Saida da possivel constante
	);
end entity;

architecture a_pr_instruction_decode of pr_instruction_decode is
	component reg_instr
	port(
		clk 		: in  std_logic;
		rst 		: in  std_logic;
		wr_en 		: in  std_logic;
		data_in		: in  unsigned(16 downto 0);
		data_out	: out unsigned(16 downto 0)
	);
	end component;
	
	signal pc_wr_en : std_logic;
	signal sel_reg_a_s, sel_reg_b_s : unsigned(7 downto 0);
	signal const_out_s, instr_out_s : unsigned(16 downto 0);
	signal mr_data_out_s, mr_const_out_s : unsigned(16 downto 0);
begin
	-- Salvar a instr. em um reg
	instruction : reg_instr port map(
			clk => clk,
			rst => rst,
			wr_en => enable,
			data_in => instr_in,
			data_out => instr_out_s
		);
	-- Salvar a const em um reg
	const : reg_instr port map (
			clk => clk,
			rst => rst,
			wr_en => enable,
			data_in => const_in,
			data_out => const_out_s
		);
		
	const_out <= 	const_out_s(15 downto 0); -- Pegar so 16 bits
	offset_out <= 	instr_out_s(9 downto 0); -- Pegar so 10 bits
	sel_reg_dst <=	instr_out_s(3 downto 0); -- Seletor de 4 bits do reg A (16 regs) para o reg_bank
	sel_reg_src <= 	instr_out_s(11 downto 8); -- Seletor de 4 bits do reg B (16 regs) para o reg_bank
end architecture;