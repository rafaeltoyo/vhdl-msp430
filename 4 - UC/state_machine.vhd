library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- para usarmos UNSIGNED
entity state_machine is
	port( 	
		clk			: in  std_logic;
		rst			: in  std_logic;
		enable		: in  std_logic;
		state_out	: out std_logic
	);
end entity;
architecture a_state_machine of state_machine is
	signal output_pc_s, input_rom_s, address_mem : unsigned(6 downto 0);
	signal output_rom_s : unsigned(16 downto 0);
	signal tff_in, tff_out : std_logic;
	component tff_1bit
	port(
		clk		: in  std_logic;
		rst		: in  std_logic;
		wr_en	: in  std_logic;
		data_in	: in  std_logic;
		data_out: out std_logic
	);
	end component;
begin
	my_stmch: tff_1bit port map (
				clk=>clk,
				rst=>rst,
				wr_en=>enable,
				data_in=>tff_in,
				data_out=>tff_out
			);
	
	tff_in <= '1';
	state_out <= tff_out;
end architecture;
				