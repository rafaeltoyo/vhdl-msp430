library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity toplevel_pc_rom is
	port(
		clk			: in  std_logic;
		rst			: in  std_logic;
		wr_en		: in  std_logic;
		output_pc	: out unsigned(6 downto 0);
		output_rom	: out unsigned(16 downto 0)
	);
end entity;

architecture a_toplevel_pc_rom of toplevel_pc_rom is
	signal output_pc_s : unsigned(6 downto 0);
	signal output_rom_s : unsigned(16 downto 0);
	component pc_protouc
	port(
		clk			: in  std_logic;
		rst			: in  std_logic;
		wr_en		: in  std_logic;
		current_pc	: out unsigned(6 downto 0)
	);
	end component;
	component rom
	port(
		clk		: in std_logic;
		address	: in unsigned(6 downto 0);
		data	: out unsigned(16 downto 0)
	);
	end component;
begin
	my_pc	: pc_protouc port map(
				clk=>clk,
				rst=>rst,
				wr_en=>wr_en,
				current_pc=>output_pc_s
			);
	my_rom	: rom port map(
				clk=>clk,
				address=>output_pc_s,
				data=>output_rom_s
			);
	
	output_pc 	<= output_pc_s;
	output_rom 	<= output_rom_s;
end architecture;