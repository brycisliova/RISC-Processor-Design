library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stage56 is
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
		  
end entity stage56;

architecture pipereg5 of stage56 is
	begin
		update_pipe2: process(clk, reset, wr_en, flush, reg_wr_in, opcode, rc_data_in, rc_add, mem_data, imm16, pc_in, cond_in, carry_in, z_in) is
            begin

                if(reset = '1') then
                    reg_wr_out <= '0';
                    opcode_out <= "0000";
                    
							rc_data_out <= "0000000000000000";
                    mem_data_out <= "0000000000000000";
                    imm16_out <= "0000000000000000";
                    rc_add_out <= "000";
                    pc_out <= "0000000000000000";
                    cond_out <= "00";
                    carry_out <= '0';
                    z_out <= '0';
						elsif(clk'event and clk = '0' and flush = '1') then
							 reg_wr_out <= '0';
                    opcode_out <= "0000";
                    
							rc_data_out <= "0000000000000000";
                    mem_data_out <= "0000000000000000";
                    imm16_out <= "0000000000000000";
                    rc_add_out <= "000";
                    pc_out <= "0000000000000000";
                    cond_out <= "00";
                    carry_out <= '0';
                    z_out <= '0';

                elsif(clk'event and clk = '0'and wr_en = '1') then
                    reg_wr_out <= reg_wr_in;
                    opcode_out <= opcode;
                    
							rc_data_out <= rc_data_in;
                    mem_data_out <= mem_data;
                    imm16_out <= imm16;
                    rc_add_out <= rc_add;
                    pc_out <= pc_in;
                    cond_out <= cond_in;
                    carry_out <= carry_in;
                    z_out <= z_in;
                
                end if;

            end process;
                
end architecture;