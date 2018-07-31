library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- para usarmos UNSIGNED
entity reg_state is
	port(
		clk		: in  std_logic; 				-- Entrada do sinal de clock
		rst		: in  std_logic; 				-- Entrada para indicar reset
		wr_en	: in  std_logic; 				-- Entrada para habilitar escrita (permite clock)
		carry_in	: in  std_logic;			-- bit 0
		zero_in	: in  std_logic;				-- bit 1
		negative_in	: in  std_logic;			-- bit 2
		overflow_in	: in  std_logic;			-- bit 8
		data_out: out unsigned(15 downto 0)		-- Saida de dados
	);
end entity;
architecture a_reg_state of reg_state is
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
	data_in_s <= "0000000" & overflow_in & "00000" & negative_in & zero_in & carry_in;
	data_out <= data_out_s;
end architecture;
				