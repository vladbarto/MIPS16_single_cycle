library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RAM_comp is
    port ( clk : in std_logic;
        we : in std_logic;
        en : in std_logic;
        addr : in std_logic_vector(7 downto 0);
        di : in std_logic_vector(15 downto 0);
        do : out std_logic_vector(15 downto 0));    
end RAM_comp;

architecture syn of RAM_comp is

type ram_type is array (0 to 15) of std_logic_vector (15 downto 0);
signal RAM: ram_type := (x"0006", x"0006", x"00A3", x"00A4", x"00A5", x"00A6", x"00A7", x"00A8", x"00A9", x"00B1", x"00B2", x"00B3", x"00B4", others => x"0001");

begin
    process (clk)
    begin
        if rising_edge(clk) then
            if en = '1' then
                if we = '1' then
                    RAM(conv_integer(addr)) <= di;
                else
                    do <= RAM( conv_integer(addr));
                end if;
            end if;
        end if;
    end process;
end syn;
