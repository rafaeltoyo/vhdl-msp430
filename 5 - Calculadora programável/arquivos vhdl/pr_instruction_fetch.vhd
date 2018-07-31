library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity pr_instruction_fetch is
	port(
		clk 		: in  std_logic;				-- Clock
		rst 		: in  std_logic;				-- Reset
		enable 		: in  std_logic;				-- Enable da etapa de fetch
		addr_pc_in	: in  unsigned(15 downto 0);	-- Entrada dos dados salvos no PC/R0
		data_mr_out	: out unsigned(16 downto 0);	-- Saida da instr. no endereco do PC/R0
		const_mr_out: out unsigned(16 downto 0)		-- Saida da instr. seguinte (PC+1) que possivelmente podera ser uma constante
	);
end entity;

architecture a_pr_instruction_fetch of pr_instruction_fetch is
	component reg_base
	port(
		clk 		: in  std_logic;
		rst 		: in  std_logic;
		wr_en 		: in  std_logic;
		data_in		: in  unsigned(15 downto 0);
		data_out	: out unsigned(15 downto 0)
	);
	end component;
	component rom
	port(
		clk			: in  std_logic;
		enable		: in  std_logic;
		addr_in		: in  unsigned(7 downto 0);
		data_out	: out unsigned(16 downto 0);
		const_out	: out unsigned(16 downto 0)
	);
	end component;
	
	signal mr_addr_s : unsigned(7 downto 0);
	signal output_pc_s : unsigned(15 downto 0);
	signal mr_data_out_s, mr_const_out_s : unsigned(16 downto 0);
begin
	pc : reg_base port map(
			clk => clk,
			rst => rst,
			wr_en => enable,
			data_in => addr_pc_in,
			data_out => output_pc_s
		);
	memory : rom port map(
			clk => clk,
			enable => enable,
			addr_in => mr_addr_s,
			data_out => mr_data_out_s,
			const_out => mr_const_out_s
		);
		
	-- ROM
	mr_addr_s <= 	addr_pc_in(7 downto 0);--output_pc_s(7 downto 0); -- 8bits de PC/R0
	data_mr_out <= 	mr_data_out_s; -- Saida de instr.
	const_mr_out <= mr_const_out_s; -- Saida de possivel const.
	
end architecture;