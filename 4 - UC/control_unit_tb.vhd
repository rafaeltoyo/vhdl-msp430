library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- para usarmos UNSIGNED
entity control_unit_tb is
end;
architecture a_control_unit_tb of control_unit_tb is
	component control_unit
	port(
		instr		: in  unsigned(16 downto 0);
		jump_en_o	: out std_logic;
		error_o		: out std_logic
	);
	end component;
signal jump_en_o,error_o : std_logic;
signal instr : unsigned(16 downto 0);
begin
	utt	: control_unit port map(
				instr=>instr,
				jump_en_o=>jump_en_o,
				error_o=>error_o
			);	
	process -- Sinal de dados
	begin
		instr <= "00000000000000000";
		wait for 100 ns;
		instr <= "00100000000000000";
		wait for 100 ns;
		instr <= "00111100000000000";
		wait for 100 ns;
		instr <= "00000000100000010";
		wait for 100 ns;
		instr <= "00111100000000010";
		wait for 100 ns;
		instr <= "10000000000011000";
		wait for 100 ns;
		instr <= "00000000000000001";
		wait for 100 ns;
		wait;
	end process;
end architecture;