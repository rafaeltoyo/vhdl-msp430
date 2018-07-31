library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
	port(
		clk		: in std_logic;
		address	: in unsigned(6 downto 0);
		data	: out unsigned(16 downto 0)
	);
end entity;

architecture a_rom of rom is
	type mem is array (0 to 127) of unsigned(16 downto 0);
	constant rom_data : mem := (
		0 => "00111100000000001", -- 0x07801 - Jump to 0000001 (1)
		1 => "00000000000000000", -- 0x00000 - Nop
		2 => "00111100000000111", -- 0x07807 - Jump to 0000111 (7)
		3 => "00111100000000110", -- 0x07806 - Jump to 0000110 (6)
		4 => "00000000001010000", -- 0x00050 - Error
		5 => "00111100000000011", -- 0x07803 - Jump to 0000011 (3)
		6 => "00111100001010111", -- 0x07857 - Jump to 1010111 (87)
		7 => "00111100000000100", -- 0x07804 - Jump to 0000100 (4)
		-- others address: empty data
		others => (others=>'0')
	);
begin
	process(clk)
	begin
		if(rising_edge(clk)) then
			data <= rom_data(to_integer(address));
		end if;
	end process;
end architecture;