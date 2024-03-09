----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/17/2023 04:25:40 PM
-- Design Name: 
-- Module Name: ROM - Behavioral
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

entity ROM is
    Port ( A : in STD_LOGIC_VECTOR (7 downto 0);
           D : out STD_LOGIC_VECTOR (15 downto 0));
end ROM;

architecture Behavioral of ROM is
    
type reg_array is array (0 to 255) of std_logic_vector(15 downto 0);
signal reg_file : reg_array := (x"0006",                               
                                x"2081",
                                x"0926",
                                x"1B66",
                                x"00A0",
                                x"4181",
                                x"1FF6",
                                x"0CF0",
                                x"1F30",
                                x"8D08",
                                x"08FA",
                                x"1C50",
                                x"1700",
                                x"3694",--x"36FF",
                                x"B403",
                                x"08F0",
                                x"1F20",
                                x"E009",
                                x"00FB",
                                x"6781",
                                x"1C84",
                                x"6402",
                                x"E000",
                                others => x"0000");
begin
    D <= reg_file(conv_integer(A));
end Behavioral;
