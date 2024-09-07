library ieee;
use ieee.std_logic_1164.all;

entity single_bit_reg is
	port (d : IN STD_LOGIC;
				wr_en : IN STD_LOGIC;
				clr : IN STD_LOGIC;
				clk : IN STD_LOGIC;

				q : OUT STD_LOGIC);
end single_bit_reg;


architecture description of single_bit_reg is
		begin
			process (clk, clr, wr_en)
			begin
				if clr = '1' then
					q <= '1';
				elsif rising_edge(clk) then
					if wr_en = '1' then
						q <= d;
					end if;
				end if;
			end process;
end description;