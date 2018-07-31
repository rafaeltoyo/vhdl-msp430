library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
	port(
		clk			: in  std_logic;
		enable		: in  std_logic;
		addr_in		: in  unsigned(7 downto 0);
		data_out	: out unsigned(16 downto 0);
		const_out	: out unsigned(16 downto 0)
	);
end entity;

architecture a_rom of rom is
	type mem is array (0 to 255) of unsigned(16 downto 0);
	constant rom_data : mem := (
		0 => "00100000000110001",
		1 => "00000000000000001",
		2 => "00100000000110011",
		3 => "00000000000100001",
		4 => "00100001010000010",
		5 => "00101000100000010",
		6 => "00100001000000100",
		7 => "01000001100000100",
		8 => "00011101111111100",
		9 => "00100000010110001",
		10 => "00000000000000000",
		11 => "00100000000110010",
		12 => "00000000000000010",
		13 => "00100001000100100",
		14 => "00101000000110100",
		15 => "00000000000000000",
		16 => "00010010000001010",
		17 => "00100001000100101",
		18 => "00101001000100101",
		19 => "00100010100000100",
		20 => "01000001100000100",
		21 => "00011100000000010",
		22 => "00011110000000100",
		23 => "00100000010110101",
		24 => "00000000000000000",
		25 => "00011111111111001",
		26 => "00101000100000010",
		27 => "00100001000000100",
		28 => "01000001100000100",
		29 => "00011101111110000",
		30 => "00100000100000010",
		31 => "00100001000100110",
		32 => "00101000100000010",
		33 => "00100001000000100",
		34 => "01000001100000100",
		35 => "00011101111111100",
		-- others address: empty data
		others => (others=>'0')
	);
begin
	process(clk)
	begin
		if enable = '1' then
			if(rising_edge(clk)) then
				data_out <= rom_data(to_integer(addr_in));
				const_out <= rom_data(to_integer(addr_in+1));
			end if;
		end if;
	end process;
end architecture;