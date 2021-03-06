library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- para usarmos UNSIGNED
entity reg_instr is
	port( 	clk		: in  std_logic; 				-- Entrada do sinal de clock
			rst		: in  std_logic; 				-- Entrada para indicar reset
			wr_en	: in  std_logic; 				-- ENtrada para habilitar escrita (permite clock)
			data_in	: in  unsigned(16 downto 0);	-- Entrada de dados
			data_out: out unsigned(16 downto 0)		-- Saida de dados
			);
end entity;
architecture a_reg_instr of reg_instr is
	signal reg_data : unsigned(16 downto 0);
begin 
	process(clk,rst,wr_en) -- Acionar se houver modificacoes nessas entradas
	begin
		if rst = '1' then -- Resetar o registrador
			reg_data <= "00000000000000000";
		elsif wr_en = '1' then -- Se tiver leitura habilitada ...
			if rising_edge(clk) then -- ... e uma borda de subida ...
				reg_data <= data_in; -- ... e guarda o valor de entradas
			end if;
		end if;
	end process;
	
	data_out <= reg_data;
end architecture;
				