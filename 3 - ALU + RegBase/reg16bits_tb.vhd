library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- para usarmos UNSIGNED
entity reg16bits_tb is
end;
architecture a_reg16bits_tb of reg16bits_tb is
	component reg16bits
	port( 	clk, rst, wr_en : in  std_logic;
			data_in	: in  unsigned(15 downto 0);
			data_out: out unsigned(15 downto 0)
			);
	end component;
signal clk,rst,wr_en : std_logic;
signal data_in,data_out	: unsigned(15 downto 0);
begin
	uut: reg16bits port map(clk=>clk,
							rst=>rst,
							wr_en=>wr_en,
							data_in=>data_in,
							data_out=>data_out
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
		wr_en <= '0';
		data_in <= "0110110000110110";
		wait for 100 ns;
		wr_en <= '0';
		data_in <= "0110110000110110";
		wait for 100 ns;
		wr_en <= '1';
		data_in <= "1001000011110101";
		wait for 100 ns;
		wr_en <= '1';
		data_in <= "0110110000110110";
		wait for 100 ns;
		wr_en <= '0';
		data_in <= "1111111111111111";
		wait for 100 ns;
		wr_en <= '0';
		data_in <= "1111111111111111";
		wait;
	end process;
end architecture;