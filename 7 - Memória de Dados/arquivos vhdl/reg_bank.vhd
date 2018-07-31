library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- para usarmos UNSIGNED
entity reg_bank is
	port( 	
		clk			: in  std_logic;				-- Clock geral
		rst			: in  std_logic;				-- Reset geral
		wr_en		: in  std_logic;				-- Habilitar escrita geral
		wr_pc		: in  std_logic;				-- Habilitar escrita do PC
		sel_reg_a 	: in  unsigned(3 downto 0);		-- Seletor do registrador A / Registrador de escrita
		sel_reg_b	: in  unsigned(3 downto 0);		-- Seletor do registrador B
		wr_back_data: in  unsigned(15 downto 0);	-- Dado de entrada do Write back para escrita
		wr_back_pc	: in  unsigned(15 downto 0);	-- Dado de entrada do PC para escrita
		out_reg_a	: out unsigned(15 downto 0);	-- Saida do registrador A
		out_reg_b	: out unsigned(15 downto 0);	-- Saida do registrador B
		out_reg_pc	: out unsigned(15 downto 0)		-- Saida do PC
	);
end entity;

architecture a_reg_bank of reg_bank is
	component reg_base
	port( 	clk, rst, wr_en : in  std_logic;
			data_in	: in  unsigned(15 downto 0);
			data_out: out unsigned(15 downto 0)
			);
	end component;
	signal wr0,wr1,wr2,wr3,wr4,wr5,wr6,wr7,wr8,wr9,wr10,wr11,wr12,wr13,wr14,wr15 : std_logic;
	signal inpc, ot0,ot1,ot2,ot3,ot4,ot5,ot6,ot7,ot8,ot9,ot10,ot11,ot12,ot13,ot14,ot15 : unsigned(15 downto 0);
