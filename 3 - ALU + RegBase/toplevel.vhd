library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- para usarmos UNSIGNED
entity toplevel is
	port(	sel_reg_a	: in  unsigned(2 downto 0);	-- Seletor do registrador A
			sel_reg_b	: in  unsigned(2 downto 0);	-- Seletor do registrador B
			sel_reg_wr	: in  unsigned(2 downto 0); -- Seletor do registrador de escrita
			sel_op_alu	: in  unsigned(3 downto 0);	-- Seletor da operacao da ALU
			input_const	: in  unsigned(15 downto 0);-- Entrada de uma constante (input B)
			sel_imed_b	: in  std_logic;			-- Seletor da MUX do input B
			clk			: in  std_logic;			-- Clock geral
			rst			: in  std_logic;			-- Reset geral
			wr_en		: in  std_logic;			-- Habilitar escrita
			zero  		: out std_logic;			-- output igual a zero (resultado da + ou -)
			carry 		: out std_logic;			-- Carry out (Apenas em +)
			overflow	: out std_logic;			-- Overflow
			negative	: out std_logic;			-- output negativa (resultado da + ou -)
			output_alu	: out unsigned(15 downto 0)-- Saida da ALU pra debug
		);
end entity;

architecture a_toplevel of toplevel is
	component ALU
	port( 	input1 		: in  unsigned(15 downto 0); 	-- Entrada 1
			input2 		: in  unsigned(15 downto 0); 	-- Entrada 2
			opcode 		: in  unsigned( 3 downto 0); 	-- Seletor da operacao
			output 		: out unsigned(15 downto 0);	-- output das operacoes
			zero  		: out std_logic;				-- output igual a zero (resultado da + ou -)
			carry 		: out std_logic;				-- Carry out (Apenas em +)
			overflow	: out std_logic;				-- Overflow
			negative	: out std_logic					-- output negativa (resultado da + ou -)
			);
	end component;
	component regbase
	port( 	sel_reg_a 	: in  unsigned(2 downto 0);	-- Seletor do registrador A
			sel_reg_b	: in  unsigned(2 downto 0);	-- Seletor do registrador B
			write_data	: in  unsigned(15 downto 0);-- Dado de entrada para escrita
			sel_write	: in  unsigned(2 downto 0);	-- Seletor do reg para escrita de dado
			clk			: in  std_logic;			-- Clock geral
			rst			: in  std_logic;			-- Reset geral
			wr_en		: in  std_logic;			-- Habilitar escrita geral
			out_reg_a	: out unsigned(15 downto 0);-- Saida do registrador A
			out_reg_b	: out unsigned(15 downto 0)	-- Saida do registrador B
			);
	end component;
	signal input_a_alu, input_b_alu, input_wr_reg, output_a_reg, output_b_reg, output_alu_aux: unsigned(15 downto 0);
begin
	regALU		: ALU port map (
			input1		=> input_a_alu,
			input2		=> input_b_alu,
			opcode		=> sel_op_alu,
			output		=> output_alu_aux,
			zero		=> zero,
			carry		=> carry,
			overflow	=> overflow,
			negative	=> negative
			);
	registers 	: regbase port map (
			sel_reg_a	=> sel_reg_a,
			sel_reg_b	=> sel_reg_b,
			write_data	=> input_wr_reg,
			sel_write	=> sel_reg_wr,
			clk			=> clk,
			rst			=> rst,
			wr_en		=> wr_en,
			out_reg_a	=> output_a_reg,
			out_reg_b	=> output_b_reg
			);

	-- MUX A
	input_a_alu <=	output_a_reg;
	-- MUX B
	input_b_alu <= 	input_const when sel_imed_b = '1' else
					output_b_reg;
	output_alu 	<=	output_alu_aux;
	input_wr_reg<=	output_alu_aux;
end architecture;
				