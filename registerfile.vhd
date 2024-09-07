library ieee;
use ieee.std_logic_1164.all;

entity regfile is 
    port(
        --to store the register number for each address
        RF_A1 : in std_logic_vector(2 downto 0);
        RF_A2 : in std_logic_vector(2 downto 0);
        RF_A3 : in std_logic_vector(2 downto 0);
        RF_A4 : in std_logic_vector(2 downto 0);
        RF_A5 : in std_logic_vector(2 downto 0);
        RF_D4 : in std_logic_vector(15 downto 0);
        RF_D5 : in std_logic_vector(15 downto 0);
        reset : in std_logic;
        clk : in std_logic;
        writevalue : in std_logic;
		  writePC: in std_logic;
        D1o : out std_logic_vector(15 downto 0);
        D2o : out std_logic_vector(15 downto 0);
        PC : out std_logic_vector(15 downto 0)

    );
end entity;

architecture registers of regfile is    
    signal R0 : std_logic_vector(15 downto 0);
    signal R1 : std_logic_vector(15 downto 0);
    signal R2 : std_logic_vector(15 downto 0);
    signal R3 : std_logic_vector(15 downto 0);
    signal R4 : std_logic_vector(15 downto 0);
    signal R5 : std_logic_vector(15 downto 0);
    signal R6 : std_logic_vector(15 downto 0);
    signal R7 : std_logic_vector(15 downto 0);
	signal D1 : std_logic_vector(15 downto 0);
    signal D2 : std_logic_vector(15 downto 0);
    signal DPC : std_logic_vector(15 downto 0);
begin
   
    write_proc: process(RF_A4, RF_A5, writevalue,clk,reset)
    begin
	     if(reset = '1') then 
            R0 <= "0000000000000000";
            R1 <= "0000000111111000";
            R2 <= "0000000000000111";
            R3 <= "0000000000000000";
            R4 <= "0000000000000000";
            R5 <= "0000000000000000";
            R6 <= "0000000000000000";
            R7 <= "0000000000000000";
        elsif (clk'event and clk = '0') then  --writing at negative clock edge
            if(writevalue = '1') then
                if(RF_A4 = "000") then
                    R0 <= RF_D4;
                end if;
                if(RF_A4 = "001") then
                    R1 <= RF_D4;
                end if;
                if(RF_A4 = "010") then
                    R2 <= RF_D4;
                end if;
                if(RF_A4 = "011") then
                    R3 <= RF_D4;
                end if;
                if(RF_A4 = "100") then
                    R4 <= RF_D4;
                end if;
                if(RF_A4 = "101") then
                    R5 <= RF_D4;
                end if;
                if(RF_A4 = "110") then
                    R6 <= RF_D4;
                end if;
                if(RF_A4 = "111") then
                    R7 <= RF_D4;
                end if;
				elsif(writePC = '1') then
                if(RF_A5 = "000") then
                    R0 <= RF_D5;
                end if;
                if(RF_A5 = "001") then
                    R1 <= RF_D5;
                end if;
                if(RF_A5 = "010") then
                    R2 <= RF_D5;
                end if;
                if(RF_A5 = "011") then
                    R3 <= RF_D5;
                end if;
                if(RF_A5 = "100") then
                    R4 <= RF_D5;
                end if;
                if(RF_A5 = "101") then
                    R5 <= RF_D5;
                end if;
                if(RF_A5 = "110") then
                    R6 <= RF_D5;
                end if;
                if(RF_A5 = "111") then
                    R7 <= RF_D5;
                end if;

            end if;
        end if;
    end process write_proc;

    read_proc: process(RF_A1,RF_A2,RF_A3, R0, R1, R2, R3, R4, R5, R6, R7, D1, D2, DPC)


    begin
            if(RF_A1 = "000") then
                D1 <= R0;
            end if;
            if(RF_A1 = "001") then
                D1 <= R1;
            end if;
            if(RF_A1 = "010") then
                D1 <= R2;
            end if;
            if(RF_A1 = "011") then
                D1 <= R3;
            end if;
            if(RF_A1 = "100") then
                D1 <= R4;
            end if;
            if(RF_A1 = "101") then
                D1 <= R5;
            end if;
            if(RF_A1 = "110") then
                D1 <= R6;
            end if;
            if(RF_A1 = "111") then
                D1 <= R7;
            end if;
            --Address 2
            if(RF_A2 = "000") then
                D2 <= R0;
            end if;
            if(RF_A2 = "001") then
                D2 <= R1;
            end if;
            if(RF_A2 = "010") then
                D2 <= R2;
            end if;
            if(RF_A2 = "011") then
                D2 <= R3;
            end if;
            if(RF_A2 = "100") then
                D2 <= R4;
            end if;
            if(RF_A2 = "101") then
                D2 <= R5;
            end if;
            if(RF_A2 = "110") then
                D2 <= R6;
            end if;
            if(RF_A2 = "111") then
                D2 <= R7;
            end if;
            --PC
            if(RF_A3 = "000") then
                DPC <= R0;
            end if;
            if(RF_A3 = "001") then
                DPC <= R1;
            end if;
            if(RF_A3 = "010") then
                DPC <= R2;
            end if;
            if(RF_A3 = "011") then
                DPC <= R3;
            end if;
            if(RF_A3 = "100") then
                DPC <= R4;
            end if;
            if(RF_A3 = "101") then
                DPC <= R5;
            end if;
            if(RF_A3 = "110") then
                DPC <= R6;
            end if;
            if(RF_A3 = "111") then
                DPC <= R7;
            end if;

            D1o <= D1 ;
	        D2o <= D2 ;
            PC <= DPC ;    
    end process read_proc;
   
PC <= DPC;
end registers;