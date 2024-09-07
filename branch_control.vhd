library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity branch_cntrl is
	port( hisbit : in std_logic;
			pc_in, inp: in std_logic_vector(15 downto 0);
			
			
			pc_branch, pc_store : out std_logic_vector(15 downto 0)
		);
end entity branch_cntrl;

architecture branch of branch_cntrl is
	
	begin
		
		brch_proc: process(hisbit, pc_in, inp) is
		
		begin
		
			if(hisbit = '0') then
				pc_branch <= pc_in;
				pc_store <= inp;
			else
				pc_branch <= inp;
				pc_store <= pc_in;
			end if;
		end process;		

end architecture;
	