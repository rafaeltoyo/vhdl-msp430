library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- para usarmos UNSIGNED
entity pc_protouc_tb is
end;
architecture a_pc_protouc_tb of pc_protouc_tb is
	component pc_protouc
	port(
		clk			: in  std_logic;
		rst			: in  std_logic;
		wr_en		: in  std_logic;
		current_pc	: out unsigned(6 downto 0)
	);
	end component;
signal clk,rst,wr_en : std_logic;
signal current_pc : unsigned(6 downto 0);
begin
	utt	: pc_protouc port map(
				clk=>clk,
				rst=>rst,
				wr_en=>wr_en,
				current_pc=>current_pc
			);
	process -- Sinal de clock
	begin
		clk <= '0';
		wait for 50 ns;
		clk <= '1';
		wait for 50 ns;
	end process;
	
	process -- Sinal de reset
	begin
		rst <= '1';
		wait for 100 ns;
		rst <= '0';
		wait;
	end process;
	
	process -- Sinal de dados
	begin
		wait for 100 ns;
		wr_en <= '1';
		wait;
	end process;
end architecture;