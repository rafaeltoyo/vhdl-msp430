library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity toplevel_pc_rom_uc is
	port(
		clk			: in  std_logic;
		rst			: in  std_logic;
		enable		: in  std_logic;
		output_pc	: out unsigned(6 downto 0);
		output_rom	: out unsigned(16 downto 0)
	);
end entity;

architecture a_toplevel_pc_rom_uc of toplevel_pc_rom_uc is
	signal enable_pc, current_state, uc_jump_flag, uc_error_flag : std_logic;
	signal input_pc_s, output_pc_s, input_rom_s : unsigned(6 downto 0);
	signal output_rom_s, instruction : unsigned(16 downto 0);
	
	component pc
	port(
		clk		: in  std_logic;
		rst		: in  std_logic;
		wr_en	: in  std_logic;
		data_in	: in  unsigned(6 downto 0);
		data_out: out unsigned(6 downto 0)
	);
	end component;
	component rom
	port(
		clk		: in std_logic;
		address	: in unsigned(6 downto 0);
		data	: out unsigned(16 downto 0)
	);
	end component;
	component state_machine
	port(
		clk			: in  std_logic;
		rst			: in  std_logic;
		enable		: in  std_logic;
		state_out	: out std_logic
	);
	end component;
	component control_unit
	port(
		instr		: in  unsigned(16 downto 0);
		jump_en_o	: out std_logic;
		error_o		: out std_logic
	);
	end component;
begin
	my_pc	: pc port map(
				clk=>clk,
				rst=>rst,
				wr_en=>enable_pc,
				data_in=>input_pc_s,
				data_out=>output_pc_s
			);
	my_rom	: rom port map(
				clk=>clk,
				address=>input_rom_s,
				data=>output_rom_s
			);
	my_stm	: state_machine port map(
				clk=>clk,
				rst=>rst,
				enable=>enable,
				state_out=>current_state
			);
	my_ctun	: control_unit port map(
				instr=>instruction,
				jump_en_o=>uc_jump_flag,
				error_o=>uc_error_flag
			);
			
	-- Saida da memoria atual sendo decodificada
	instruction <=		output_rom_s;
	
	-- State 0 -> fetch
	input_rom_s <=		output_pc_s when current_state = '0' else
						input_rom_s when current_state = '1' else
						"0000000";
	-- State 1 -> att PC
	enable_pc <= 		current_state and enable;
	input_pc_s <=		instruction(6 downto 0) when uc_jump_flag = '1' else
						output_pc_s + 1 when uc_jump_flag = '0' else
						"0000000";
	-- Debug
	output_pc 	<= 		output_pc_s;
	output_rom 	<= 		output_rom_s;
end architecture;