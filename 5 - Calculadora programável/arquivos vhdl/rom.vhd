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

-- R3 <= 5
-- R4 <= 8
-- R5 = R3 + R4
-- R5 = R5 - 1
-- Jump 20
-- R3 <= R5
-- Jump 3

-- Assembly

-- 		MOV.W #5,R3
-- 		MOV.W #8,R4
-- 		MOV.W R3,R5
-- 		ADD.W R4,R5
-- 		SUB.W #1,R5
-- 		MOV.W #20,R0
-- 		MOV.W R5,R3
-- 		MOV.W #4,R0

-- Opcode
-- 0/opcode/src/ad/bw/as/dst
-- 0 0100 0000 0 0 11 0011
-- 00000000000000101
-- 0 0100 0000 0 0 11 0100
-- 00000000000001000
-- 0 0100 0011 0 0 00 0101
-- 0 0101 0100 0 0 00 0101
-- 0 1000 0000 0 0 11 0101
-- 00000000000000001
-- 0 0100 0000 0 0 11 0000
-- 00000000000010100
-- 0 0100 0101 0 0 00 0011
-- 0 0100 0000 0 0 11 0000
-- 00000000000000100

-- 00 0001 0001 = 17
-- 11 1110 1111 = -17

architecture a_rom of rom is
	type mem is array (0 to 255) of unsigned(16 downto 0);
	constant rom_data : mem := (
		0 => "00100000000110011", -- MOV.W #5,R3
		1 => "00000000000000101", -- #5
		2 => "00100000000110100", -- MOV.W #8,R4
		3 => "00000000000001000", -- #8
		4 => "00100001100000101", -- MOV.W R3,R5
		5 => "00101010000000101", -- ADD.W R4,R5
		6 => "01000000000110101", -- SUB.W #1,R5
		7 => "00000000000000001", -- #1
		8 => "00100000000110000", -- MOV.W #20,R0
		9 => "00000000000010100", -- #20
		20=> "00100010100000011", -- MOV.W R5,R3
		21=> "00011111111101111", -- JMP #-17
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