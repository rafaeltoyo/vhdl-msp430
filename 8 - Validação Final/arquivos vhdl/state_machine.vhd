library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity state_machine is
	port(
		clk,rst,enb: in std_logic;
		state_out: out unsigned(1 downto 0)
	);
end entity;
--00 fetch
--01 decode
--10 memory/execute/write back
architecture a_state_machine of state_machine is
	signal state_out_s: unsigned(1 downto 0);
begin
	process(clk,rst)
	begin
		if rst='1' then
			state_out_s <= "00"; 
		elsif enb = '1' then
			if rising_edge(clk) then
				if state_out_s="10" then -- se agora esta em 2
					state_out_s <= "00"; -- o prox vai voltar ao zero
				else
					state_out_s <= state_out_s+1; -- senao avanca
				end if;
			end if;
		end if;
	end process;
	state_out <= state_out_s;
end architecture;
