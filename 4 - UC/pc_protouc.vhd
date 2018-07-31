library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_protouc is
	port(
		clk			: in  std_logic;
		rst			: in  std_logic;
		wr_en		: in  std_logic;
		current_pc	: out unsigned(6 downto 0)
	);
end entity;

architecture a_pc_protouc of pc_protouc is
	signal pc_in,pc_out,uc_in,uc_out : unsigned(6 downto 0);
	component pc
	port(
		clk		: in  std_logic;
		rst		: in  std_logic;
		wr_en	: in  std_logic;
		data_in	: in  unsigned(6 downto 0);
		data_out: out unsigned(6 downto 0)
	);
	end component;
	component protouc
	port(
		data_in	: in  unsigned(6 downto 0);
		data_out: out unsigned(6 downto 0)
	);
	end component;
begin
	test_pc	: pc port map(
				clk=>clk,
				rst=>rst,
				wr_en=>wr_en,
				data_in=>pc_in,
				data_out=>pc_out
			);
	test_uc	: protouc port map(
				data_in=>uc_in,
				data_out=>uc_out
			);
	
	pc_in 		<= uc_out;
	uc_in 		<= pc_out;
	current_pc 	<= pc_out;
end architecture;