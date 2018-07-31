library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit is
	port(
		instr		: in  unsigned(16 downto 0);
		jump_en_o	: out std_logic;
		error_o		: out std_logic
	);
end entity;

architecture a_control_unit of control_unit is
	signal jump_en_s, nop_s : std_logic;
	signal opcode, condition : unsigned(2 downto 0);
begin
	-- MSP 430 Instruction => 16bits POREM nossa ROM será de 17bits (nao temos escolha)
	-- Vamos aumentar as instruções no LSB
	-- 16 - 14 (opcode base)
	nop_s <=		'1' when instr = "00000000000000000" else
					'0';
	
	opcode <= 		instr(16 downto 14);
	condition <= 	instr(13 downto 11); -- Se for jump
	-- Operacao com 1 registrador: 
	-- 000 + 100 + opcode(3bits) + B/W(1bit) + As(2bits) + Reg(4bits) + 1bit Magic !
	
	-- Jump: 
	-- 001 + 3bit (condition) + 10bit (offset) + 1bit Magic (LSB offset? :D) !
	-- cond = 111 -> unconditionally
	-- Era pra ser relativo sempre no MSP 430, mas foi pedido absoluto, entao ...
	jump_en_s <=	'1' when opcode = "001" and condition = "111" else
					'0';
	
	-- Operacao com 2 registradores: 
	-- opcode(01 ou 10 ou 11 + 2bits) + reg_src(4bits) + Ad(1bit) + B/W(1bit) + As(2bits) + reg_dst(4bits) + 1bit Magic !
	
	-- Arrumar saidas
	jump_en_o <=	jump_en_s;
	error_o <= 		'1' when jump_en_s = '0' and nop_s = '0' else
					'0';
	
end architecture;