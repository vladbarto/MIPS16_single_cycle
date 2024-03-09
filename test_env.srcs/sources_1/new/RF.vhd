----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/23/2023 07:20:37 AM
-- Design Name: 
-- Module Name: RF - Behavioral
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
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity RF is
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
    end RF; -- reg_file adica
architecture Behavioral of RF is
type reg_array is array (0 to 15) of std_logic_vector(15 downto 0);
signal reg_file : reg_array := (0 => x"0000", 1 => x"0003", 2 => x"0009", 3=> x"0002", 4 => x"0003", others => x"0000");--(x"0001", x"0003", x"0005", x"0007", x"0009", x"0011", x"0013", x"0015", x"0017", x"0019", x"0021", x"0023", x"0025", others => x"A000");
begin
    process(clk)
    begin
        if rising_edge(clk) then
            --if wen = '1' then
                if RegWrite = '1' then
                    reg_file(conv_integer(wa)) <= wd;
                end if;
            --end if;
        end if;
    end process;
    
    rd1 <= reg_file(conv_integer(ra1));
    rd2 <= reg_file(conv_integer(ra2));
    end Behavioral;
