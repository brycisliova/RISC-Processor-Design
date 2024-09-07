library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparator is
	port (opcode: IN STD_LOGIC_VECTOR(3 downto 0); input_a : IN STD_LOGIC_VECTOR(15 downto 0); input_b : IN STD_LOGIC_VECTOR(15 downto 0);
		 output : OUT STD_LOGIC);
end comparator;


architecture description of comparator is
		signal cout: std_logic := '0';
		signal zero: std_logic := '0';
		signal carry: integer;
 		begin
			compare: process(opcode, input_a, input_b, carry, zero, cout) is
                
			begin
                carry <= to_integer(unsigned(input_a)) - to_integer(unsigned(input_b)) ;
                --cout <= '1' when carry < 0 else '0';
					 if(carry < 0) then
					   cout <= '1';
					 else
						cout <= '0';
					end if;	
				
					
					if(input_a = input_b) then
						zero <= '1';
					else 
						zero <= '0';
					end if;	
					 
       		case opcode is
                when "1000" =>
                output <= not (zero);

                when "1001" =>
                output <= cout ;

                when others =>
                output <= cout or (not(zero));
				end case ;
			end process compare;
end description;