begin
	-- Definicao dos registradores
	reg0000: reg_base port map (clk => clk, rst => rst, wr_en => wr0, -- Registrador $pc
								data_in => inpc, data_out => ot0);
	reg0001: reg_base port map (clk => clk, rst => rst, wr_en => wr1, -- Registrador $1
								data_in => wr_back_data, data_out => ot1);
	reg0010: reg_base port map (clk => clk, rst => rst, wr_en => wr2, -- Registrador $2
								data_in => wr_back_data, data_out => ot2);
	reg0011: reg_base port map (clk => clk, rst => rst, wr_en => wr3, -- Registrador $3
								data_in => wr_back_data, data_out => ot3);
	reg0100: reg_base port map (clk => clk, rst => rst, wr_en => wr4, -- Registrador $4
								data_in => wr_back_data, data_out => ot4);
	reg0101: reg_base port map (clk => clk, rst => rst, wr_en => wr5, -- Registrador $5
								data_in => wr_back_data, data_out => ot5);
	reg0110: reg_base port map (clk => clk, rst => rst, wr_en => wr6, -- Registrador $6
								data_in => wr_back_data, data_out => ot6);
	reg0111: reg_base port map (clk => clk, rst => rst, wr_en => wr7, -- Registrador $7
								data_in => wr_back_data, data_out => ot7);
	reg1000: reg_base port map (clk => clk, rst => rst, wr_en => wr8, -- Registrador $zero
								data_in => wr_back_data, data_out => ot8);
	reg1001: reg_base port map (clk => clk, rst => rst, wr_en => wr9, -- Registrador $1
								data_in => wr_back_data, data_out => ot9);
	reg1010: reg_base port map (clk => clk, rst => rst, wr_en => wr10, -- Registrador $2
								data_in => wr_back_data, data_out => ot10);
	reg1011: reg_base port map (clk => clk, rst => rst, wr_en => wr11, -- Registrador $3
								data_in => wr_back_data, data_out => ot11);
	reg1100: reg_base port map (clk => clk, rst => rst, wr_en => wr12, -- Registrador $4
								data_in => wr_back_data, data_out => ot12);
	reg1101: reg_base port map (clk => clk, rst => rst, wr_en => wr13, -- Registrador $5
								data_in => wr_back_data, data_out => ot13);
	reg1110: reg_base port map (clk => clk, rst => rst, wr_en => wr14, -- Registrador $6
								data_in => wr_back_data, data_out => ot14);
	reg1111: reg_base port map (clk => clk, rst => rst, wr_en => wr15, -- Registrador $7
								data_in => wr_back_data, data_out => ot15);
	
	-- Entrada do PC/R0 - PRIORIDADE EH O RESULTADO DA ULA e depois a atualizacao automatica do PC
	inpc <= wr_back_data when sel_reg_a = "0000" and wr_en = '1' else
			wr_back_pc when wr_pc = '1' else
			"0000000000000000";
	
	-- Saida fixa dos dados do PC/R0
	out_reg_pc <= ot0;
	
	-- Configurar o registrador de escrita
	wr0 <= '1' when (sel_reg_a = "0000" and wr_en = '1') or wr_pc = '1' else '0';
	wr1 <= '1' when sel_reg_a = "0001" and wr_en = '1' else '0';
	wr2 <= '1' when sel_reg_a = "0010" and wr_en = '1' else '0';
	wr3 <= '1' when sel_reg_a = "0011" and wr_en = '1' else '0';
	wr4 <= '1' when sel_reg_a = "0100" and wr_en = '1' else '0';
	wr5 <= '1' when sel_reg_a = "0101" and wr_en = '1' else '0';
	wr6 <= '1' when sel_reg_a = "0110" and wr_en = '1' else '0';
	wr7 <= '1' when sel_reg_a = "0111" and wr_en = '1' else '0';
	wr8 <= '1' when sel_reg_a = "1000" and wr_en = '1' else '0';
	wr9 <= '1' when sel_reg_a = "1001" and wr_en = '1' else '0';
	wr10 <= '1' when sel_reg_a = "1010" and wr_en = '1' else '0';
	wr11 <= '1' when sel_reg_a = "1011" and wr_en = '1' else '0';
	wr12 <= '1' when sel_reg_a = "1100" and wr_en = '1' else '0';
	wr13 <= '1' when sel_reg_a = "1101" and wr_en = '1' else '0';
	wr14 <= '1' when sel_reg_a = "1110" and wr_en = '1' else '0';
	wr15 <= '1' when sel_reg_a = "1111" and wr_en = '1' else '0';
	-- Definir saida de dados
	-- Registrador A
	out_reg_a <= 	ot0 when sel_reg_a = "0000" else
					ot1 when sel_reg_a = "0001" else
					ot2 when sel_reg_a = "0010" else
					ot3 when sel_reg_a = "0011" else
					ot4 when sel_reg_a = "0100" else
					ot5 when sel_reg_a = "0101" else
					ot6 when sel_reg_a = "0110" else
					ot7 when sel_reg_a = "0111" else
					ot8 when sel_reg_a = "0000" else
					ot9 when sel_reg_a = "0001" else
					ot10 when sel_reg_a = "1010" else
					ot11 when sel_reg_a = "1011" else
					ot12 when sel_reg_a = "1100" else
					ot13 when sel_reg_a = "1101" else
					ot14 when sel_reg_a = "1110" else
					ot15 when sel_reg_a = "1111" else
					"0000000000000000";
	-- Registrador B
	out_reg_b <= 	ot0 when sel_reg_b = "0000" else
					ot1 when sel_reg_b = "0001" else
					ot2 when sel_reg_b = "0010" else
					ot3 when sel_reg_b = "0011" else
					ot4 when sel_reg_b = "0100" else
					ot5 when sel_reg_b = "0101" else
					ot6 when sel_reg_b = "0110" else
					ot7 when sel_reg_b = "0111" else
					ot8 when sel_reg_b = "1000" else
					ot9 when sel_reg_b = "1001" else
					ot10 when sel_reg_b = "1010" else
					ot11 when sel_reg_b = "1011" else
					ot12 when sel_reg_b = "1100" else
					ot13 when sel_reg_b = "1101" else
					ot14 when sel_reg_b = "1110" else
					ot15 when sel_reg_b = "1111" else
					"0000000000000000";
end architecture;
				
