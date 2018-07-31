library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity processador_tb is
end;
architecture a_processador_tb of processador_tb is
	component processador
	port(
		clk, rst		: in std_logic;
		debug_estado	: out unsigned(1 downto 0);
		debug_pc		: out unsigned(15 downto 0);
		debug_instr		: out unsigned(16 downto 0);
		debug_reg_a		: out unsigned(15 downto 0);
		debug_reg_b		: out unsigned(15 downto 0);
		debug_ula		: out unsigned(15 downto 0)
	);
	end component;
signal clk, rst     :  std_logic;
signal debug_estado :  unsigned(1 downto 0);
signal debug_pc     :  unsigned(15 downto 0);
signal debug_instr	:  unsigned(16 downto 0);
signal debug_reg_a	:  unsigned(15 downto 0);
signal debug_reg_b	:  unsigned(15 downto 0);
signal debug_ula    :  unsigned(15 downto 0);
begin
	uut: processador port map (
		clk=>clk,
		rst=>rst,
		debug_estado=>debug_estado,
		debug_pc=>debug_pc,
		debug_instr=>debug_instr,
		debug_reg_a=>debug_reg_a,
		debug_reg_b=>debug_reg_b,
		debug_ula =>debug_ula
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
end architecture;