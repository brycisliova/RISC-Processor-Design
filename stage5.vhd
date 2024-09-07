library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is
	port(
		  opcode : in std_logic_vector(3 downto 0);
		  ra_data, rc_data, rb_data: in std_logic_vector(15 downto 0);
		  
		  mem_data_add, mem_data_in : out std_logic_vector(15 downto 0)
		  
		  );
		  
end entity memory;

architecture ma_stage of memory is
	
	signal address, inp : std_logic_vector(15 downto 0);
	
	begin 
			
		load_store: process(rc_data, opcode, ra_data, rb_data)
			
		begin
		
			if(opcode = "0100") then 
				mem_data_add <= rc_data;
			elsif(opcode = "0101") then
				mem_data_add <= rc_data;
				mem_data_in <= ra_data;
			elsif(opcode = "0110") then
				mem_data_add<= rc_data;
			elsif(opcode = "0111") then
				mem_data_add <= rc_data;
				mem_data_in <= rb_data;
			end if;
		end process;



end architecture;
