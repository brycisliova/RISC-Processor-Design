library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
    port (
        clk : in std_logic;
        write_enable : in std_logic;
        reset : in std_logic;
        mem_address : in std_logic_vector(15 downto 0);
        mem_data_in : in std_logic_vector(15 downto 0);
        mem_data_out : out std_logic_vector(15 downto 0)
    );
end entity;

architecture desc of ram is
    type memory_array is array (0 to 65535) of std_logic_vector(15 downto 0);
    signal data : memory_array := (others => (others => '0'));
    
begin
    memory_process: process(clk) is
    begin
        if (clk'event and clk = '0') then  
            if (write_enable = '1') then
                data(to_integer(unsigned(mem_address))) <= mem_data_in;
            end if;
        end if;
    end process memory_process;
            
    mem_data_out <= data(to_integer(unsigned(mem_address)));
end architecture desc;