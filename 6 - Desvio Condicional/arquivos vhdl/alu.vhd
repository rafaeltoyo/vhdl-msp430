library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- para usarmos UNSIGNED
entity ALU is
	port( 	input1 	: in  unsigned(15 downto 0); 	-- Entrada 1
			input2 	: in  unsigned(15 downto 0); 	-- Entrada 2
			opcode 	: in  unsigned( 3 downto 0); 	-- Seletor da operacao
			output 	: out unsigned(15 downto 0);	-- output das operacoes
			zero  	: out std_logic;				-- output igual a zero (resultado da + ou -)
			carry 	: out std_logic;				-- Carry out (Apenas em +)
			overflow: out std_logic;				-- Overflow
			negative: out std_logic					-- output negativa (resultado da + ou -)
			);
end entity;
architecture a_ALU of ALU is
	signal toutput, aritm, tinput2 : unsigned(15 downto 0);
	signal toverflow, tinput2b : std_logic;
begin 
	tinput2	<=	("0000000000000000" - input2) when opcode = "0010" else
				input2 when opcode = "0000" else
				"0000000000000000";
				
	toutput	<=	input1 + tinput2 	when opcode = "0000" else -- Soma
				input1 + tinput2 	when opcode = "0010" else -- Subtracao
				input1 and input2 	when opcode = "1000" else -- And bit a bit
				input1 or input2 	when opcode = "1001" else -- Or bit a bit
				input1 xor input2 	when opcode = "1010" else -- Xor bit a bit
				input1				when opcode = "0100" else -- Mantem A
				input2				when opcode = "0101" else -- Mantem B
				"0000000000000000"; -- output default para operacoes invalidas(ou aritmetico)
	output	<=	toutput;
	
	aritm	<=	(('0' & input1(14 downto 0)) + tinput2) when opcode = "0010" and tinput2 = "1000000000000000" else -- Caso atipico dessa operacao
				(('0' & input1(14 downto 0)) + tinput2(14 downto 0)) when opcode = "0010" and not(tinput2 = "1000000000000000") else
				(('0' & input1(14 downto 0)) + tinput2(14 downto 0)) when opcode = "0000" else
				"0000000000000000";
	
				-- Famoso dibre
	tinput2b	<=	'0' when opcode = "0010" and tinput2 = "1000000000000000" else -- Esse numero eh positivo na verdade nesse caso
				tinput2(15);
	
	carry	<=	'1' when opcode = "0000" and aritm(15) = '1' and (input1(15) = '1' or tinput2b = '1') else
				'1' when opcode = "0000" and input1(15) = '1' and tinput2b = '1' else
				'0';
	zero <=		'1' when toutput = "0000000000000000" else
				'0';
	toverflow <='1' when input1(15) = '0' and tinput2b = '0' and aritm(15) = '1' and opcode(3 downto 2) = "00" else
				'1' when input1(15) = '1' and tinput2b = '1' and aritm(15) = '0' and opcode(3 downto 2) = "00" else
				'0';
	overflow <= toverflow;
	negative <= '1' when toverflow = '0' and toutput(15) = '1' and opcode(3 downto 2) = "00" else
				'1' when toverflow = '1' and toutput(15) = '0' and opcode(3 downto 2) = "00" else
				'0';
end architecture;
				