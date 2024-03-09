----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/23/2023 06:57:59 AM
-- Design Name: 
-- Module Name: mpg - Behavioral
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

entity mpg is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           enable : out STD_LOGIC);
end mpg;

architecture Behavioral of mpg is
signal q:std_logic_vector(2 downto 0):="000";
signal cnt:std_logic_vector(15 downto 0):=x"0000";
begin
    process (clk)
    begin
       if clk='1' and clk'event then
          cnt <= cnt + 1;
       end if;
    end process;
    
    process(clk)
    begin
        if rising_edge(clk) then
            if cnt = x"ffff" then
                q(2) <= btn;
            end if;
        end if;
    end process;
    
    process(clk)
    begin
        if rising_edge(clk) then
            q(1) <= q(2);
            q(0) <= q(1);
        end if;
    end process;
    
    enable <= q(1) and (not q(0));
end Behavioral;
