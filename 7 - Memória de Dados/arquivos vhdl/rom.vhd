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

-- Assembly

-- 		MOV.W #5,R3
--		MOV.W #12,R5
--		MOV.W #6,R6
--		MOV.W #37,R7

--		MOV.W R3,@R5
--		MOV.W @R5,R4
--		MOV.W @R5,@R7
--		ADD.W R6,@R7
--		MOV.W R7,@R6
--		MOV.W R6,@R3
--		SUB.W @R5,@R4

--		MOV.W R3,R1
--		MOV.W @R3,R1
--		MOV.W R4,R1
--		MOV.W @R4,R1
--		MOV.W R5,R1
--		MOV.W @R5,R1
--		MOV.W R6,R1
--		MOV.W @R6,R1
--		MOV.W R7,R1
--		MOV.W @R7,R1

-- Opcode
--	0:	0 0100 0000 0 0 11 0011		// MOV.W @PC+,R3
--	1:	0 0000000000000101			// 5
--	2:	0 0100 0000 0 0 11 0101		// MOV.W @PC+,R5
--	3:	0 0000000000001100			// 12
--	4:	0 0100 0000 0 0 11 0110		// MOV.W @PC+,R6
--	5:	0 0000000000000110			// 6
--	6:	0 0100 0000 0 0 11 0111		// MOV.W @PC+,R7
--	7:	0 0000000000100101			// 37

--	8:	0 0100 0011 1 0 00 0101		// MOV.W R3,@R5
--	9:	0 0100 0101 0 0 10 0100		// MOV.W @R5,R4
--	10:	0 0100 0101 1 0 10 0111		// MOV.W @R5,@R7
--	11:	0 0101 0110 1 0 00 0111		// ADD.W R6,@R7
--	12:	0 0100 0111 1 0 00 0110		// MOV.W R7,@R6
--	13:	0 0100 0110 1 0 00 0011		// MOV.W R6,@R3
--	14:	0 1000 0101 1 0 11 0100		// SUB.W @R5,@R4

--	15: 0 0100 0011 0 0 00 0001		// MOV.W R3,R1
--	16: 0 0100 0011 0 0 10 0001		// MOV.W @R3,R1
--	17: 0 0100 0100 0 0 00 0001		// MOV.W R4,R1
--	18: 0 0100 0100 0 0 10 0001		// MOV.W @R4,R1
--	19: 0 0100 0101 0 0 00 0001		// MOV.W R5,R1
--	20: 0 0100 0101 0 0 10 0001		// MOV.W @R5,R1
--	21: 0 0100 0110 0 0 00 0001		// MOV.W R6,R1
--	22: 0 0100 0110 0 0 10 0001		// MOV.W @R6,R1
--	23: 0 0100 0111 0 0 00 0001		// MOV.W R7,R1
--	24: 0 0100 0111 0 0 10 0001		// MOV.W @R7,R1

architecture a_rom of rom is
	type mem is array (0 to 255) of unsigned(16 downto 0);
	constant rom_data : mem := (
		0  => "00100000000110011",	-- MOV.W @PC+,R3
		1  => "00000000000000101",	-- 5
		2  => "00100000000110101",	-- MOV.W @PC+,R5
		3  => "00000000000001100",	-- 12
		4  => "00100000000110110",	-- MOV.W @PC+,R6
		5  => "00000000000000110",	-- 6
		6  => "00100000000110111",	-- MOV.W @PC+,R7
		7  => "00000000000100101",	-- 37
		8  => "00100001110000101",	-- MOV.W R3,@R5
		9  => "00100010100100100",	-- MOV.W @R5,R4
		10 => "00100010110100111",	-- MOV.W @R5,@R7
		11 => "00101011010000111",	-- ADD.W R6,@R7
		12 => "00100011110000110",	-- MOV.W R7,@R6
		13 => "00100011010000011",	-- MOV.W R6,@R3
		14 => "01000010110110100",	-- SUB.W @R5,@R4
		15 => "00100001100000001",	-- MOV.W R3,R1
		16 => "00100001100100001",	-- MOV.W @R3,R1
		17 => "00100010000000001",	-- MOV.W R4,R1
		18 => "00100010000100001",	-- MOV.W @R4,R1
		19 => "00100010100000001",	-- MOV.W R5,R1
		20 => "00100010100100001",	-- MOV.W @R5,R1
		21 => "00100011000000001",	-- MOV.W R6,R1
		22 => "00100011000100001",	-- MOV.W @R6,R1
		23 => "00100011100000001",	-- MOV.W R7,R1
		24 => "00100011100100001",	-- MOV.W @R7,R1
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