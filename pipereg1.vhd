library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stage12 is
	port(clk, reset, wr_en, flush : in std_logic;
		  ir_in, pc_in1, pc_in2 : in std_logic_vector(15 downto 0);
		  
		  ir_out, pc_out1, pc_out2 : out std_logic_vector(15 downto 0));
end entity stage12;

architecture pipereg1 of stage12 is
	begin
	update_pipe1: process(clk, reset, wr_en, ir_in, pc_in1, pc_in2) is
	begin
		
		if(reset = '1') then
			ir_out <= "0000000000000000";
			pc_out1 <= "0000000000000000";
			pc_out2 <= "0000000000000000";
		elsif(clk'event and clk = '0' and flush = '1') then
			ir_out <= "0000000000000000";
			pc_out1 <= "0000000000000000";
			pc_out2 <= "0000000000000000";
		elsif(clk'event and clk = '0' and wr_en = '1') then
			ir_out <= ir_in;
			pc_out1 <= pc_in1;
			pc_out2 <= pc_in2;
		
			
		end if;
	end process;

end architecture;
		  