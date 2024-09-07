library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instr_memory is
    port(
        --16 bit address
        mem_add : in std_logic_vector(15 downto 0);
        --data output from the memory
        mem_instr : out std_logic_vector(15 downto 0)
	);  
end entity instr_memory;

architecture memory_a of instr_memory is
type memory_array is array( 0 to 65535 ) of std_logic_vector(15 downto 0);
signal data : memory_array := ("0001001010011000", others => (others => '1')); --Load with Program

begin
            
    mem_instr <= data(to_integer(unsigned(mem_add)));

end architecture memory_a;