library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stage23 is
	port(clk, reset, wr_en, flush, brch_in, r0_updt, r1_updt, r2_updt, r3_updt, r4_updt, r5_updt, r6_updt, r7_updt : in std_logic;
		  
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
          cond_out: out std_logic_vector(1 downto 0);
			 brch_out, r0_out, r1_out, r2_out, r3_out, r4_out, r5_out, r6_out, r7_out : out std_logic;
			 comp_out, reg_wr_out, mem_rd_out, mem_wr_out : out std_logic

		  );
		  
end entity stage23;

architecture pipereg2 of stage23 is
	begin
		update_pipe2: process(clk, reset, wr_en, flush, brch_in, pc_in, pc_store, opcode, ra_add, rb_add, rc_add, imm16, cond, comp, reg_wr, mem_rd, mem_wr ) is
            begin

                if(reset = '1') then
                    imm16_out <= "0000000000000000";
			        pc_out <= "0000000000000000";
			        pc_store_out <= "0000000000000000";
                    opcode_out <= "0000";
                    ra_add_out <= "000";
                    rb_add_out <= "000";
                    rc_add_out <= "000";
                    cond_out <= "00";
                    comp_out <= '0';
                    reg_wr_out <= '0';
                    mem_rd_out <= '0';
                    mem_wr_out <= '0';
						  r0_out <= '0';
						  r1_out <= '0';
						  r2_out <= '0';
						  r3_out <= '0';
						  r4_out <= '0';
						  r5_out <= '0';
						  r6_out <= '0';
						  r7_out <= '0';
						  
					elsif(clk'event and clk = '0' and flush = '1') then
							imm16_out <= "0000000000000000";
			        pc_out <= "0000000000000000";
			        pc_store_out <= "0000000000000000";
                    opcode_out <= "0000";
                    ra_add_out <= "000";
                    rb_add_out <= "000";
                    rc_add_out <= "000";
                    cond_out <= "00";
                    comp_out <= '0';
                    reg_wr_out <= '0';
                    mem_rd_out <= '0';
                    mem_wr_out <= '0';
						  r0_out <= '0';
						  r1_out <= '0';
						  r2_out <= '0';
						  r3_out <= '0';
						  r4_out <= '0';
						  r5_out <= '0';
						  r6_out <= '0';
						  r7_out <= '0';
					elsif(clk'event and clk = '0' and r0_updt = '1') then
						r0_out <= '0';	
					elsif(clk'event and clk = '0' and r1_updt = '1') then
						r1_out <= '0';
					elsif(clk'event and clk = '0' and r2_updt = '1') then
						r2_out <= '0';
					elsif(clk'event and clk = '0' and r3_updt = '1') then
						r3_out <= '0';
					elsif(clk'event and clk = '0' and r4_updt = '1') then
						r4_out <= '0';
					elsif(clk'event and clk = '0' and r5_updt = '1') then
						r5_out <= '0';
					elsif(clk'event and clk = '0' and r6_updt = '1') then
						r6_out <= '0';
					elsif(clk'event and clk = '0' and r7_updt = '1') then
						r7_out <= '0';

               elsif(clk'event and clk = '0' and wr_en = '1') then
                    imm16_out <= imm16;
			        pc_out <= pc_in;
			        pc_store_out <= pc_store;
                    opcode_out <= opcode;
                    ra_add_out <= ra_add;
                    rb_add_out <= rb_add;
                    rc_add_out <= rc_add;
                    cond_out <= cond;
                    comp_out <= comp;
                    reg_wr_out <= reg_wr;
                    mem_rd_out <= mem_rd;
                    mem_wr_out <= mem_wr;
						  
						  r0_out <= r0_in;
						  r1_out <= r1_in;
						  r2_out <= r2_in;
						  r3_out <= r3_in;
						  r4_out <= r4_in;
						  r5_out <= r5_in;
						  r6_out <= r6_in;
						  r7_out <= r7_in;
                
                end if;

            end process;
                
end architecture;