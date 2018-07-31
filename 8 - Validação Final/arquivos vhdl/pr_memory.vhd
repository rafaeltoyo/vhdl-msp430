library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity pr_memory is
	port(
		clk 		: in  std_logic;				-- Clock
		rst 		: in  std_logic;				-- Reset
		wr_en_pc	: in  std_logic;				-- Habilitar escrita do PC
		wr_en_main	: in  std_logic;				-- Habilitar escrita em registradores
		wr_en_ram	: in  std_logic;				-- Habilitar escrita na RAM
		sel_reg_a	: in  unsigned(3 downto 0);		-- Seletor Registrador A
		sel_type_a	: in  std_logic;				-- Modo de enderecamento do registrador A
		output_a	: out unsigned(15 downto 0);	-- Saida de dado A
		sel_reg_b	: in  unsigned(3 downto 0);		-- Seletor Registrador B
		sel_type_b	: in  std_logic; 				-- Modo de enderecamento do registrador B
		output_b	: out unsigned(15 downto 0);	-- Saida de dado B
		wr_back_pc	: in  unsigned(15 downto 0);	-- Entrada de escrita do PC	
		output_pc	: out unsigned(15 downto 0);	-- Saida de dado do PC
		wr_back_data : in unsigned(15 downto 0)		-- Entrada de escrita de registrador ou RAM
	);
end entity;

architecture a_pr_memory of pr_memory is
	component reg_bank
	port( 	
		clk			: in  std_logic;				-- Clock geral
		rst			: in  std_logic;				-- Reset geral
		wr_en		: in  std_logic;				-- Habilitar escrita geral
		wr_pc		: in  std_logic;				-- Habilitar escrita do PC
		sel_reg_a 	: in  unsigned(3 downto 0);		-- Seletor do registrador A / Registrador de escrita
		sel_reg_b	: in  unsigned(3 downto 0);		-- Seletor do registrador B
		wr_back_data: in  unsigned(15 downto 0);	-- Dado de entrada do Write back para escrita
		wr_back_pc	: in  unsigned(15 downto 0);	-- Dado de entrada do PC para escrita
		out_reg_a	: out unsigned(15 downto 0);	-- Saida do registrador A
		out_reg_b	: out unsigned(15 downto 0);	-- Saida do registrador B
		out_reg_pc	: out unsigned(15 downto 0)		-- Saida do PC
	);
	end component;
	
	component ram
	port(
		clk 		: in  std_logic;
		wr_en 		: in  std_logic;
		wr_data_in 	: in  unsigned(15 downto 0);
		addr_a_in 	: in  unsigned(15 downto 0);
		addr_b_in 	: in  unsigned(15 downto 0);
		data_a_out 	: out unsigned(15 downto 0);
		data_b_out 	: out unsigned(15 downto 0)
	);
	end component;
	
	signal out_reg_a_s, out_reg_b_s, out_reg_pc_s, out_ram_a_s, out_ram_b_s : unsigned(15 downto 0);
	signal mr_addr_s : unsigned(7 downto 0);
begin
	registradores : reg_bank port map(
			clk => clk,
			rst => rst,
			wr_en => wr_en_main,
			wr_pc => wr_en_pc,
			sel_reg_a => sel_reg_a,
			sel_reg_b => sel_reg_b,
			wr_back_data => wr_back_data,
			wr_back_pc => wr_back_pc,
			out_reg_a => out_reg_a_s,
			out_reg_b => out_reg_b_s,
			out_reg_pc => out_reg_pc_s
		);
		
	memoria : ram port map(
			clk => clk,
			wr_en => wr_en_ram,
			wr_data_in => wr_back_data,
			addr_a_in => out_reg_a_s,
			addr_b_in => out_reg_b_s,
			data_a_out => out_ram_a_s,
			data_b_out => out_ram_b_s
		);
	
	output_a <=		out_reg_a_s when sel_type_a = '0' else
					out_ram_a_s when sel_type_a = '1' else
					"0000000000000000";
	output_b <=		out_reg_b_s when sel_type_b = '0' else
					out_ram_b_s when sel_type_b = '1' else
					"0000000000000000";
	output_pc <=	out_reg_pc_s;
	
end architecture;