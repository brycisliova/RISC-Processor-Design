library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_hazard is
    port (
        hisbit_out : in std_logic;
        --pc_in : in std_logic_vector(15 downto 0);
		  comparator_op : in std_logic;
        hisbit_in : out std_logic;
		  hazard_bit : out std_logic
        --pc_branch : out std_logic_vector(15 downto 0)
    );
end entity;

architecture desc of control_hazard is

    
begin
    process (hisbit_out, comparator_op) is
    begin
        hisbit_in <= comparator_op ;
        if ((hisbit_out xor comparator_op) = '1') then
            hazard_bit <= '1';
        else
            hazard_bit <= '0' ;
        end if ; 
    end process;
	 
end architecture desc;