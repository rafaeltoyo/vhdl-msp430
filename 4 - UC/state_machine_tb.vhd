library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- para usarmos UNSIGNED
entity state_machine_tb is
end;
architecture a_state_machine_tb of state_machine_tb is
	component state_machine
	port(
		clk			: in  std_logic;
		rst			: in  std_logic;
		enable		: in  std_logic;
		state_out	: out std_logic
	);
	end component;
	signal clk,rst,enable,state_out : std_logic;
begin
	utt	: state_machine port map(
				clk=>clk,
				rst=>rst,
				enable=>enable,
				state_out=>state_out
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
		enable <= '1';
		wait for 400 ns;
		enable <= '0';
		wait for 200 ns;
		enable <= '1';
		wait;
	end process;
end architecture;