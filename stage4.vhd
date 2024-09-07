library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity execute is
	port(
		  ra_in, rb_in, imm : in std_logic_vector(15 downto 0);
		  opcode : in std_logic_vector(3 downto 0);
		  cond : in std_logic_vector(1 downto 0);
		  comp, cin : in std_logic;
		  r0_in, r1_in, r2_in, r3_in, r4_in, r5_in, r6_in, r7_in: in std_logic;
		  
		  data : out std_logic_vector(15 downto 0);
		  carry, z, ld_flag, lm_sm_flag : out std_logic
		  
		  );
		  
end entity execute;

architecture ex_stage of execute is

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
		
	component complementor is
		port(complementor_in: in std_logic_vector(15 downto 0);
			  comp_enable: in std_logic;
			  complementor_out: out std_logic_vector(15 downto 0)
		);
			  
	end component complementor;
		
	signal alu_en: std_logic := '1';
	signal comp_en: std_logic := '0';
	signal alu_sel: std_logic;
	signal carry_o: std_logic;
	signal alu_out1, alu_a_in, alu_b_in, rb_comp: std_logic_vector(15 downto 0);
	
	begin
		
		alu_data: alu port map( alu_A => alu_a_in, alu_B => alu_b_in, Cin => carry_o, sel => alu_sel, enable => alu_en, alu_out => data, Cout => carry, Z => z);
		
		compl: complementor port map( complementor_in => rb_in, comp_enable => comp_en, complementor_out => rb_comp);
		
	ld_flg: process(opcode) is
	 begin
		if(opcode = "0100") then
			ld_flag <= '1';
			lm_sm_flag <= '0';
		elsif(opcode = "0110") then
			lm_sm_flag <= '1';
			ld_flag <= '1';
		else 
			ld_flag <= '0';
			lm_sm_flag <= '0';
		end if;
	end process;
		
	alu_proc: process(opcode, cond, comp,cin, ra_in, rb_in, imm, r0_in, r1_in, r2_in, r3_in, r4_in, r5_in, r6_in, r7_in) is	
		begin
		if(opcode = "0001") then
			alu_sel <= '0';
			alu_a_in <= ra_in;
			alu_en <= '1';
			
			if(cond = "01") then
					
					carry_o <= '0';
			elsif(cond = "10") then
					
					carry_o <= '0';
			elsif(cond = "11") then
			
				carry_o <= cin;
			else 
				carry_o <= '0';
			end if;
			
			if(comp = '1') then
				comp_en <= '1';
				alu_b_in <= rb_comp;
			else
				comp_en <= '0';
				alu_b_in <= rb_in;
			end if;
			
		elsif(opcode = "0000") then
			alu_sel <= '0';
			alu_a_in <= ra_in;
			alu_b_in <= imm;
			alu_en <= '1';
		
		elsif(opcode = "0010") then
			alu_sel <= '1';
			alu_a_in <= ra_in;
			alu_en <= '0';
			
			if(cond = "01") then
				carry_o <= '0';
			elsif(cond = "10") then
				carry_o <= '0';
			else 
				carry_o <= '0';
			end if;
			
			if(comp = '1') then
				comp_en <= '1';
				alu_b_in <= rb_comp;
			else
				comp_en <= '0';
				alu_b_in <= rb_in;
			end if;
		
		elsif(opcode = "0100" or opcode = "0101") then
			alu_sel <= '0';
			alu_a_in <= rb_in;
			alu_b_in <= imm;
			alu_en <= '1';
		
		elsif(opcode = "0110" or opcode = "0111") then
			if(r0_in = '1') then
				alu_sel <= '0';
				alu_a_in <= ra_in;
				alu_b_in <= "0000000000000010";
				alu_en <= '1';
			elsif(r1_in = '1') then
				alu_sel <= '0';
				alu_a_in <= ra_in;
				alu_b_in <= "0000000000000010";
				alu_en <= '1';
			elsif(r2_in = '1') then
				alu_sel <= '0';
				alu_a_in <= ra_in;
				alu_b_in <= "0000000000000010";
				alu_en <= '1';
			elsif(r3_in = '1') then
				alu_sel <= '0';
				alu_a_in <= ra_in;
				alu_b_in <= "0000000000000010";
				alu_en <= '1';
			elsif(r4_in = '1') then
				alu_sel <= '0';
				alu_a_in <= ra_in;
				alu_b_in <= "0000000000000010";
				alu_en <= '1';
			elsif(r5_in = '1') then
				alu_sel <= '0';
				alu_a_in <= ra_in;
				alu_b_in <= "0000000000000010";
				alu_en <= '1';
			elsif(r6_in = '1') then
				alu_sel <= '0';
				alu_a_in <= ra_in;
				alu_b_in <= "0000000000000010";
				alu_en <= '1';
			elsif(r7_in = '1') then
				alu_sel <= '0';
				alu_a_in <= ra_in;
				alu_b_in <= "0000000000000010";
				alu_en <= '1';
			end if;
		end if;
	end process;
			
			
end architecture;
			

		
		
			
			
			
				