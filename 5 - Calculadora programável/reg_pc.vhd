library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- para usarmos UNSIGNED
entity reg_pc is
	port(
		clk			: in  std_logic; 				-- Entrada do sinal de clock
		rst			: in  std_logic; 				-- Entrada para indicar reset
		wr_en		: in  std_logic; 				-- Entrada para habilitar escrita (permite clock)
		jump_in 	: in  std_logic;				-- Entrada Jump flag(usa o data_in)
		offset_in	: in std_logic;					-- Entrada Offset flag(usa o data_in como offset, senao usa como address bruto)
		const_op_in	: in std_logic;					-- Quando for operação tiver constante
		data_in 	: in  unsigned(15 downto 0);	-- Entrada de dados
		data_out	: out unsigned(15 downto 0)		-- Saida de dados
	);
end entity;
architecture a_reg_pc of reg_pc is
	component reg_base
	port( 	clk, rst, wr_en : in  std_logic;
			data_in	: in  unsigned(15 downto 0);
			data_out: out unsigned(15 downto 0)
			);
	end component;
	signal data_in_s, data_out_s : unsigned(15 downto 0);
begin 
	memory:	reg_base port map (
		clk => clk,
		rst => rst,
		wr_en => wr_en,
		data_in => data_in_s,
		data_out => data_out_s
	);
	data_in_s <= 	data_in when jump_in = '1' and offset_in = '0' else
					data_out_s + data_in when jump_in = '1' and offset_in = '1' else
					data_out_s + "0000000000000001" + ("000000000000000"&const_op_in) when jump_in = '0' else
					"0000000000000000";
	data_out <= 	data_out_s;
end architecture;
				