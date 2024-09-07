library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pipeline is
	port(clk_main, rst_main : in std_logic;
			output : out std_logic
		  );
end entity pipeline;

architecture final of pipeline is
	
	component fetch is
		port(branch_id, branch_rr : in std_logic;
			  pc_in, pc_branch_id,pc_branch_rr : in std_logic_vector(15 downto 0);
			  
			  ir, pc_out,pc_next : out std_logic_vector(15 downto 0)
			  );
	end component fetch;
	
	component decode is
		port( his_out : in std_logic;
			  ir,pc_init, pc_plus2: in std_logic_vector(15 downto 0);
			  
			  pc_out, pc_branched : out std_logic_vector(15 downto 0);
			  ra_add, rb_add, rc_add : out std_logic_vector(2 downto 0);
			  opcode : out std_logic_vector(3 downto 0);
			  con : out std_logic_vector(1 downto 0);
			  com : out std_logic;
			  imm16 : out std_logic_vector(15 downto 0);
			  reg_read, reg_wr, mem_rd, mem_wr, brch, jmp, r0_up, r1_up, r2_up, r3_up, r4_up, r5_up, r6_up, r7_up: out std_logic);
			  
	end component decode;
	
	component read_op is
		port(
			  fwd1, fwd2: in std_logic; 
			  fwd_reg1, fwd_reg2, pc_store, pc_init: in std_logic_vector(15 downto 0); 
			  ra_temp, rb_temp : in std_logic_vector(15 downto 0);
			  opcode_in : in std_logic_vector(3 downto 0);
			  did_branch: in std_logic;
			  imm16: in std_logic_vector(15 downto 0);
			  
			  brch, hisbit_update, hzrd : out std_logic;
			  ra_out, rb_out : out std_logic_vector(15 downto 0);
			  pc_branch: out std_logic_vector(15 downto 0)
			  
			  );
			  
	end component read_op;
	
	component execute is
		port(
			  ra_in, rb_in, imm : in std_logic_vector(15 downto 0);
			  opcode : in std_logic_vector(3 downto 0);
			  cond : in std_logic_vector(1 downto 0);
			  comp, cin : in std_logic;
			  r0_in, r1_in, r2_in, r3_in, r4_in, r5_in, r6_in, r7_in: in std_logic;
			  data : out std_logic_vector(15 downto 0);
			  carry, z, ld_flag, lm_sm_flag : out std_logic
			  
			  );
			  
	end component execute;
	
	component memory is
	port(
		  opcode : in std_logic_vector(3 downto 0);
		  ra_data, rc_data, rb_data: in std_logic_vector(15 downto 0);
		  
		  mem_data_add, mem_data_in : out std_logic_vector(15 downto 0)
		  
		  );
		  
	end component memory;
	
	component writeback is
		port(carry, zflag, reg_wr: in std_logic;
			  cond : in std_logic_vector(1 downto 0);
			  opcode : in std_logic_vector(3 downto 0);
			  rc_data, mem_data, imm16, pc_in : in std_logic_vector(15 downto 0);
			  
			  rf_update: out std_logic_vector(15 downto 0);
			  rf_flag : out std_logic
			  
			  );
			  
	end component writeback;
	
	component regfile is 
		 port(
			  --to store the register number for each address
			  RF_A1 : in std_logic_vector(2 downto 0);
			  RF_A2 : in std_logic_vector(2 downto 0);
			  RF_A3 : in std_logic_vector(2 downto 0);
			  RF_A4 : in std_logic_vector(2 downto 0);
			  RF_A5 : in std_logic_vector(2 downto 0);
			  RF_D4 : in std_logic_vector(15 downto 0);
			  RF_D5 : in std_logic_vector(15 downto 0);
			  reset : in std_logic;
			  clk : in std_logic;
			  writevalue : in std_logic;
			  writePC: in std_logic;
			  D1o : out std_logic_vector(15 downto 0);
			  D2o : out std_logic_vector(15 downto 0);
			  PC : out std_logic_vector(15 downto 0)

		 );
	end component regfile;
	
	component reg_dec is
	port( ra_add, rb_add, rc_add: in std_logic_vector(2 downto 0);
			r0_flag, r1_flag, r2_flag, r3_flag, r4_flag, r5_flag, r6_flag, r7_flag: in std_logic;
			opcode_in: std_logic_vector(3 downto 0);
						
			--r0_flag_out, r1_flag_out, r2_flag_out, r3_flag_out, r4_flag_out, r5_flag_out, r6_flag_out, r7_flag_out: out std_logic;
			r0_update, r1_update, r2_update, r3_update, r4_update, r5_update, r6_update, r7_update : out std_logic;
			ra_fin, rb_fin, rc_fin: out std_logic_vector(2 downto 0)
		);
	end component reg_dec;
	
	component single_bit_reg is
		port (d : IN STD_LOGIC;
					wr_en : IN STD_LOGIC;
					clr : IN STD_LOGIC;
					clk : IN STD_LOGIC;

					q : OUT STD_LOGIC);
	end component single_bit_reg;
	
	component ram is
		 port (
			  clk : in std_logic;
			  write_enable : in std_logic;
			  reset : in std_logic;
			  mem_address : in std_logic_vector(15 downto 0);
			  mem_data_in : in std_logic_vector(15 downto 0);
			  mem_data_out : out std_logic_vector(15 downto 0)
		 );
	end component;
	
	component stage12 is
		port(clk, reset, wr_en, flush :in std_logic;
			  ir_in, pc_in1, pc_in2 :in std_logic_vector(15 downto 0);
			  
			  ir_out, pc_out1, pc_out2 :out std_logic_vector(15 downto 0));
	end component stage12;
	
	component stage23 is
		port(clk, reset, wr_en, flush, brch_in, r0_updt, r1_updt, r2_updt, r3_updt, r4_updt, r5_updt, r6_updt, r7_updt : in std_logic;
			  brch_out : out std_logic;
				 pc_in : in std_logic_vector(15 downto 0);
				 pc_store : in std_logic_vector(15 downto 0);
				 opcode : in std_logic_vector(3 downto 0);
				 ra_add, rb_add, rc_add : in std_logic_vector(2 downto 0);
				 imm16 : in std_logic_vector(15 downto 0);
				 cond: in std_logic_vector(1 downto 0);
				 comp, r0_in, r1_in, r2_in, r3_in, r4_in, r5_in, r6_in, r7_in, reg_wr, mem_rd, mem_wr : in std_logic;

				 pc_out, pc_store_out : out std_logic_vector(15 downto 0);
				 opcode_out : out std_logic_vector(3 downto 0);
				 ra_add_out, rb_add_out, rc_add_out : out std_logic_vector(2 downto 0);
				 imm16_out : out std_logic_vector(15 downto 0);
				 cond_out : out std_logic_vector(1 downto 0);
				 comp_out, r0_out, r1_out, r2_out, r3_out, r4_out, r5_out, r6_out, r7_out, reg_wr_out, mem_rd_out, mem_wr_out : out std_logic

			  );
			  
	end component stage23;
	
	component stage34 is
		port(clk, reset, wr_en, flush: in std_logic;
			  ra_in, rb_in, data_alu : in std_logic_vector(15 downto 0);
				 rc_add_in : in std_logic_vector(2 downto 0);
				 cond : in std_logic_vector(1 downto 0);
				 comp : in std_logic;
				 imm16, pc_in : in std_logic_vector(15 downto 0);
				 mem_rd_in, mem_wr_in, reg_wr_in : in std_logic;
				 opcode : in std_logic_vector(3 downto 0);
				 r0_flag, r1_flag, r2_flag, r3_flag, r4_flag, r5_flag, r6_flag, r7_flag, lm_flag: in std_logic;
				 
				 r0_flag_out, r1_flag_out, r2_flag_out, r3_flag_out, r4_flag_out, r5_flag_out, r6_flag_out, r7_flag_out: out std_logic;
				 mem_rd_out, mem_wr_out, reg_wr_out : out std_logic;
				 opcode_out : out std_logic_vector(3 downto 0);
				 ra_out, rb_out : out std_logic_vector(15 downto 0);
				 rc_add_out : out std_logic_vector(2 downto 0);
				 cond_out : out std_logic_vector(1 downto 0);
				 comp_out : out std_logic;
				 imm16_out, pc_out: out std_logic_vector(15 downto 0)
			  );
			  
	end component stage34;
	
	component stage45 is
		port(clk, reset, wr_en, flush: in std_logic;
			  opcode : in std_logic_vector(3 downto 0);
				 rc_add : in std_logic_vector(2 downto 0);
				 ra_in, aluout1, imm16, rb_in: in std_logic_vector(15 downto 0);
				 pc_in : in std_logic_vector(15 downto 0);
				 cond_in : in std_logic_vector(1 downto 0);
				 mem_rd_in, mem_wr_in, reg_wr_in, carry_in, z_in : in std_logic;
				 
				 pc_out : out std_logic_vector(15 downto 0);
				 ra_out, alu1_out, imm16_out, rb_out: out std_logic_vector(15 downto 0);
				 opcode_out : out std_logic_vector(3 downto 0);
				 mem_rd_out, mem_wr_out, reg_wr_out, carry_out, z_out : out std_logic;
				 cond_out : out std_logic_vector(1 downto 0);
				 rc_add_out : out std_logic_vector(2 downto 0)

			  );
			  
	end component stage45;
	
	component stage56 is
		port(clk, reset, wr_en, flush : in std_logic;
			  reg_wr_in : in std_logic;
			  opcode : in std_logic_vector(3 downto 0);
			  rc_data_in, mem_data, imm16: in std_logic_vector(15 downto 0);
			  rc_add : in std_logic_vector(2 downto 0);
			  pc_in : in std_logic_vector(15 downto 0);
			  cond_in : in std_logic_vector(1 downto 0);
			  carry_in, z_in : in std_logic;

			  reg_wr_out : out std_logic;
			  opcode_out : out std_logic_vector(3 downto 0);
			  rc_data_out, mem_data_out, imm16_out: out std_logic_vector(15 downto 0);
			  rc_add_out : out std_logic_vector(2 downto 0);
			  pc_out : out std_logic_vector(15 downto 0);
			  cond_out : out std_logic_vector(1 downto 0);
			  carry_out, z_out : out std_logic

			  );
			  
	end component stage56;
	
	component forward is
		port( reg_check, ex_add, ma_add, wb_add : in std_logic_vector(2 downto 0);
				ex_reg_data1, ex_reg_data2, ma_reg_data1, ma_reg_data2, ma_reg_data3,ma_reg_data4, wb_reg_data1, wb_reg_data2, wb_reg_data3, wb_reg_data4: in std_logic_vector(15 downto 0);
				ex_opcode, ma_opcode, wb_opcode: in std_logic_vector(3 downto 0);
				
				fwd_reg_val : out std_logic_vector(15 downto 0);
				fwd_en : out std_logic
			);
	end component forward;
	
	signal nstall1, nstall2: std_logic:= '1';
	signal flush1, flush2, flush3: std_logic := '0';
	signal r0_change, r1_change, r2_change, r3_change, r4_change, r5_change, r6_change, r7_change, lm_flag : std_logic;
	---------------------historybit-----------------------------------
	signal history: std_logic := '1';
	---------------------carry-------------------------------------
	signal cout, cinit : std_logic;
	---------------------instruction fetch stage-----------------------------
	signal pc_brch_id,pc_brch_rr, pc_instr, if_instr, pc, pc_update: std_logic_vector(15 downto 0);
	signal brch_id,brch_rr: std_logic;
	----------------------if_ir pipeline-------------------------------------
	signal reg1_pc_init, reg1_pc_added, reg1_ir: std_logic_vector(15 downto 0);
	-----------------------instruction decode--------------------------------
	signal pc_temp, id_imm16 : std_logic_vector(15 downto 0);
	signal id_ra_add, id_rb_add, id_rc_add: std_logic_vector(2 downto 0);
	signal id_opcode: std_logic_vector(3 downto 0);
	signal id_cond: std_logic_vector(1 downto 0);
	signal id_comp, id_reg_wr, id_mem_rd, id_mem_wr, jump_id, id_reg_read : std_logic; 
	signal r0_lm, r1_lm, r2_lm, r3_lm, r4_lm, r5_lm, r6_lm, r7_lm: std_logic;
	---------------------------id_rr pipeline---------------------------------
	signal reg2_pc_init, reg2_pc_stored, reg2_imm16: std_logic_vector(15 downto 0);
	signal reg2_ra_add, reg2_rb_add, reg2_rc_add:std_logic_vector(2 downto 0);
	signal reg2_opcode: std_logic_vector(3 downto 0);
	signal reg2_cond: std_logic_vector(1 downto 0);
	signal reg2_comp, reg2_reg_read, reg2_reg_wr, reg2_mem_rd, reg2_mem_wr : std_logic;
	signal reg2_brch_id : std_logic:= '0';
	-----------------------register read stage------------------
	signal ra_temp1 , rb_temp1, ra_data1, rb_data2: std_logic_vector(15 downto 0);
	signal ra_add_rf, rb_add_rf, rc_add_rf : std_logic_vector(2 downto 0);
	signal hisbit_data_in, hazard : std_logic;
	signal rr_opcode: std_logic_vector(3 downto 0);
	signal rr_data1, rr_data2: std_logic_vector(15 downto 0);
	-----------------------pipeline register 3-------------------
	signal reg3_mem_wr, reg3_mem_rd, reg3_reg_wr, reg3_comp: std_logic;
	signal reg3_pc_out, reg3_imm, reg3_data1, reg3_data2 : std_logic_vector(15 downto 0);
	signal reg3_cond : std_logic_vector(1 downto 0);
	signal reg3_rc_add: std_logic_vector(2 downto 0);
	signal reg3_opcode : std_logic_vector(3 downto 0);	
	----------------------execute stage-----------------------
	signal stall_load, zout: std_logic;
	signal alu1: std_logic_vector(15 downto 0);
	----------------------pipeline register 4-------------------
	signal reg4_alu, reg4_data16: std_logic_vector(15 downto 0);
	signal reg4_mem_rd, reg4_mem_wr, reg4_reg_wr, reg4_carry, reg4_z : std_logic;
	signal reg4_pc_out : std_logic_vector(15 downto 0);
	signal reg4_cond : std_logic_vector(1 downto 0);
	signal reg4_rc_add: std_logic_vector(2 downto 0);
	signal reg4_opcode : std_logic_vector(3 downto 0);	
	---------------------memory access stage--------------------
	signal ma_data_read, datamem_add, datamem_input : std_logic_vector(15 downto 0);
	signal mem_wr_flag : std_logic;	
	----------------------pipeline register 5-------------------
	signal reg5_rc_add: std_logic_vector(2 downto 0);
	signal reg5_alu, reg5_mem_data: std_logic_vector(15 downto 0);
	signal reg5_reg_wr, reg5_carry, reg5_z : std_logic;
	signal reg5_pc_out, reg5_imm16 : std_logic_vector(15 downto 0);
	signal reg5_cond : std_logic_vector(1 downto 0);
	signal reg5_opcode : std_logic_vector(3 downto 0);	
	----------------------writeback stage----------------------	
	signal register_wr_flag, pc_wr: std_logic;
	signal wb_input, outp: std_logic_vector(15 downto 0);	
	----------------------fwd----------------------------------
	signal fwd_a: std_logic := '0';
	signal fwd_b: std_logic := '0';	
	signal fwd_val1, fwd_val2 : std_logic_vector(15 downto 0);
	------------ananya-------------------------------------------
	signal reg2_r0, reg2_r1, reg2_r2, reg2_r3, reg2_r4, reg2_r5, reg2_r6, reg2_r7 : std_logic;
	signal reg3_r0, reg3_r1, reg3_r2, reg3_r3, reg3_r4, reg3_r5, reg3_r6, reg3_r7 : std_logic;
	signal reg4_data1, reg4_data2: std_logic_vector(15 downto 0);
	begin
	
		nstall1 <= (not stall_load) or (not (r0_change or r1_change or r2_change or r3_change or r4_change or r5_change or r6_change or r7_change));
		nstall2 <= (not stall_load) or (not (r0_change or r1_change or r2_change or r3_change or r4_change or r5_change or r6_change or r7_change));
		flush3 <= not stall_load;
		flush1 <= jump_id;
		flush2 <= brch_rr;
		pc_wr <= nstall1 or (not flush1);
	
		data_memory: ram port map(clk=> clk_main, reset => rst_main, write_enable => reg4_mem_wr,
										  mem_address => datamem_add, mem_data_in => datamem_input, 
										  mem_data_out => ma_data_read
										  ); 
		
		reg  : regfile port map(clk => clk_main, reset=> rst_main, RF_A1 => ra_add_rf, RF_A2 => rb_add_rf , RF_A3 => "000", RF_A4 => reg5_rc_add, RF_A5 => "000",
										writevalue => register_wr_flag, writePC => pc_wr, RF_D4 => wb_input, RF_D5 => pc_update, 
										D1o => ra_temp1, D2o => rb_temp1, PC => pc
										);
	
		history_bit: single_bit_reg port map(clk => clk_main, clr=> rst_main, d => hisbit_data_in,wr_en => hazard, q => history);
		
		carry_bit: single_bit_reg port map(clk => clk_main, clr=> rst_main, d => cout, wr_en => '1', q => cinit);
		
		fetch1: fetch port map(branch_id => brch_id,branch_rr=> brch_rr,										--branch signal
									  pc_in => pc, pc_branch_id => pc_brch_id, pc_branch_rr => pc_brch_rr,	--3 possible PC
									  ir => if_instr, pc_out => pc_instr, pc_next => pc_update						--output
									  ); 
	
		if_id: stage12 port map(clk => clk_main, reset => rst_main,wr_en => nstall1,flush => flush1, --control signal
										ir_in => if_instr, pc_in1 => pc_instr, pc_in2 => pc_update, 			--inputs
										ir_out => reg1_ir, pc_out1 => reg1_pc_init, pc_out2 => reg1_pc_added	--outputs
										);				
		
		decode_instr: decode port map(his_out => history,																							--history bit
												ir => reg1_ir,pc_init => reg1_pc_init,pc_plus2 => reg1_pc_added,								--input pc
												
												pc_out => pc_temp,pc_branched => pc_brch_id, 														--output pc 
												opcode => id_opcode, ra_add => id_ra_add, rb_add => id_rb_add, rc_add => id_rc_add,
												imm16 => id_imm16, con => id_cond, com => id_comp,													--ir decoding
												brch => brch_id,jmp => jump_id,
												r0_up => r0_lm, r1_up=> r1_lm, r2_up => r2_lm, r3_up => r3_lm, r4_up => r4_lm, r5_up => r5_lm, r6_up => r6_lm, r7_up => r7_lm,
												reg_read => id_reg_read,reg_wr => id_reg_wr,mem_rd => id_mem_rd,mem_wr => id_mem_wr		--control
												);
		
		id_rr: stage23 port map(clk => clk_main, reset => rst_main,wr_en => nstall2,flush => flush2,
										brch_in => brch_id,  pc_in => pc_temp, pc_store => reg1_pc_init,
										opcode => id_opcode, ra_add => id_ra_add, rb_add => id_rb_add, rc_add => id_rc_add, imm16 => id_imm16,  cond => id_cond, comp =>id_comp,
										reg_wr => id_reg_wr, mem_rd =>id_mem_rd, mem_wr => id_mem_wr,
										r0_in => r0_lm, r1_in => r1_lm, r2_in => r2_lm, r3_in => r3_lm, r4_in => r4_lm, r5_in => r5_lm, r6_in => r6_lm, r7_in => r7_lm,
										r0_updt => r0_change, r1_updt => r1_change, r2_updt => r2_change, r3_updt => r3_change, r4_updt => r4_change, r5_updt => r5_change, r6_updt => r6_change, r7_updt => r7_change,
										
										r0_out => reg2_r0, r1_out => reg2_r1, r2_out => reg2_r2, r3_out => reg2_r3, r4_out => reg2_r4, r5_out => reg2_r5, r6_out => reg2_r6, r7_out => reg2_r7,
										brch_out => reg2_brch_id,  pc_out => reg2_pc_stored, pc_store_out => reg2_pc_init, 
										opcode_out => reg2_opcode, ra_add_out => reg2_ra_add, rb_add_out => reg2_rb_add, rc_add_out => reg2_rc_add, imm16_out => reg2_imm16,  cond_out => reg2_cond, comp_out =>reg2_comp,
										reg_wr_out => reg2_reg_wr, mem_rd_out =>reg2_mem_rd, mem_wr_out => reg2_mem_wr
										);
		
		addresses : reg_dec port map( ra_add => reg2_ra_add, rb_add => reg2_rb_add, rc_add => reg2_rc_add, 
												r0_flag => reg2_r0, r1_flag => reg2_r1, r2_flag => reg2_r2, r3_flag => reg2_r3, r4_flag => reg2_r4, r5_flag => reg2_r5, r6_flag => reg2_r6, r7_flag => reg2_r7,
												opcode_in => reg2_opcode,
												
												r0_update => r0_change, r1_update => r1_change, r2_update => r2_change, r3_update => r3_change, r4_update => r4_change, r5_update => r5_change, r6_update => r6_change, r7_update => r7_change,
												ra_fin => ra_add_rf, rb_fin => rb_add_rf, rc_fin => rc_add_rf
											);
												
												
		
		read_r: read_op port map(pc_store => reg2_pc_stored, pc_init => reg2_pc_init,
										did_branch => reg2_brch_id, 
										fwd1 => fwd_a, fwd2 => fwd_b, fwd_reg1 => fwd_val1, fwd_reg2 => fwd_val2,
										ra_temp => ra_temp1, rb_temp => rb_temp1,
										imm16=> reg2_imm16, opcode_in => reg2_opcode, 
										
										brch => brch_rr,hzrd => hazard, hisbit_update => hisbit_data_in, 
										ra_out => ra_data1, rb_out => rb_data2,
										pc_branch => pc_brch_rr
										);
	
		rr_ex: stage34 port map(clk => clk_main, reset => rst_main, wr_en => '1',flush => flush3,
										opcode =>reg2_opcode, cond => reg2_cond, comp => reg2_comp,
										ra_in => ra_data1, rb_in => rb_data2, rc_add_in => rc_add_rf, imm16 => reg2_imm16, pc_in => reg2_pc_stored,
										mem_rd_in => reg2_mem_rd, mem_wr_in => reg2_mem_wr, reg_wr_in => reg2_reg_wr,
										r0_flag => reg2_r0, r1_flag => reg2_r1, r2_flag => reg2_r2, r3_flag => reg2_r3, r4_flag => reg2_r4, r5_flag => reg2_r5, r6_flag => reg2_r6, r7_flag => reg2_r7,
										lm_flag => lm_flag, data_alu => alu1,
										
										r0_flag_out => reg3_r0, r1_flag_out => reg3_r1, r2_flag_out => reg3_r2, r3_flag_out => reg3_r3, r4_flag_out => reg3_r4, r5_flag_out => reg3_r5, r6_flag_out => reg3_r6, r7_flag_out => reg3_r7,
										opcode_out => reg3_opcode, comp_out => reg3_comp, cond_out => reg3_cond,
										mem_rd_out => reg3_mem_rd, mem_wr_out => reg3_mem_wr, reg_wr_out => reg3_reg_wr,
										pc_out => reg3_pc_out, imm16_out => reg3_imm,  rc_add_out => reg3_rc_add, ra_out => reg3_data1, rb_out => reg3_data2
										);
	
		execute1: execute port map(cin => cinit, cond => reg3_cond, comp => reg3_comp,
											ra_in => reg3_data1, rb_in => reg3_data2, 
											opcode => reg3_opcode, imm => reg3_imm,
											r0_in => reg3_r0, r1_in => reg3_r1, r2_in => reg3_r2, r3_in => reg3_r3, r4_in => reg3_r4, r5_in => reg3_r5, r6_in => reg3_r6, r7_in => reg3_r7,
											
											data => alu1, carry => cout, z => zout, ld_flag => stall_load, lm_sm_flag => lm_flag
											);

		ex_ma: stage45 port map(clk => clk_main, reset => rst_main, wr_en => '1', flush => '0',
										mem_rd_in => reg3_mem_rd, mem_wr_in => reg3_mem_wr, reg_wr_in => reg3_reg_wr,
										opcode => reg3_opcode, rc_add => reg3_rc_add, cond_in =>reg3_cond,
										ra_in=> reg3_data1, rb_in => reg3_data2, aluout1 => alu1, imm16 => reg3_imm,pc_in => reg3_pc_out,
										carry_in => cout, z_in => zout,
										
										mem_rd_out => reg4_mem_rd, mem_wr_out => reg4_mem_wr, reg_wr_out => reg4_reg_wr,
										ra_out=> reg4_data1,rb_out => reg4_data2, alu1_out => reg4_alu, imm16_out => reg4_data16, pc_out => reg4_pc_out,
										opcode_out => reg4_opcode, cond_out => reg4_cond, rc_add_out => reg4_rc_add, 
										carry_out => reg4_carry, z_out => reg4_z
										);
		
		ma: memory port map(opcode => reg4_opcode,
								 rc_data => reg4_alu, ra_data => reg4_data1, rb_data =>reg4_data2, 
					
								 mem_data_add => datamem_add, mem_data_in => datamem_input);

		ma_wb: stage56 port map(clk => clk_main, reset => rst_main, wr_en => '1', flush => '0',
										reg_wr_in => reg4_reg_wr, rc_data_in => reg4_alu, mem_data => ma_data_read, imm16 => reg4_data16, rc_add=> reg4_rc_add, pc_in => reg4_pc_out,
										opcode => reg4_opcode, cond_in=> reg4_cond, carry_in => reg4_carry, z_in => reg4_z,
										
										opcode_out => reg5_opcode,cond_out=> reg5_cond,
										rc_data_out => reg5_alu,reg_wr_out => reg5_reg_wr, mem_data_out => reg5_mem_data, imm16_out => reg5_imm16, rc_add_out => reg5_rc_add, pc_out => reg5_pc_out,
										carry_out => reg5_carry,  z_out => reg5_z
										);
	
		wb: writeback port map( carry => reg5_carry, zflag => reg5_z, cond => reg5_cond, reg_wr => reg5_reg_wr, 
										rc_data => reg5_alu, mem_data => reg5_mem_data,imm16 => reg5_imm16, pc_in => reg5_pc_out,
										opcode => reg5_opcode,
								
										rf_flag => register_wr_flag, 
										rf_update => wb_input 
										
										);
		
		fwd_1: forward port map(reg_check => ra_add_rf, ex_add => reg3_rc_add, ma_add => reg4_rc_add, wb_add => reg5_rc_add, 
										ex_reg_data1 => alu1, ex_reg_data2 => reg3_imm,
										ma_reg_data1 => reg4_alu, ma_reg_data2 => ma_data_read, ma_reg_data4 => reg4_pc_out,ma_reg_data3 => reg4_data16,
										wb_reg_data1 => reg5_alu, wb_reg_data2 => reg5_mem_data, wb_reg_data3 => reg5_pc_out, wb_reg_data4 => reg5_imm16, 
										ex_opcode => reg3_opcode, ma_opcode => reg4_opcode, wb_opcode => reg5_opcode,
									
										fwd_reg_val => fwd_val1, fwd_en => fwd_a);
		
		fwd_2: forward port map(reg_check => rb_add_rf, ex_add => reg3_rc_add, ma_add => reg4_rc_add, wb_add => reg5_rc_add, 
										ex_reg_data1 => alu1, ex_reg_data2 => reg3_imm, 
										ma_reg_data1 => reg4_alu, ma_reg_data2 => ma_data_read, ma_reg_data4 => reg4_data16, ma_reg_data3 => reg4_pc_out,
										wb_reg_data1 => reg5_alu, wb_reg_data3 => reg5_mem_data, wb_reg_data4 => reg5_pc_out, wb_reg_data2 => reg5_imm16,
										ex_opcode => reg3_opcode, ma_opcode => reg4_opcode, wb_opcode => reg5_opcode,
									
										fwd_reg_val => fwd_val2, fwd_en => fwd_b);
		
		output <= '1';
		
end architecture;