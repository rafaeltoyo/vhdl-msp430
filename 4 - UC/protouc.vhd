library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- para usarmos UNSIGNED
entity protouc is
	port(
		data_in	: in  unsigned(6 downto 0);
		data_out: out unsigned(6 downto 0)
	);
end entity;
architecture a_protouc of protouc is
begin 
	data_out <= data_in + 1;
end architecture;
				