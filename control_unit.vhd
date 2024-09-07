library ieee;
use ieee.std_logic_1164.all;

entity controlunit is
    port (
        opcode : in std_logic_vector(3 downto 0);
		  
		  reg_rd : out std_logic;
		  reg_wr : out std_logic;
		  mem_rd : out std_logic;
		  mem_wr : out std_logic
    );
end entity;

architecture arch of controlunit is
    begin
        proc: process (opcode) is
            begin
                if((opcode = "0010") or (opcode = "0001")) then 
						reg_rd <= '1';
						reg_wr <= '1';
						mem_rd <= '0';
						mem_wr <= '0';
						
					elsif(opcode = "0000") then
						reg_rd <= '1';
						reg_wr <= '1';
						mem_rd <= '0';
						mem_wr <= '0';
						
					elsif(opcode = "0011") then
						reg_rd <= '0';
						reg_wr <= '1';
						mem_rd <= '1';
						mem_wr <= '0';
						
					elsif(opcode = "0100") then
						reg_rd <= '1';
						reg_wr <= '1';
						mem_rd <= '1';
						mem_wr <= '0';	
						
					elsif(opcode = "0101") then
						reg_rd <= '1';
						reg_wr <= '0';
						mem_rd <= '0';
						mem_wr <= '1';	
						
					elsif(opcode = "0110") then
						reg_rd <= '1';
						reg_wr <= '0';
						mem_rd <= '1';
						mem_wr <= '0';	
						
					elsif(opcode = "0111") then
						reg_rd <= '1';
						reg_wr <= '0';
						mem_rd <= '0';
						mem_wr <= '1';	
						
					elsif((opcode = "1010") or (opcode = "1001") or (opcode = "1000"))then
						reg_rd <= '1';
						reg_wr <= '0';
						mem_rd <= '0';
						mem_wr <= '0';	
						
					
					elsif(opcode = "1100") then
						reg_rd <= '0';
						reg_wr <= '1';
						mem_rd <= '0';
						mem_wr <= '0';	
					
				   elsif(opcode = "1101") then
						reg_rd <= '1';
						reg_wr <= '1';
						mem_rd <= '0';
						mem_wr <= '0';	
						
					elsif(opcode = "1111") then
						reg_rd <= '1';
						reg_wr <= '0';
						mem_rd <= '0';
						mem_wr <= '0';	
					else
						reg_rd <= '0';
						reg_wr <= '0';
						mem_rd <= '0';
						mem_wr <= '0';
				
               end if;
					 
					 
				end process;
				
				
    end architecture arch;