library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- para usarmos UNSIGNED
entity tff_1bit is
	port( 	
		clk		: in  std_logic; 	-- Entrada do sinal de clock
		rst		: in  std_logic;	-- Entrada para indicar reset
		wr_en	: in  std_logic;	-- Entrada para habilitar escrita (permite clock)
		data_in	: in  std_logic;	-- Entrada de dados
		data_out: out std_logic		-- Saida de dados
	);
end entity;
architecture a_tff_1bit of tff_1bit is
	signal tff_data : std_logic;
begin
	process(clk,rst,wr_en) -- Acionar se houver modificacoes nessas entradas
	begin
		if rst = '1' then -- Resetar o registrador
			tff_data <= '0';
		elsif wr_en = '1' and data_in = '1' then -- Se tiver leitura habilitada ...
			if rising_edge(clk) then -- ... e uma borda de subida ...
				tff_data <= not tff_data;
			end if;
		end if;
	end process;
	data_out <= tff_data;
end architecture;
				