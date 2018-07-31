library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity processador is
	port(
		clk, rst		: in std_logic;
		debug_estado	: out unsigned(1 downto 0);
		debug_pc		: out unsigned(15 downto 0);
		debug_instr		: out unsigned(16 downto 0);
		debug_reg_a		: out unsigned(15 downto 0);
		debug_reg_b		: out unsigned(15 downto 0);
		debug_ula		: out unsigned(15 downto 0)
	);
end entity;

architecture a_processador of processador is
	component pr_instruction_fetch
	port(
		clk 		: in  std_logic;				-- Clock
		rst 		: in  std_logic;				-- Reset
		enable 		: in  std_logic;				-- Enable da etapa de fetch
		addr_pc_in	: in  unsigned(15 downto 0);	-- Entrada dos dados salvos no PC/R0
		data_mr_out	: out unsigned(16 downto 0);	-- Saida da instr. no endereco do PC/R0
		const_mr_out: out unsigned(16 downto 0)		-- Saida da instr. seguinte (PC+1) que possivelmente podera ser uma constante
	);
	end component;
	
	component pr_instruction_decode
	port(
		clk 		: in  std_logic;				-- Clock
		rst 		: in  std_logic;				-- Reset
		enable 		: in  std_logic;				-- Enable da etapa de decode
		instr_in	: in  unsigned(16 downto 0);	-- Entrada da instr. atual
		const_in	: in  unsigned(16 downto 0);	-- Entrada da possivel constante
		sel_reg_dst	: out unsigned(3 downto 0);		-- Saida do seletor do reg DST
		addr_dst	: out std_logic;				-- Saida do modo de enderecamento do reg DST
		sel_reg_src	: out unsigned(3 downto 0);		-- Saida do seletor do reg SRC
		addr_src	: out unsigned(1 downto 0);		-- Saida do modo de enderecamento do reg SRC ou reg DST em operacoes de unico reg
		offset_out	: out unsigned(9 downto 0);		-- Saida de possivel offset para um jump
		const_out	: out unsigned(15 downto 0)		-- Saida da possivel constante
	);
	end component;
	
	component reg_bank
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
	end component;
	
	component pr_execute
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
	end component;
	
	component control_unit
	port(
		clk, rst, enable	: in  std_logic;
		instr				: in  unsigned(16 downto 0);
		enable_out_fetch	: out std_logic;
		enable_out_decode	: out std_logic;
		enable_out_write_reg: out std_logic;
		enable_out_write_pc	: out std_logic;
		enable_out_execute	: out std_logic;
		sel_out_alu_op		: out unsigned(3 downto 0);
		sel_mux_b			: out std_logic;
		sel_mux_pc_add		: out unsigned(1 downto 0);
		debug_estado		: out unsigned(1 downto 0)
	);
	end component;
	
	-- Flags da UC de enable
	signal enable_out_fetch, enable_out_decode, enable_out_write_reg, enable_out_write_pc, enable_out_execute : std_logic;
	-- Sinal do PC do R0 ate o PC do instr_fetch
	signal addr_pc_s : unsigned(15 downto 0);
	-- Saidas da ROM
	signal instr_mr_s, const_mr_s : unsigned(16 downto 0);
	-- Seletores de registrador A(dst/reg) e B(src)
	signal sel_reg_a_s, sel_reg_b_s : unsigned(3 downto 0);
	-- Offset do jump
	signal data_offset_s : unsigned(9 downto 0);
	-- Constante carregada
	signal data_const_s : unsigned(15 downto 0);
	-- Saida dos registradores A e B
	signal data_reg_a_s, data_reg_b_s : unsigned(15 downto 0);
	-- Seletor da operacao da ULA
	signal sel_op_alu_s : unsigned(3 downto 0);
	-- Seletor MUX da entrada B da ULA
	signal sel_mux_b_s : std_logic;
	-- Seletor tipo de incremento do PC
	signal sel_pc_incr_s : unsigned(1 downto 0);
	-- Resultado do Calculo do PC e da ULA
	signal result_pc_s, result_ula_s : unsigned(15 downto 0);
	-- Enable da maquina de estado
	signal enable_uc : std_logic;
	-- Estado
	signal estado_s : unsigned(1 downto 0);
begin
	instr_fetch : pr_instruction_fetch port map (
			clk => clk, rst => rst,
			enable => enable_out_fetch,
			addr_pc_in => addr_pc_s,
			data_mr_out	=> instr_mr_s,
			const_mr_out => const_mr_s
		);
	
	instr_decode : pr_instruction_decode port map (
			clk => clk, rst => rst,
			enable => enable_out_decode,
			instr_in => instr_mr_s,
			const_in => const_mr_s,
			sel_reg_dst	=> sel_reg_a_s,
			sel_reg_src	=> sel_reg_b_s,
			offset_out => data_offset_s,
			const_out => data_const_s
		);
		
	memory_read : reg_bank port map (
			clk => clk, rst => rst,
			wr_en => enable_out_write_reg,
			wr_pc => enable_out_write_pc,
			sel_reg_a => sel_reg_a_s,
			sel_reg_b => sel_reg_b_s,
			wr_back_data => result_ula_s,
			wr_back_pc => result_pc_s,
			out_reg_a => data_reg_a_s,
			out_reg_b => data_reg_b_s,
			out_reg_pc => addr_pc_s
		);
	
	execute : pr_execute port map (
			sel_op_alu => sel_op_alu_s,
			sel_b_in => sel_mux_b_s,
			sel_pc_add => sel_pc_incr_s,
			data_a_in => data_reg_a_s,
			data_b_in => data_reg_b_s,
			offset_in => data_offset_s,
			data_cst_in => data_const_s,
			addr_pc_in => addr_pc_s,
			new_pc_out => result_pc_s,
			ula_data_out => result_ula_s
		);
		
	uc : control_unit port map (
			clk => clk, rst => rst,
			enable => enable_uc,
			instr => instr_mr_s,
			enable_out_fetch => enable_out_fetch,
			enable_out_decode => enable_out_decode,
			enable_out_write_reg => enable_out_write_reg,
			enable_out_write_pc => enable_out_write_pc,
			enable_out_execute => enable_out_execute,
			sel_out_alu_op => sel_op_alu_s,
			sel_mux_b => sel_mux_b_s,
			sel_mux_pc_add => sel_pc_incr_s,
			debug_estado => estado_s
		);
	
	enable_uc <= '1';
	
	-- Pinos de debug
	debug_estado	<= estado_s;
	debug_pc		<= addr_pc_s;
	debug_instr		<= instr_mr_s;
	debug_reg_a		<= data_reg_a_s;
	debug_reg_b		<= data_reg_b_s;
	debug_ula		<= result_ula_s;
end architecture;
