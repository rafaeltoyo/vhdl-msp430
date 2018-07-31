library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- para usarmos UNSIGNED
entity toplevel_pc_rom_uc_tb is
end;
architecture a_toplevel_pc_rom_uc_tb of toplevel_pc_rom_uc_tb is
	component toplevel_pc_rom_uc
	port(
		clk			: in  std_logic;
		rst			: in  std_logic;
		enable		: in  std_logic;
		output_pc	: out unsigned(6 downto 0);
		output_rom	: out unsigned(16 downto 0)
	);
	end component;
signal clk,rst,enable : std_logic;
signal output_pc : unsigned(6 downto 0);
signal output_rom : unsigned(16 downto 0);
begin
	utt	: toplevel_pc_rom_uc port map(
				clk=>clk,
				rst=>rst,
				enable=>enable,
				output_pc=>output_pc,
				output_rom=>output_rom
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
		wait;
	end process;
end architecture;