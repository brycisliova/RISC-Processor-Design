library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stage34 is
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
          ra_out, rb_out : out std_logic_vector(15 downto 0);
          rc_add_out : out std_logic_vector(2 downto 0);
          cond_out : out std_logic_vector(1 downto 0);
			 comp_out : out std_logic;
          imm16_out, pc_out: out std_logic_vector(15 downto 0);
			 opcode_out : out std_logic_vector(3 downto 0)

		  );
		  
end entity stage34;

architecture pipereg2 of stage34 is
	begin
		update_pipe3: process(clk, reset, wr_en, flush, ra_in, rb_in, rc_add_in, cond, comp, imm16, pc_in) is
				begin
            if(reset = '1') then
                ra_out <= "0000000000000000";
                rb_out <= "0000000000000000";
                imm16_out <= "0000000000000000";
                pc_out <= "0000000000000000";
                rc_add_out <= "000";
                cond_out <= "00";
                comp_out <= '0';
					 mem_rd_out <= '0';
					 mem_wr_out <= '0';
					 reg_wr_out <= '0';
					 opcode_out <= "0000";
					 r0_flag_out <= '0';
					r1_flag_out <= '0';
					r2_flag_out <= '0';
					r3_flag_out <= '0';
					r4_flag_out <= '0';
					r5_flag_out <= '0';
					r6_flag_out <= '0';
					r7_flag_out <= '0';
				elsif(clk'event and clk = '0' and flush = '1') then
					ra_out <= "0000000000000000";
                rb_out <= "0000000000000000";
                imm16_out <= "0000000000000000";
                pc_out <= "0000000000000000";
                rc_add_out <= "000";
                cond_out <= "00";
                comp_out <= '0';
					 mem_rd_out <= '0';
					 mem_wr_out <= '0';
					 reg_wr_out <= '0';
					 opcode_out <= "0000";
					 r0_flag_out <= '0';
					r1_flag_out <= '0';
					r2_flag_out <= '0';
					r3_flag_out <= '0';
					r4_flag_out <= '0';
					r5_flag_out <= '0';
					r6_flag_out <= '0';
					r7_flag_out <= '0';
				elsif(clk'event and clk = '0' and lm_flag = '1') then
					ra_out <= data_alu;
					rb_out <= rb_in;
					imm16_out <= imm16;
					pc_out <= pc_in;
					rc_add_out <= rc_add_in;
					cond_out <= cond;
					comp_out <= comp;
					mem_rd_out <= mem_rd_in;
					mem_wr_out <= mem_wr_in;
					reg_wr_out <= reg_wr_in;
					opcode_out <= opcode;
					r0_flag_out <= r0_flag;
					r1_flag_out <= r1_flag;
					r2_flag_out <= r2_flag;
					r3_flag_out <= r3_flag;
					r4_flag_out <= r4_flag;
					r5_flag_out <= r5_flag;
					r6_flag_out <= r6_flag;
					r7_flag_out <= r7_flag;
					
					 

            elsif(clk'event and clk = '0' and wr_en = '1') then  
					ra_out <= ra_in;
					rb_out <= rb_in;
					imm16_out <= imm16;
					pc_out <= pc_in;
					rc_add_out <= rc_add_in;
					cond_out <= cond;
					comp_out <= comp;
					mem_rd_out <= mem_rd_in;
					mem_wr_out <= mem_wr_in;
					reg_wr_out <= reg_wr_in;
					opcode_out <= opcode;
					r0_flag_out <= r0_flag;
					r1_flag_out <= r1_flag;
					r2_flag_out <= r2_flag;
					r3_flag_out <= r3_flag;
					r4_flag_out <= r4_flag;
					r5_flag_out <= r5_flag;
					r6_flag_out <= r6_flag;
					r7_flag_out <= r7_flag;

            end if;
            
        end process;
            
end architecture;