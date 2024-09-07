library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stage45 is
	port(clk, reset, wr_en, flush: in std_logic;
		  opcode : in std_logic_vector(3 downto 0);
          rc_add : in std_logic_vector(2 downto 0);
          ra_in, aluout1, imm16,rb_in : in std_logic_vector(15 downto 0);
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
		  
end entity stage45;

architecture pipereg4 of stage45 is
	begin
		update_pipe3: process(clk, reset, wr_en, flush, opcode, rc_add, ra_in, aluout1, imm16, pc_in) is
			begin
            if(reset = '1') then
                pc_out <= "0000000000000000";
                ra_out <= "0000000000000000";
                alu1_out <= "0000000000000000";
                imm16_out <= "0000000000000000";
					 rb_out <= "0000000000000000";
                opcode_out <= "0000";
					 mem_rd_out <= '0';
					 mem_wr_out <= '0';
					 reg_wr_out <= '0';
					 carry_out <= '0';
					 z_out <= '0';
					 cond_out <= "00";
                rc_add_out <= "000";
				elsif(clk'event and clk = '0' and flush ='0') then
					pc_out <= "0000000000000000";
                ra_out <= "0000000000000000";
                alu1_out <= "0000000000000000";
                imm16_out <= "0000000000000000";
					 rb_out <= "0000000000000000";
                opcode_out <= "0000";
					 mem_rd_out <= '0';
					 mem_wr_out <= '0';
					 reg_wr_out <= '0';
					 carry_out <= '0';
					 z_out <= '0';
					 cond_out <= "00";
                rc_add_out <= "000";
					

            elsif(clk'event and clk = '0' and wr_en = '1') then  
            pc_out <= pc_in;
            ra_out <= ra_in;
            alu1_out <= aluout1;
            imm16_out <= imm16;
            opcode_out <= opcode;
				mem_rd_out <= mem_rd_in;
				mem_wr_out <= mem_wr_in;
				reg_wr_out <= reg_wr_in;
				carry_out <= carry_in;
				z_out<= z_in;
				cond_out <= cond_in;
            rc_add_out <= rc_add;

            end if;
            
        end process;
            
end architecture;