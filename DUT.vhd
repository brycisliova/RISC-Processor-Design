library ieee;
use ieee.std_logic_1164.all;

entity DUT is
   port(input_vector: in std_logic_vector(1 downto 0);
       	output_vector: out std_logic_vector(0 downto 0));
end entity;

architecture DutWrap of DUT is
	component pipeline is
		port(rst_main, clk_main : in std_logic;
			  output : out std_logic);
	end component;

	begin
		add_instance: pipeline
			port map(
				rst_main => input_vector(1),
				clk_main => input_vector(0),
				output => output_vector(0)
			);

end DutWrap;