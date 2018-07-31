library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- para usarmos UNSIGNED
entity ALU_tb is
end;
architecture a_ALU_tb of ALU_tb is 
	component ALU
	port (	input1 	: in unsigned 	(15 downto 0);
			input2 	: in unsigned 	(15 downto 0);
			opcode  : in unsigned 	(3 downto 0);
			output 	: out unsigned 	(15 downto 0);
			zero  	: out std_logic;
			carry 	: out std_logic;
			overflow: out std_logic;
			negative: out std_logic
			);
end component;
signal input1 , input2 , output: unsigned (15 downto 0);
signal opcode : unsigned ( 3 downto 0);
signal zero , carry , overflow , negative : std_logic;
begin 
	uut: ALU port map (	input1 => input1,
							input2 => input2,
							opcode => opcode,
							output => output,
							zero => zero,
							carry => carry,
							overflow => overflow,
							negative => negative
							);
	process
	begin
		-- Inicio Teste Logico : NOT, AND OR e XOR
		input1 <= "0000000000000000";
		input2 <= "1111111111111111";
		opcode <= "0111";
		wait for 50 ns;
		opcode <= "1000";
		wait for 50 ns;
		opcode <= "1001";
		wait for 50 ns;
		opcode <= "1010";
		wait for 50 ns;
		input1 <= "1010101010101010";
		input2 <= "0101010101010101";
		opcode <= "0111";
		wait for 50 ns;
		opcode <= "1000";
		wait for 50 ns;
		opcode <= "1001";
		wait for 50 ns;
		opcode <= "1010";
		wait for 50 ns;
		input1 <= "1010101010101010";
		input2 <= "1010101010101010";
		opcode <= "0111";
		wait for 50 ns;
		opcode <= "1000";
		wait for 50 ns;
		opcode <= "1001";
		wait for 50 ns;
		opcode <= "1010";
		wait for 50 ns;
		input1 <= "0000000011111111";
		input2 <= "1111111100000000";
		opcode <= "0111";
		wait for 50 ns;
		opcode <= "1000";
		wait for 50 ns;
		opcode <= "1001";
		wait for 50 ns;
		opcode <= "1010";
		wait for 50 ns;
		-- Fim Teste Logico
		-- Inicio Teste Aritmetico
		input1 <= "0000000000000001"; -- +1
		input2 <= "0000000000000001"; -- +1
		opcode <= "0000";
		wait for 50 ns;
		opcode <= "0010";
		wait for 50 ns;
		input1 <= "0000000000000001"; -- +1
		input2 <= "1111111111111111"; -- -1
		opcode <= "0000";
		wait for 50 ns;
		opcode <= "0010";
		wait for 50 ns;
		input1 <= "1111111111111111"; -- -1
		input2 <= "0000000000000001"; -- +1
		opcode <= "0000";
		wait for 50 ns;
		opcode <= "0010";
		wait for 50 ns;
		input1 <= "1111111111111111"; -- -1
		input2 <= "1111111111111111"; -- -1
		opcode <= "0000";
		wait for 50 ns;
		opcode <= "0010";
		wait for 50 ns;
		input1 <= "0111111111111111"; -- +32.767
		input2 <= "0111111111111111"; -- +32.767
		opcode <= "0000";
		wait for 50 ns;
		opcode <= "0010";
		wait for 50 ns;
		input1 <= "0111111111111111"; -- +32.767
		input2 <= "1000000000000000"; -- -32.768
		opcode <= "0000";
		wait for 50 ns;
		opcode <= "0010";
		wait for 50 ns;
		input1 <= "1000000000000000"; -- -32.768
		input2 <= "0111111111111111"; -- +32.767
		opcode <= "0000";
		wait for 50 ns;
		opcode <= "0010";
		wait for 50 ns;
		input1 <= "1000000000000000"; -- -32.768
		input2 <= "1000000000000000"; -- -32.768
		opcode <= "0000";
		wait for 50 ns;
		opcode <= "0010";
		wait for 50 ns;
		input1 <= "0011111111111111"; -- +16.383
		input2 <= "0011111111111111"; -- +16.383
		opcode <= "0000";
		wait for 50 ns;
		opcode <= "0010";
		wait for 50 ns;
		input1 <= "0011111111111111"; -- +16.383
		input2 <= "1000000000000000"; -- -32.768
		opcode <= "0000";
		wait for 50 ns;
		opcode <= "0010";
		wait for 50 ns;
		input1 <= "1100000000000001"; -- -16.383
		input2 <= "1000000000000000"; -- -32.768
		opcode <= "0000";
		wait for 50 ns;
		opcode <= "0010";
		wait for 50 ns;
		-- Fim Teste Aritmetico
		wait;
	end process;
end architecture;