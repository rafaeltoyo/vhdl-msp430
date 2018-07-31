library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- para usarmos UNSIGNED
entity toplevel_tb is
end;
architecture a_toplevel_tb of toplevel_tb is
	component toplevel
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
	end component;
	signal clk, rst, wr_en, sel_imed_b, zero, carry, overflow, negative : std_logic;
	signal input_const, output_alu : unsigned(15 downto 0);
	signal sel_reg_a, sel_reg_b, sel_reg_wr : unsigned(2 downto 0);
	signal sel_op_alu : unsigned(3 downto 0);
begin
	uut: toplevel port map(	sel_reg_a => sel_reg_a,
							sel_reg_b => sel_reg_b,
							sel_reg_wr => sel_reg_wr,
							sel_op_alu => sel_op_alu,
							input_const => input_const,
							sel_imed_b => sel_imed_b,
							clk => clk,
							rst => rst,
							wr_en => wr_en,
							zero => zero,
							carry => carry,
							overflow => overflow,
							negative => negative,
							output_alu => output_alu
						);
	process -- Sinal de clock
	begin
		clk <= '0';
		wait for 50 ns;
		clk <= '1';
		wait for 50 ns;
	end process;
	
	process -- Sinal de reset ( 100 ns iniciais inativo )
	begin
		rst <= '1';
		wait for 100 ns;
		rst <= '0';
		wait;
	end process;
	
	process -- Sinal de dados
	begin
		wait for 100 ns; -- Esperar o reset
		sel_reg_a <= "000"; -- $zero
		sel_reg_b <= "000"; -- $zero
		sel_reg_wr <= "001"; -- $1
		sel_op_alu <= "0000"; -- Somar
		sel_imed_b <= '1'; -- usar constante
		wr_en <= '1'; -- Habilitar escrita e operador
		input_const <= "0000000000000100"; -- const = +4
		-- resultado: addi $1,$zero,const
		wait for 100 ns;
		sel_reg_a <= "001"; -- $1
		sel_reg_b <= "000"; -- $zero
		sel_reg_wr <= "010"; -- $2
		sel_op_alu <= "0010"; -- Subtrair
		sel_imed_b <= '1'; -- usar constante
		wr_en <= '1'; -- Habilitar escrita e operador
		input_const <= "0000000000000010"; -- const = +2
		-- resultado: subi $2,$1,const
		wait for 100 ns;
		sel_reg_a <= "010"; -- $2
		sel_reg_b <= "001"; -- $1
		sel_reg_wr <= "010"; -- $2
		sel_op_alu <= "0000"; -- Somar
		sel_imed_b <= '0'; -- não usar constante
		wr_en <= '1'; -- Habilitar escrita e operador
		input_const <= "0000000000000000"; -- const = +0
		-- resultado: add $2,$2,$1
		wait for 100 ns;
		sel_reg_a <= "001"; -- $1
		sel_reg_b <= "000"; -- $zero
		sel_reg_wr <= "101"; -- $5
		sel_op_alu <= "1001"; -- OR
		sel_imed_b <= '1'; -- usar constante
		wr_en <= '0'; -- não Habilitar escrita e operador
		input_const <= "0000000000001000"; -- const = +8
		-- resultado: andi $5,$1,const
		wait;
	end process;
end architecture;