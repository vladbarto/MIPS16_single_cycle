----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/14/2023 07:15:18 PM
-- Design Name: 
-- Module Name: MEM_entity - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MEM_entity is
    Port ( clk: in STD_LOGIC;
           butonEn: in std_logic;
           MemWrite : in STD_LOGIC;
           ALURes : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           MemData : out STD_LOGIC_VECTOR (15 downto 0));
end MEM_entity;

architecture Behavioral of MEM_entity is
type ram_type is array (0 to 31) of std_logic_vector (15 downto 0);
signal RAM: ram_type := (0 => x"0004", 1=> x"0005", 2 => x"0003", others => x"0001");
signal ALURes_temp: STD_LOGIC_VECTOR(15 downto 0);

begin
    ALURes_temp <= ALURes;
    process(clk)
    begin
        if rising_edge(clk) then
            --if butonEn = '1' then
                if MemWrite = '1' then
                    RAM(conv_integer(ALURes_temp(7 downto 0))) <= RD2;
                end if;
            --end if;
        end if;
    end process;
    
    MemData <= RAM(conv_integer(ALURes_temp(7 downto 0)));

end Behavioral;
