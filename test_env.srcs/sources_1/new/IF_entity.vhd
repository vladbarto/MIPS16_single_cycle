----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/30/2023 02:32:19 PM
-- Design Name: 
-- Module Name: IF_entity - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IF_entity is
    Port ( CLK: in STD_LOGIC;
           reset: in STD_LOGIC;
           writeEn: in STD_LOGIC; --buton trecut prin MPG, valideaza scrierea pe PC
           Jump : in STD_LOGIC;
           PCSrc : in STD_LOGIC;
           JumpAddr : in STD_LOGIC_VECTOR (15 downto 0);
           BranchAddr : in STD_LOGIC_VECTOR (15 downto 0);
           PC_plus_4 : out STD_LOGIC_VECTOR (15 downto 0);
           instr : out STD_LOGIC_VECTOR (15 downto 0) );
end IF_entity;

architecture Behavioral of IF_entity is
--type reg_arr is array (0 to 255) of std_logic_vector(15 downto 0);
--signal ROMmem: reg_arr :=(
--x"0000",
--x"0008",
--x"0005",
--x"0006",
--x"0012",
--others=>x"0000");

signal PCLatch: std_logic_vector(15 downto 0);
signal OUTbranch_16b: std_logic_vector(15 downto 0);
signal OUTjump_16b: std_logic_vector(15 downto 0);
signal PCN_jump: std_logic_vector(15 downto 0);
signal PCN: std_logic_vector(15 downto 0);

component ROM
    Port ( A : in STD_LOGIC_VECTOR (7 downto 0);
           D : out STD_LOGIC_VECTOR (15 downto 0));
end component ROM;

begin
    ET_ROM: ROM port map (PCLatch(7 downto 0), instr);
    
    PROG_COUNTER: process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                PCLatch <= x"0000";
            end if;
            if writeEn = '1' then
                PCLatch <= PCN_Jump;
            end if;        
            PCN <= PCLatch + 1;
        end if;
    end process PROG_COUNTER;
    
    PC_plus_4 <= PCN;
    
    SELECT_PC_SOURCE: process(PCSrc)
    begin
        case PCSrc is
            when '0' => OUTBranch_16b <= PCN;
            when others => OUTBranch_16b <= BranchAddr;
        end case;
    end process SELECT_PC_SOURCE;
    
    SELECT_JUMP: process(Jump)
    begin
        case Jump is
            when '0' => PCN_Jump <= OUTBranch_16b;
            when others => PCN_Jump <= JumpAddr;
        end case;
    end process SELECT_JUMP;
end Behavioral;
