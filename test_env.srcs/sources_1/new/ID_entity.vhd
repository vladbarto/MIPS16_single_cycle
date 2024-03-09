----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/06/2023 04:40:02 PM
-- Design Name: 
-- Module Name: ID_entity - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ID_entity is
    Port ( clk : in STD_LOGIC;
           RegWrite : in STD_LOGIC;
           RegDst : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           instr : in STD_LOGIC_VECTOR (15 downto 0);
           WD : in STD_LOGIC_VECTOR (15 downto 0);
           wen: in STD_LOGIC; --buton trecut prin MPG, valideaza scrierea pe PC
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : out STD_LOGIC_VECTOR (15 downto 0);
           func : out STD_LOGIC_VECTOR (2 downto 0);
           sa : out STD_LOGIC);
end ID_entity;

architecture Behavioral of ID_entity is

component RF
    port (
        clk : in std_logic;
        ra1 : in std_logic_vector (2 downto 0);
        ra2 : in std_logic_vector (2 downto 0);
        wa : in std_logic_vector (2 downto 0);
        wd : in std_logic_vector (15 downto 0);
        RegWrite: in std_logic;
        wen : in std_logic;
        rd1 : out std_logic_vector (15 downto 0);
        rd2 : out std_logic_vector (15 downto 0)
        );
end component RF; -- reg_file adica

signal WA_IN: std_logic_vector(2 downto 0);
signal RD1_temp, RD2_temp: std_logic_vector(15 downto 0);
begin
    MUX_WA: process(RegDst)
    begin
        case RegDst is
            when '0' => WA_IN <= instr(9 downto 7);
            when others => WA_IN <= instr(6 downto 4);
        end case;
    end process MUX_WA; --WA = write address
    
    EXTINDERE: process (ExtOp)
    begin
        case ExtOp is
            when '0' => Ext_Imm <= '0' & x"00" & instr(6 downto 0);
            when others => if instr(6) = '0' then
                                Ext_Imm <= '0' & x"00" & instr(6 downto 0);
                           else Ext_Imm <= '1' & x"ff" & instr(6 downto 0);
                           end if;
        end case;
    end process EXTINDERE;
    
    Label_RF: RF port map (clk, instr(12 downto 10), instr(9 downto 7), WA_IN, WD, RegWrite, wen, RD1_temp, RD2_temp);
    RD1 <= RD1_temp;
    RD2 <= RD2_temp;
    
    SHIFT_AMOUNT: sa <= instr(3);
    FUNC_CODE: func <= instr(2 downto 0);
end Behavioral;
