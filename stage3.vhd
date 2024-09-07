library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity read_op is
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
		  
end entity read_op;

architecture rr_stage of read_op is
	
	component control_hazard is
		 port (
			  hisbit_out : in std_logic;
			  --pc_in : in std_logic_vector(15 downto 0);
			  comparator_op : in std_logic;
			  hisbit_in : out std_logic;
			  hazard_bit : out std_logic
			  --pc_branch : out std_logic_vector(15 downto 0)
		 );
	end component;
	
		component branch_cntrl is
		port( hisbit : in std_logic;
				pc_in, inp: in std_logic_vector(15 downto 0);
				
				
				pc_branch, pc_store : out std_logic_vector(15 downto 0)
			);
		end component branch_cntrl;
		
	
		component comparator is
			port (opcode: IN STD_LOGIC_VECTOR(3 downto 0); input_a : IN STD_LOGIC_VECTOR(15 downto 0); input_b : IN STD_LOGIC_VECTOR(15 downto 0);
			
				 output : OUT STD_LOGIC);
		end component comparator;
		
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
		
		component l_shifter is
			port(
				input: in std_logic_vector(15 downto 0);
				output: out std_logic_vector(15 downto 0));
		end component;
			
	signal jump_temp, pc_temp, ra, rb, jump_here, imm_temp , xin, yin: std_logic_vector(15 downto 0);
	signal hazard, should_branch, change_his, branch, hazard1: std_logic;
	
	begin
	
		alu_jmp: alu port map ( alu_A => xin, alu_B => yin, Cin => '0', sel =>'0', enable => '0', alu_out => jump_temp);
		
		immshift_rr: l_shifter port map(input => imm16, output => imm_temp);
		
		comparator1: comparator port map( opcode => opcode_in, input_a => ra, input_b => rb, output => should_branch);
				
		hazard_comp: control_hazard port map(hisbit_out => did_branch, comparator_op => should_branch, hisbit_in => change_his, hazard_bit => hazard);
		
		brch <= branch;
		
		ra_out <= ra;
		
		rb_out<= rb;
		
		pc_branch <= jump_here;
		
		hisbit_update <= change_his;
		
		hzrd <= hazard1;
		
		jump_branch: process(opcode_in, rb, jump_temp, pc_store, hazard)
	
		begin
		
			if(opcode_in = "1000" or opcode_in = "1001" or opcode_in = "1010") then
				branch <= hazard;
				jump_here <= pc_store;
				hazard1 <= hazard;
			elsif(opcode_in = "1100" or opcode_in = "1111") then
				branch <= '1';
				hazard1 <= '0';
				jump_here <= jump_temp;
			elsif(opcode_in = "1101") then
				branch <= '1';
				jump_here <= rb;
				hazard1<= '0';
			else 
				branch <= '0';
				hazard1 <= '0';
			end if;
			
		end process;

		fwd_reg: process(opcode_in, fwd1, fwd2, fwd_reg1, fwd_reg2, ra_temp, rb_temp) is
		
		begin
		
			if(fwd1 = '1') then
				ra <= fwd_reg1;
			else 
				ra <= ra_temp;
			end if;
			
			if(fwd2 = '1') then
				rb <= fwd_reg2;
			else
				rb <= rb_temp;
			end if;
			
		end process;
		
		jump_loc: process(opcode_in, pc_init, ra, imm_temp)
		
		begin
		
			if(opcode_in = "1100") then
				xin <= pc_init;
				yin <= imm_temp;
			elsif(opcode_in = "1111") then
				xin <= ra;
				yin <= imm_temp;
			elsif(opcode_in = "0110" or opcode_in = "0111") then
				xin <= ra;
				yin <= "1111111111111110";
			end if;
		end process;
	

end architecture;