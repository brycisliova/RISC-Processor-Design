library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decode is
	port( his_out : in std_logic;
		  ir,pc_init, pc_plus2: in std_logic_vector(15 downto 0);
		  
		  pc_out, pc_branched : out std_logic_vector(15 downto 0);
		  ra_add, rb_add, rc_add : out std_logic_vector(2 downto 0);
		  opcode : out std_logic_vector(3 downto 0);
		  con : out std_logic_vector(1 downto 0);
		  com : out std_logic;
		  imm16 : out std_logic_vector(15 downto 0);
		  reg_read, reg_wr, mem_rd, mem_wr, brch, jmp, r0_up, r1_up, r2_up, r3_up, r4_up, r5_up, r6_up, r7_up : out std_logic);
		  
end entity decode;

architecture id_stage of decode is
	component controlunit is
		 port (
			  opcode : in std_logic_vector(3 downto 0);
			  
			  reg_rd : out std_logic;
			  reg_wr : out std_logic;
			  mem_rd : out std_logic;
			  mem_wr : out std_logic
		 );
	end component;
	
	component pad7 is
	port(
		input: in std_logic_vector(8 downto 0);
		output: out std_logic_vector(15 downto 0));
	end component;
	
	component branch_cntrl is
		port(pc_in, inp : in std_logic_vector(15 downto 0);
			  hisbit : in std_logic;
			  
			  pc_branch, pc_store: out std_logic_vector(15 downto 0)
			  );
	end component branch_cntrl;
	
	component signextender6to16 is
		port (input : IN STD_LOGIC_VECTOR(5 downto 0);
			  output : OUT STD_LOGIC_VECTOR(15 downto 0));
	end component signextender6to16;
	
	component signextender9to16 is
		port (input : IN STD_LOGIC_VECTOR(8 downto 0);
			 output : OUT STD_LOGIC_VECTOR(15 downto 0));
	end component signextender9to16;
	
	component l_shifter is
	port(
		input: in std_logic_vector(15 downto 0);
		output: out std_logic_vector(15 downto 0));
	end component;
	
	component alu is
	port(
		alu_A: in std_logic_vector(15 downto 0);
		alu_B: in std_logic_vector(15 downto 0);
		Cin: in std_logic;
		sel: in std_logic;
		enable: in std_logic;
		alu_out: out std_logic_vector(15 downto 0);
		Cout: out std_logic;
		Z: out std_logic);
	end component alu;

	
	signal rf_write, rf_read, mem_read, mem_write, branch, jump, comp: std_logic;
	signal rr_read1, rr_read2, wb_wr1: std_logic_vector(2 downto 0) := "000";
	signal cond: std_logic_vector(1 downto 0);
	signal imm6_16, imm9_16, padd7, pc, pc_up, pc_temp, pc_down, imm_temp, imm_brch, imm : std_logic_vector(15 downto 0);
	
	begin
	
		immshift: l_shifter port map(input => imm, output => imm_temp);
		
		control: controlunit port map(opcode => ir(15 downto 12), mem_rd => mem_read, mem_wr => mem_write, reg_rd => rf_read, reg_wr => rf_write);
		
		alu_imm: alu port map( alu_A => pc_init, alu_B => imm_temp, Cin => '0', sel => '0', enable => '0', alu_out => imm_brch);
		
		branch_comp: branch_cntrl port map(pc_in => pc_plus2,inp => imm_brch, hisbit => his_out, pc_branch => pc_up, pc_store => pc_down);
			
		extend1: signextender6to16 port map(input => ir(5 downto 0), output => imm6_16);
		
		extend2: signextender9to16 port map(input => ir(8 downto 0), output => imm9_16);
		
		padder7: pad7 port map(input => ir(8 downto 0), output => padd7);
		
		opcode <= ir(15 downto 12);
		
		pc_out <= pc_temp;
		
		brch <= branch;
		
		jmp <= jump;
		
		ra_add <= rr_read1;
		
		rb_add <= rr_read2;
		
		rc_add <= wb_wr1;
		
		imm16 <= imm;
		
		con <= cond;
		
		com <= comp;
		
		mem_rd <= mem_read;
		
		mem_wr <= mem_write;
		
		reg_read <= rf_read;
		
		reg_wr <= rf_write;
				
		
		reg: process(ir) is
		
		begin
			if(ir(15 downto 12) = "0001" or ir(15 downto 12) = "0000" or ir(15 downto 12) ="0010" or ir(15 downto 12) ="0101" or ir(15 downto 12) ="0110" or ir(15 downto 12) ="0111" or ir(15 downto 12) ="1010" or ir(15 downto 12) ="1001" or ir(15 downto 12) ="1000" or ir(15 downto 12) ="1111") then
				rr_read1 <= ir(11 downto 9);
				if(ir(15 downto 12) = "0010" or ir(15 downto 12) = "0001") then
					rr_read2 <= ir(8 downto 6);
					wb_wr1 <= ir(5 downto 3);
					comp <= ir(2);
					cond <= ir(1 downto 0);
				elsif((ir(15 downto 12) = "0101") or (ir(15 downto 12) = "1010") or (ir(15 downto 12) = "1001") or (ir(15 downto 12) = "1000")) then
					rr_read2 <= ir(8 downto 6);
					
				elsif(ir(15 downto 12) = "0000") then
					wb_wr1 <= ir(8 downto 6);
				end if;
			elsif((ir(15 downto 12) = "0011") or (ir(15 downto 12) = "0100") or (ir(15 downto 12) = "1100") or (ir(15 downto 12) = "1101")) then
				wb_wr1 <= ir(11 downto 9);
				if((ir(15 downto 12) = "0100") or (ir(15 downto 12) = "1101")) then
					rr_read1 <= ir(8 downto 6);
				end if;
			end if;
		end process;
		
		imm_proc: process(ir)
		
		begin
			
			if(ir(15 downto 12) = "0000" or ir(15 downto 12) = "0100" or ir(15 downto 12) = "0101" or ir(15 downto 12) = "1000" or ir(15 downto 12) = "1001" or ir(15 downto 12) = "1010") then
				imm <= imm6_16;
			elsif(ir(15 downto 12) = "1100" or ir(15 downto 12) = "1111") then			
				imm <= imm9_16;
			elsif(ir(15 downto 12) = "0011") then
				imm <= padd7;
			end if;
		end process;
		
		branch_jump: process(ir, pc_init, pc_plus2)
		
		begin
			
			if((ir(15 downto 12) = "1000") or (ir(15 downto 12) = "1001") or (ir(15 downto 12) = "1010")) then
				branch <= '1';
				jump <= '0';
				pc_branched <= pc_up;
				pc_temp <= pc_down;
			elsif((ir(15 downto 12) = "1100") or (ir(15 downto 12) = "1101") or (ir(15 downto 12) = "1111")) then
				branch <= '0';
				jump <= '1';
				pc_branched <= "0000000000000000";
				pc_temp <= pc_plus2;
			else
				branch <= '0';
				jump <= '0';
				pc_branched <= "0000000000000000";
				pc_temp <= pc_plus2;
			end if;
		end process;
		
		lm_sm: process(ir)
		
		begin
			if(ir(15 downto 12) = "0110" or ir(15 downto 12) = "0111") then
				if(ir(7) = '1') then
					r0_up <= '1';
				else
					r0_up <= '0';
				end if;
				
				if(ir(6) = '1') then
					r1_up <= '1';
				else
					r1_up <= '0';
				end if;
				
				if(ir(5) = '1') then
					r2_up <= '1';
				else
					r2_up <= '0';
				end if;
				
				if(ir(4) = '1') then
					r3_up <= '1';
				else
					r3_up <= '0';
				end if;
				
				if(ir(3) = '1') then
					r4_up <= '1';
				else
					r4_up <= '0';
				end if;
				
				if(ir(2) = '1') then
					r5_up <= '1';
				else
					r5_up <= '0';
				end if;
				
				if(ir(1) = '1') then
					r6_up <= '1';
				else
					r6_up <= '0';
				end if;
				
				if(ir(0) = '1') then
					r7_up <= '1';
				else
					r7_up <= '0';
				end if;
			else
				r0_up <= '0';
				r1_up <= '0';
				r2_up <= '0';
				r3_up <= '0';
				r4_up <= '0';
				r5_up <= '0';
				r6_up <= '0';
				r7_up <= '0';
				
			end if;
		end process;
				
				
				

end architecture;
