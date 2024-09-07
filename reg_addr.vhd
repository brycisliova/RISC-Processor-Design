library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_dec is
	port( ra_add, rb_add, rc_add: in std_logic_vector(2 downto 0);
			r0_flag, r1_flag, r2_flag, r3_flag, r4_flag, r5_flag, r6_flag, r7_flag: in std_logic;
			opcode_in: std_logic_vector(3 downto 0);
						
			--r0_flag_out, r1_flag_out, r2_flag_out, r3_flag_out, r4_flag_out, r5_flag_out, r6_flag_out, r7_flag_out: out std_logic;
			r0_update, r1_update, r2_update, r3_update, r4_update, r5_update, r6_update, r7_update : out std_logic;
			ra_fin, rb_fin, rc_fin: out std_logic_vector(2 downto 0)
		);
end entity reg_dec;

architecture desc of reg_dec is

	signal reg_add, reg_add2: std_logic_vector(2 downto 0);
	
	begin
	
	ra_fin <= ra_add;
	
	rb_fin <= reg_add;
	
	rc_fin <= reg_add2;
	
	sel_reg: process(rb_add,rc_add,opcode_in, r0_flag, r1_flag, r2_flag, r3_flag, r4_flag, r5_flag, r6_flag, r7_flag)
	
	begin
		if(opcode_in = "0111") then
		
			if(r0_flag = '1') then
				reg_add <= "000";
				
				r0_update <= '1';
				r1_update <= '0';
				r2_update <= '0';
				r3_update <= '0';
				r4_update <= '0';
				r5_update <= '0';
				r6_update <= '0';
				r7_update <= '0';
				
				
				
			elsif(r1_flag = '1') then
				reg_add <= "001";
				
				r0_update <= '0';
				r1_update <= '1';
				r2_update <= '0';
				r3_update <= '0';
				r4_update <= '0';
				r5_update <= '0';
				r6_update <= '0';
				r7_update <= '0';
				
			elsif(r2_flag = '1') then
				reg_add <= "010";
				
				r0_update <= '0';
				r1_update <= '0';
				r2_update <= '1';
				r3_update <= '0';
				r4_update <= '0';
				r5_update <= '0';
				r6_update <= '0';
				r7_update <= '0';
				
			elsif(r3_flag = '1') then
				reg_add <= "011";
				
				r0_update <= '0';
				r1_update <= '0';
				r2_update <= '0';
				r3_update <= '1';
				r4_update <= '0';
				r5_update <= '0';
				r6_update <= '0';
				r7_update <= '0';
				
			elsif(r4_flag = '1') then
				reg_add <= "100";
				
				r0_update <= '0';
				r1_update <= '0';
				r2_update <= '0';
				r3_update <= '0';
				r4_update <= '1';
				r5_update <= '0';
				r6_update <= '0';
				r7_update <= '0';
				
			elsif(r5_flag = '1') then
				reg_add <= "101";
				
				r0_update <= '0';
				r1_update <= '0';
				r2_update <= '0';
				r3_update <= '0';
				r4_update <= '0';
				r5_update <= '1';
				r6_update <= '0';
				r7_update <= '0';
				
			elsif(r6_flag = '1') then
				reg_add <= "110";
				
				r0_update <= '0';
				r1_update <= '0';
				r2_update <= '0';
				r3_update <= '0';
				r4_update <= '0';
				r5_update <= '0';
				r6_update <= '1';
				r7_update <= '0';
				
			elsif(r7_flag = '1') then
				reg_add <= "111";
				
				r0_update <= '0';
				r1_update <= '0';
				r2_update <= '0';
				r3_update <= '0';
				r4_update <= '0';
				r5_update <= '0';
				r6_update <= '0';
				r7_update <= '1';
				
			end if;
		
		elsif(opcode_in = "0110") then
		
			if(r0_flag = '1') then
				reg_add2 <= "000";
				
				r0_update <= '1';
				r1_update <= '0';
				r2_update <= '0';
				r3_update <= '0';
				r4_update <= '0';
				r5_update <= '0';
				r6_update <= '0';
				r7_update <= '0';
				
			elsif(r1_flag = '1') then
				reg_add2 <= "001";
				
				r0_update <= '0';
				r1_update <= '1';
				r2_update <= '0';
				r3_update <= '0';
				r4_update <= '0';
				r5_update <= '0';
				r6_update <= '0';
				r7_update <= '0';
				
			elsif(r2_flag = '1') then
				reg_add2 <= "010";
				
				r0_update <= '0';
				r1_update <= '0';
				r2_update <= '1';
				r3_update <= '0';
				r4_update <= '0';
				r5_update <= '0';
				r6_update <= '0';
				r7_update <= '0';
				
			elsif(r3_flag = '1') then
				reg_add2 <= "011";
				
				r0_update <= '0';
				r1_update <= '0';
				r2_update <= '0';
				r3_update <= '1';
				r4_update <= '0';
				r5_update <= '0';
				r6_update <= '0';
				r7_update <= '0';
				
			elsif(r4_flag = '1') then
				reg_add2 <= "100";
				
				r0_update <= '0';
				r1_update <= '0';
				r2_update <= '0';
				r3_update <= '0';
				r4_update <= '1';
				r5_update <= '0';
				r6_update <= '0';
				r7_update <= '0';
				
			elsif(r5_flag = '1') then
				reg_add2 <= "101";
				
				r0_update <= '0';
				r1_update <= '0';
				r2_update <= '0';
				r3_update <= '0';
				r4_update <= '0';
				r5_update <= '1';
				r6_update <= '0';
				r7_update <= '0';
				
			elsif(r6_flag = '1') then
				reg_add2 <= "110";
				
				r0_update <= '0';
				r1_update <= '0';
				r2_update <= '0';
				r3_update <= '0';
				r4_update <= '0';
				r5_update <= '0';
				r6_update <= '1';
				r7_update <= '0';
				
			elsif(r7_flag = '1') then
				reg_add2 <= "111";
				
				r0_update <= '0';
				r1_update <= '0';
				r2_update <= '0';
				r3_update <= '0';
				r4_update <= '0';
				r5_update <= '0';
				r6_update <= '0';
				r7_update <= '1';
			end if;
		else
				reg_add <= rb_add;
				reg_add2 <= rc_add;
				
				r0_update <= '0';
				r1_update <= '0';
				r2_update <= '0';
				r3_update <= '0';
				r4_update <= '0';
				r5_update <= '0';
				r6_update <= '0';
				r7_update <= '0';
		end if;
	end process;

	end architecture;
			
	