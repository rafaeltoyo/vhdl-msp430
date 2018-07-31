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
		0 => "00100000000110011", -- MOV.W @PC+,R3
		1 => "00000000000000000", -- 0
		2 => "00100000000110100", -- MOV.W @PC+,R4
		3 => "00000000000000000", -- 0
		4 => "00101001100000100", -- ADD.W R3,R4
		5 => "00101000000110011", -- ADD.W @PC+,R3
		6 => "00000000000000001", -- 1
		7 => "00100001100000001", -- MOV.W R3,R1
		8 => "01000000000110001", -- SUB.W @PC+,R1
		9 => "00000000000011110", -- 30
		10 => "00011101111111010", -- JL -6
		11 => "00100010000000101", -- MOV.W R4,R5
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