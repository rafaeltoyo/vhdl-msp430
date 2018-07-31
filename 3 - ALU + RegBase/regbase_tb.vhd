library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- para usarmos UNSIGNED
entity regbase_tb is
end;
architecture a_regbase_tb of regbase_tb is
	component regbase
	port( 	sel_reg_a 	: in  unsigned(2 downto 0);
			sel_reg_b	: in  unsigned(2 downto 0);
			write_data	: in  unsigned(15 downto 0);
			sel_write	: in  unsigned(2 downto 0);
			clk			: in  std_logic;
			rst			: in  std_logic;
			wr_en		: in  std_logic;
			out_reg_a	: out unsigned(15 downto 0);
			out_reg_b	: out unsigned(15 downto 0)
			);
	end component;
signal clk, rst, wr_en : std_logic;
signal write_data, out_reg_a, out_reg_b	: unsigned(15 downto 0);
signal sel_reg_a, sel_reg_b, sel_write : unsigned(2 downto 0);
begin
	uut: regbase port map(	sel_reg_a => sel_reg_a,
							sel_reg_b => sel_reg_b,
							write_data => write_data,
							sel_write => sel_write,
							clk => clk,
							rst => rst,
							wr_en => wr_en,
							out_reg_a => out_reg_a,
							out_reg_b => out_reg_b
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
	
	process -- Sinal de dados ( comecar depois de 100 ns do reset )
	begin
		wait for 100 ns;
		sel_reg_a <= "000";
		sel_reg_b <= "111";
		write_data <= "0000000000000000";
		sel_write <= "000";
		wr_en <= '0';
		wait for 100 ns;
		sel_reg_a <= "000";
		sel_reg_b <= "010";
		write_data <= "1010101010101010";
		sel_write <= "010";
		wr_en <= '1';
		wait for 100 ns;
		sel_reg_a <= "010";
		wr_en <= '0';
		wait for 100 ns;
		sel_reg_a <= "100";
		sel_reg_b <= "010";
		write_data <= "1100110011001100";
		sel_write <= "100";
		wr_en <= '1';
		wait for 100 ns;
		sel_reg_a <= "100";
		sel_reg_b <= "010";
		write_data <= "1111111111111111";
		sel_write <= "000";
		wr_en <= '1';
		wait for 100 ns;
		sel_reg_a <= "000";
		wr_en <= '0';
		wait;
	end process;
end architecture;