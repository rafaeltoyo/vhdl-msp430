library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- para usarmos UNSIGNED
entity reg_pc_tb is
end;

architecture a_reg_pc_tb of reg_pc_tb is
	component reg_pc
	port(
		clk			: in  std_logic;
		rst			: in  std_logic;
		wr_en		: in  std_logic;
		jump_in 	: in  std_logic;
		offset_in	: in std_logic;
		const_op_in	: in std_logic;
		data_in 	: in  unsigned(15 downto 0);
		data_out	: out unsigned(15 downto 0)
	);
	end component;
signal clk,rst,wr_en,jump_s,const_op_s,offset_s : std_logic;
signal data_s : unsigned(15 downto 0);
begin
	uut: reg_pc port map(
		clk=>clk, rst=>rst, wr_en=>wr_en,
		jump_in=>jump_s, offset_in=>offset_s, const_op_in=>const_op_s,
		data_in=>data_s
	);
	-- Clock
	process
	begin
		clk <= '0';
		wait for 50 ns;
		clk <= '1';
		wait for 50 ns;
	end process;
	-- Reset
	process
	begin
		rst <= '1';
		wait for 100 ns;
		rst <= '0';
		wait;
	end process;
	-- Dados
	process
	begin
		wait for 100 ns;
		wr_en <= '1';
		jump_s <= '0';
		offset_s <= '1';
		const_op_s <= '0';
		data_s <= "0000000000000000";
		wait for 400 ns;
		const_op_s <= '1';
		wait for 100 ns;
		const_op_s <= '0';
		wait for 100 ns;
		const_op_s <= '1';
		wait for 300 ns;
		const_op_s <= '0';
		jump_s <= '1';
		data_s <= "0000000000100000";
		wait for 200 ns;
		offset_s <= '0';
		data_s <= "1010101010101010";
		wait for 200 ns;
		jump_s <= '0';
		offset_s <= '1';
		wait;
	end process;
end architecture;
	
		