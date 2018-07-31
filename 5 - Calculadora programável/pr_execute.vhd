library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity pr_execute is
	port(
		sel_op_alu	: in  unsigned(3 downto 0);		-- Selecionar operacao da ULA
		sel_b_in	: in  std_logic;				-- Selecionar se usar regB ou const
		sel_pc_add	: in  unsigned(1 downto 0);		-- Mux do incremento do PC
		data_a_in	: in  unsigned(15 downto 0);	-- Entrada regA
		data_b_in	: in  unsigned(15 downto 0);	-- Entrada regB
		offset_in	: in  unsigned(9 downto 0);		-- Offset para o Jump
		data_cst_in	: in  unsigned(15 downto 0);	-- Entrada de const para substituir o regB
		addr_pc_in	: in  unsigned(15 downto 0);	-- Entrada de endereço do PC
		new_pc_out	: out unsigned(15 downto 0);	-- Saida do PC para o write back
		ula_data_out: out unsigned(15 downto 0)		-- Saida da ULA para o write back
	);
end entity;

architecture a_pr_execute of pr_execute is
	component alu
	port(
			input1 	: in  unsigned(15 downto 0); 	-- Entrada 1
			input2 	: in  unsigned(15 downto 0); 	-- Entrada 2
			opcode 	: in  unsigned( 3 downto 0); 	-- Seletor da operacao
			output 	: out unsigned(15 downto 0);	-- output das operacoes
			zero  	: out std_logic;				-- output igual a zero (resultado da + ou -)
			carry 	: out std_logic;				-- Carry out (Apenas em +)
			overflow: out std_logic;				-- Overflow
			negative: out std_logic					-- output negativa (resultado da + ou -)				
	);
	end component;
	
	signal zero, carry, overflow, negative : std_logic;
	signal output_alu_aux, input_a_alu, input_b_alu, offset_extended_s : unsigned(15 downto 0);
begin
	regALU16bit : alu port map (
			input1		=> input_a_alu,
			input2		=> input_b_alu,
			opcode		=> sel_op_alu,
			output		=> output_alu_aux,
			zero		=> zero,
			carry		=> carry,
			overflow	=> overflow,
			negative	=> negative
		);
		
	-- offset eh 10bits, tem q extender o sinal com 6 bits
	offset_extended_s <= offset_in(9)&offset_in(9)&offset_in(9)&offset_in(9)&offset_in(9)&offset_in(9)&offset_in;
	
	-- MUX A - Entrada de dados do reg A (PS: nao eh uma mux ainda, mas pode virar)
	input_a_alu <= 	data_a_in;
	-- MUX B - Entrada de dados do reg B ou da constante
	input_b_alu <= 	data_b_in when sel_b_in = '1' else
					data_cst_in when sel_b_in = '0' else
					"0000000000000000";
	-- Saida do resultado da ULA
	ula_data_out <=	output_alu_aux;	
	-- Saida do resultado do novo PC
	new_pc_out <=	addr_pc_in + 1 when sel_pc_add = "00" else
					addr_pc_in + 2 when sel_pc_add = "01" else
					addr_pc_in + offset_extended_s when sel_pc_add = "10" else 
					addr_pc_in;
	
end architecture;