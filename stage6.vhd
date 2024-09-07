library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity writeback is
	port(carry, zflag, reg_wr: in std_logic;
		  cond : in std_logic_vector(1 downto 0);
		  opcode : in std_logic_vector(3 downto 0);
		  rc_data, mem_data, imm16,pc_in : in std_logic_vector(15 downto 0);
		  
		  rf_update: out std_logic_vector(15 downto 0);
		  rf_flag : out std_logic
		  
		  );
		  
end entity writeback;

architecture wb_stage of writeback is
	
	signal rf_in: std_logic_vector(15 downto 0);
	signal flag : std_logic;
	
	begin
		
		rf_update <= rf_in;
		rf_flag <= flag; 
		
		flags: process(opcode, reg_wr, carry, zflag, cond) is
		
		begin
		
			if((opcode = "0001") or (opcode = "0010")) then
				if(cond = "01") then
					flag <= zflag;
				elsif(cond = "10") then
					flag <= carry;
				end if;
			else
				flag <= reg_wr;
			end if;
		end process;
		
		sel : process(opcode, rc_data, mem_data, imm16, pc_in) is
		
		begin
			
			if((opcode = "0001") or (opcode = "0000") or (opcode = "0010")) then
				rf_in <= rc_data;
			elsif(opcode = "0011") then
				rf_in <= imm16;
			elsif(opcode = "0100" or opcode = "0110") then
				rf_in <= mem_data;
			elsif((opcode = "1100") or (opcode = "1101") or (opcode = "1111")) then
				rf_in <= pc_in;
			else 
				rf_in <= (others => '1');
			end if;
		end process;

end architecture;