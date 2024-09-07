library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fetch is
	port(branch_id, branch_rr : in std_logic;
		  pc_in, pc_branch_id,pc_branch_rr : in std_logic_vector(15 downto 0);
		  
		  ir, pc_out,pc_next : out std_logic_vector(15 downto 0)
		  );
end entity fetch;
------
architecture if_stage of fetch is

------------------component := instruction memory-------------------	
	component instr_memory is
		port(mem_add: in std_logic_vector(15 downto 0);
			  
			  mem_instr: out std_logic_vector(15 downto 0));
	end component instr_memory;

-------------------component := ALU---------------------------------	
	component alu is
		port(
			alu_A: in std_logic_vector(15 downto 0);
			alu_B: in std_logic_vector(15 downto 0);
			Cin: in std_logic;
			sel: in std_logic;
			enable: in std_logic;
			alu_out: out std_logic_vector(15 downto 0);
			Cout: out std_logic;
			Z: out std_logic);
	end component alu;
-----------------------------------------------------------------------	
	signal pc_alu: std_logic_vector(15 downto 0);
	signal pc: std_logic_vector(15 downto 0);
	signal instr: std_logic_vector(15 downto 0);
------------------------------------------------------------------------	
	
	begin
	-----------
		ir_update: instr_memory port map(mem_add => pc, mem_instr => instr);
		alu_pc   : alu port map(alu_A => pc, alu_B => "0000000000000010", sel => '0', enable => '0',Cin => '0', alu_out => pc_alu);
	-----------	
		pc_out <= pc;
		pc_next <= pc_alu;
		ir <= instr;
	------------
		pc_update: process(branch_id, pc_branch_id,branch_rr, pc_branch_rr, pc_in)
		
		begin
		
			if(branch_rr = '1') then	--our first priority is branch from rr stage
				pc <= pc_branch_rr;
			elsif(branch_id = '1') then--our second priority is branch from id stage
				pc <= pc_branch_id;
			else								--last priority is the input from reg file
				pc <= pc_in;				
			end if;
		end process;
	-------------	
		

end architecture;
