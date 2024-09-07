library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity complementor is
	port(complementor_in: in std_logic_vector(15 downto 0);
		  comp_enable: in std_logic;
		  complementor_out: out std_logic_vector(15 downto 0)
	);
		  
end entity complementor;

architecture arch of complementor is
	
	begin
		comp_proc: process (complementor_in, comp_enable) is
			begin
			if(comp_enable = '1') then
				for i in 0 to 15 loop
					complementor_out(i) <= not complementor_in(i) ;
					
				end loop;
			end if;
			
		end process;	
				

end architecture;