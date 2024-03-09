----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/14/2023 07:26:40 PM
-- Design Name: 
-- Module Name: WB_entity - Behavioral
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

entity WB_entity is
    Port ( MemtoReg : in STD_LOGIC;
           PCSrc : out STD_LOGIC;
           beq : in STD_LOGIC;
           bgt : in STD_LOGIC;
           zero : in STD_LOGIC;
           greater : in STD_LOGIC;
           ALURes0 : in STD_LOGIC_VECTOR (15 downto 0);
           MemData1 : in STD_LOGIC_VECTOR (15 downto 0);
           writeBack : out STD_LOGIC_VECTOR (15 downto 0));
end WB_entity;

architecture Behavioral of WB_entity is

begin
    process(MemtoReg)
    begin
        case MemtoReg is
            when '0' => writeBack <= ALURes0;
            when others => writeBack <= MemData1;
        end case;
    end process;
    
    PCSrc <= (beq and zero) or (bgt and greater);

end Behavioral;
