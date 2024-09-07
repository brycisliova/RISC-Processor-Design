library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity forward is
		port( reg_check, ex_add, ma_add, wb_add : in std_logic_vector(2 downto 0);
				ex_reg_data1, ex_reg_data2, ma_reg_data1, ma_reg_data2, ma_reg_data3,ma_reg_data4, wb_reg_data1, wb_reg_data2, wb_reg_data3, wb_reg_data4: in std_logic_vector(15 downto 0);
				ex_opcode, ma_opcode, wb_opcode: in std_logic_vector(3 downto 0);
				
				fwd_reg_val : out std_logic_vector(15 downto 0);
				fwd_en : out std_logic
			);
	end entity forward;

architecture forwarding of forward is

	signal fwd_reg: std_logic_vector(15 downto 0);
	signal fod_en: std_logic := '0';
	
	begin
	
		fwd_reg_val <= fwd_reg;
		fwd_en <= fod_en;
		
		clash: process(ex_opcode, ma_opcode, wb_opcode, ex_reg_data1, ex_reg_data2, ma_reg_data1, ma_reg_data2, ma_reg_data3, ma_reg_data4,wb_reg_data1, wb_reg_data2, wb_reg_data3, wb_reg_data4, ex_add, ma_add, wb_add, reg_check) is
		
		begin
			
			if(reg_check = ex_add) then
				if(ex_opcode = "0001" or ex_opcode = "0010" or ex_opcode = "0000") then
				fwd_reg <= ex_reg_data1;
				fod_en <= '1';
				elsif(ex_opcode = "0011") then
				fwd_reg <= ex_reg_data2;
				fod_en <= '1';
				end if;
			elsif(reg_check = ma_add) then
				if(ma_opcode = "0001" or ma_opcode = "0010" or ma_opcode = "0000") then
				fwd_reg <= ma_reg_data1;
				fod_en <= '1';
				elsif(ma_opcode = "0011") then
				fwd_reg <= ma_reg_data3;
				fod_en <= '1';
				elsif(ma_opcode = "0100" or ma_opcode = "0110") then
				fwd_reg <= ma_reg_data2;
				fod_en <= '1';
				elsif(ma_opcode = "1100" or ma_opcode = "1101") then
				fwd_reg <= ma_reg_data4;
				fod_en <= '1';
				end if;
			elsif(reg_check = wb_add) then
				if(wb_opcode = "0001" or wb_opcode = "0010" or wb_opcode = "0000") then
				fwd_reg <= wb_reg_data1;
				fod_en <= '1';
				elsif(wb_opcode = "0011") then
				fwd_reg <= wb_reg_data2;
				fod_en <= '1';
				elsif(wb_opcode = "0100" or wb_opcode = "0110") then
				fwd_reg <= wb_reg_data3;
				fod_en <= '1';
				elsif(wb_opcode = "1100" or wb_opcode = "1101") then
				fwd_reg <= wb_reg_data4;
				fod_en <= '1';
				end if;
			else 
				fod_en <= '0';
				fwd_reg <= "0000000000000000";
			end if;
		end process;
		

end architecture;
			