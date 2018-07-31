library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity rom_tb is
end;
architecture a_rom_tb of rom_tb is
	component rom
	port(
		clk		: in std_logic;
		address	: in unsigned(6 downto 0);
		data	: out unsigned(16 downto 0)
	);
	end component;
	signal clk		: std_logic;
	signal address	: unsigned(6 downto 0);
	signal data		: unsigned(16 downto 0);
begin
	uut: rom port map(
				clk => clk,
				address => address,
				data => data
			);
	process -- Sinal de clock
	begin
		clk <= '0';
		wait for 50 ns;
		clk <= '1';
		wait for 50 ns;
	end process;
	
	process -- Sinal de dados
	begin
		wait for 100 ns; -- Esperar o reset do resto?
		address <= "0000000"; -- 0
		wait for 100 ns;
		address <= "0000001"; -- 1
		wait for 100 ns;
		address <= "0000010"; -- 2
		wait for 100 ns;
		address <= "0000011"; -- 3
		wait for 100 ns;
		address <= "0000100"; -- 4
		wait for 100 ns;
		address <= "0000101"; -- 5
		wait for 100 ns;
		address <= "0000110"; -- 6
		wait for 100 ns;
		address <= "0000111"; -- 7
		wait for 100 ns;
		address <= "0001000"; -- 8
		wait for 100 ns;
		address <= "0010000"; -- 16
		wait;
	end process;
end architecture;