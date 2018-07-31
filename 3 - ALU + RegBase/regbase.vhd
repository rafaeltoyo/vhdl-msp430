library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- para usarmos UNSIGNED
entity regbase is
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
end entity;

architecture a_regbase of regbase is
	component reg16bits
	port( 	clk, rst, wr_en : in  std_logic;
			data_in	: in  unsigned(15 downto 0);
			data_out: out unsigned(15 downto 0)
			);
	end component;
	signal wr0,wr1,wr2,wr3,wr4,wr5,wr6,wr7 : std_logic;
	signal ot0,ot1,ot2,ot3,ot4,ot5,ot6,ot7 : unsigned(15 downto 0);
begin
	-- Definicao dos registradores
	reg000: reg16bits port map (clk => clk, rst => rst, wr_en => wr0, -- Registrador $zero
								data_in => write_data, data_out => ot0);
	reg001: reg16bits port map (clk => clk, rst => rst, wr_en => wr1, -- Registrador $1
								data_in => write_data, data_out => ot1);
	reg010: reg16bits port map (clk => clk, rst => rst, wr_en => wr2, -- Registrador $2
								data_in => write_data, data_out => ot2);
	reg011: reg16bits port map (clk => clk, rst => rst, wr_en => wr3, -- Registrador $3
								data_in => write_data, data_out => ot3);
	reg100: reg16bits port map (clk => clk, rst => rst, wr_en => wr4, -- Registrador $4
								data_in => write_data, data_out => ot4);
	reg101: reg16bits port map (clk => clk, rst => rst, wr_en => wr5, -- Registrador $5
								data_in => write_data, data_out => ot5);
	reg110: reg16bits port map (clk => clk, rst => rst, wr_en => wr6, -- Registrador $6
								data_in => write_data, data_out => ot6);
	reg111: reg16bits port map (clk => clk, rst => rst, wr_en => wr7, -- Registrador $7
								data_in => write_data, data_out => ot7);
	-- Configurar o registrador de escrita
	wr0 <= '0'; -- Nunca escrever
	wr1 <= '1' when sel_write = "001" and wr_en = '1' else '0';
	wr2 <= '1' when sel_write = "010" and wr_en = '1' else '0';
	wr3 <= '1' when sel_write = "011" and wr_en = '1' else '0';
	wr4 <= '1' when sel_write = "100" and wr_en = '1' else '0';
	wr5 <= '1' when sel_write = "101" and wr_en = '1' else '0';
	wr6 <= '1' when sel_write = "110" and wr_en = '1' else '0';
	wr7 <= '1' when sel_write = "111" and wr_en = '1' else '0';
	-- Definir saida de dados
	-- Registrador A
	out_reg_a <= 	ot0 when sel_reg_a = "000" else
					ot1 when sel_reg_a = "001" else
					ot2 when sel_reg_a = "010" else
					ot3 when sel_reg_a = "011" else
					ot4 when sel_reg_a = "100" else
					ot5 when sel_reg_a = "101" else
					ot6 when sel_reg_a = "110" else
					ot7 when sel_reg_a = "111" else
					"0000000000000000";
	-- Registrador B
	out_reg_b <= 	ot0 when sel_reg_b = "000" else
					ot1 when sel_reg_b = "001" else
					ot2 when sel_reg_b = "010" else
					ot3 when sel_reg_b = "011" else
					ot4 when sel_reg_b = "100" else
					ot5 when sel_reg_b = "101" else
					ot6 when sel_reg_b = "110" else
					ot7 when sel_reg_b = "111" else
					"0000000000000000";
end architecture;
				