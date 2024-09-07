LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity clock_generator is
	port (clk_out, rst : out std_logic);
end entity clock_generator;

architecture bhv of clock_generator is
signal clk : std_logic := '0';
signal reset : std_logic := '1' ;
constant clk_period : time := 20 ns;
begin
	rst <= reset;
	reset <= '0' after 30ns;
	clk_out <= clk;
	clk <= not clk after clk_period/2 ;
end bhv;