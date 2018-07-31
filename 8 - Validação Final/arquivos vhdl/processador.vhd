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
		addr_src	: out std_logic;				-- Saida do modo de enderecamento do reg SRC ou reg DST em operacoes de unico reg
		offset_out	: out unsigned(9 downto 0);		-- Saida de possivel offset para um jump
		const_out	: out unsigned(15 downto 0)		-- Saida da possivel constante
	);
	end component;
	
	component pr_memory
	port(
		clk 		: in  std_logic;				-- Clock
		rst 		: in  std_logic;				-- Reset
		wr_en_pc	: in  std_logic;				-- Habilitar escrita do PC
		wr_en_main	: in  std_logic;				-- Habilitar escrita em registradores
		wr_en_ram	: in  std_logic;				-- Habilitar escrita na RAM
		sel_reg_a	: in  unsigned(3 downto 0);		-- Seletor Registrador A
		sel_type_a	: in  std_logic;				-- Modo de enderecamento do registrador A
		output_a	: out unsigned(15 downto 0);	-- Saida de dado A
		sel_reg_b	: in  unsigned(3 downto 0);		-- Seletor Registrador B
		sel_type_b	: in  std_logic; 				-- Modo de enderecamento do registrador B
		output_b	: out unsigned(15 downto 0);	-- Saida de dado B
		wr_back_pc	: in  unsigned(15 downto 0);	-- Entrada de escrita do PC	
		output_pc	: out unsigned(15 downto 0);	-- Saida de dado do PC
		wr_back_data : in unsigned(15 downto 0)		-- Entrada de escrita de registrador ou RAM
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
		ula_data_out: out unsigned(15 downto 0);	-- Saida da ULA para o write back
		state_out	: out unsigned(15 downto 0)		-- Saida de flags da ULA de regs
	);
	end component;
	
	component control_unit
	port(
		clk, rst, enable	: in  std_logic;
		instr				: in  unsigned(16 downto 0);
		reg_state_in		: in  unsigned(15 downto 0);
		enable_out_fetch	: out std_logic;
		enable_out_decode	: out std_logic;
		enable_out_write_reg: out std_logic;
		enable_out_write_pc	: out std_logic;
		enable_out_write_ram: out std_logic;
		enable_out_execute	: out std_logic;
		sel_out_alu_op		: out unsigned(3 downto 0);
		sel_mux_b			: out std_logic;
		sel_mux_pc_add		: out unsigned(1 downto 0);
		debug_estado		: out unsigned(1 downto 0)
	);
	end component;
	
	component reg_base
	port( 	
		clk		: in  std_logic; 				-- Entrada do sinal de clock
		rst		: in  std_logic; 				-- Entrada para indicar reset
		wr_en	: in  std_logic; 				-- ENtrada para habilitar escrita (permite clock)
		data_in	: in  unsigned(15 downto 0);	-- Entrada de dados
		data_out: out unsigned(15 downto 0)		-- Saida de dados
	);
	end component;
	
	-- Flags da UC de enable
	signal enable_out_fetch, enable_out_decode, enable_out_write_reg, enable_out_write_pc, enable_out_write_ram, enable_out_execute : std_logic;
	-- Enable do reg State
	signal enable_out_state : std_logic;
	-- Sinal do PC do R0 ate o PC do instr_fetch
	signal addr_pc_s : unsigned(15 downto 0);
	-- Saidas da ROM
	signal instr_mr_s, const_mr_s : unsigned(16 downto 0);
	-- Seletores de registrador A(dst/reg) e B(src)
	signal sel_reg_a_s, sel_reg_b_s : unsigned(3 downto 0);
	-- Enderecamento dos registradores A(dst/reg) e B(src)
	signal addr_mode_a_s, addr_mode_b_s : std_logic;
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
	-- Saida de flags da ULA
	signal data_state_ula_s : unsigned(15 downto 0);
	-- Saida de flags do Reg_State
	signal data_state_reg_s : unsigned(15 downto 0);
	
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
			addr_dst => addr_mode_a_s,
			sel_reg_src	=> sel_reg_b_s,
			addr_src => addr_mode_b_s,
			offset_out => data_offset_s,
			const_out => data_const_s
		);
		
	memory_read : pr_memory port map (
			clk => clk, rst => rst,
			wr_en_pc => enable_out_write_pc,
			wr_en_main => enable_out_write_reg,
			wr_en_ram => enable_out_write_ram,
			sel_reg_a => sel_reg_a_s,
			sel_type_a => addr_mode_a_s,
			output_a => data_reg_a_s,
			sel_reg_b => sel_reg_b_s,
			sel_type_b => addr_mode_b_s,
			output_b => data_reg_b_s,
			wr_back_pc => result_pc_s,
			output_pc => addr_pc_s,
			wr_back_data => result_ula_s
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
			ula_data_out => result_ula_s,
			state_out => data_state_ula_s
		);
		
	uc : control_unit port map (
			clk => clk, rst => rst,
			enable => enable_uc,
			instr => instr_mr_s,
			reg_state_in => data_state_reg_s,
			enable_out_fetch => enable_out_fetch,
			enable_out_decode => enable_out_decode,
			enable_out_write_reg => enable_out_write_reg,
			enable_out_write_pc => enable_out_write_pc,
			enable_out_write_ram => enable_out_write_ram,
			enable_out_execute => enable_out_execute,
			sel_out_alu_op => sel_op_alu_s,
			sel_mux_b => sel_mux_b_s,
			sel_mux_pc_add => sel_pc_incr_s,
			debug_estado => estado_s
		);
	
	reg_state : reg_base port map (
			clk => clk, rst => rst,
			wr_en => enable_out_state,
			data_in => data_state_ula_s,
			data_out => data_state_reg_s
		);
	
	enable_uc <= '1';
	
	enable_out_state <= '1' when enable_out_write_ram = '1' or enable_out_write_reg = '1' else
						'0';
	
	-- Pinos de debug
	debug_estado	<= estado_s;
	debug_pc		<= addr_pc_s;
	debug_instr		<= instr_mr_s;
	debug_reg_a		<= data_reg_a_s;
	debug_reg_b		<= data_reg_b_s;
	debug_ula		<= result_ula_s;
end architecture;
