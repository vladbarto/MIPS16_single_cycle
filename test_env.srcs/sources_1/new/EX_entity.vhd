----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/14/2023 06:32:37 PM
-- Design Name: 
-- Module Name: EX_entity - Behavioral
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

entity EX_entity is
    Port ( PCN : in STD_LOGIC_VECTOR (15 downto 0);
           RD1 : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           ALUSrc: in STD_LOGIC;
           Ext_Imm : in STD_LOGIC_VECTOR (15 downto 0);
           sa : in STD_LOGIC;
           func : in STD_LOGIC_VECTOR (2 downto 0);
           ALUOp : in STD_LOGIC_VECTOR (2 downto 0);
           Zero : out STD_LOGIC;
           ALURes : out STD_LOGIC_VECTOR (15 downto 0);
           Greater : out STD_LOGIC;
           BranchAddr: out STD_LOGIC_VECTOR(15 downto 0));
end EX_entity;

architecture Behavioral of EX_entity is
signal ALUCtrl: STD_LOGIC_VECTOR(2 downto 0) := "000";
signal aluA, aluB: STD_LOGIC_VECTOR(15 downto 0);
begin
    ALU_CONTROL: process(ALUOp)
    begin
        case ALUOp is
            when "000" => ALUCtrl <= Func;
            when "001" => --001 = addi
                  ALUCtrl <= "000"; ---000 pentru ALU = adunare
            when "010" => --010 = lw
                  ALUCtrl <= "000";
            when "011" => --011 = sw
                  ALUCtrl <= "000";
            when "100" => --100 = beq
                  ALUCtrl <= "001";--m-ar duce in AND"100";
            when "101" => --101 = bgt
                  ALUCtrl <= "101";
            when "111" => --111 = j
                  ALUCtrl <= "111";
            when others => ALUCtrl <= "000";  
        end case;
    end process ALU_CONTROL;
    
    INPUT_B_ALU: process(ALUSrc)
    begin
        case ALUSrc is
            when '0' => aluB <= RD2;
            when others => aluB <= Ext_Imm;
        end case;
    end process INPUT_B_ALU;
    
    ALU: process(ALUCtrl)
    begin
    aluA <= RD1;
        case ALUCtrl is
            when "000" => ALURes <= aluA + aluB; --000 = adunare
            when "001" => ALURes <= aluA - aluB; --001 = scadere
                          if aluA - aluB = x"0000" then
                            Zero <= '1';
                           end if;
            when "010" => if sa = '1' then --010 = shiftare logica stanga
                            ALURes <= aluA(14 downto 0) & '0';
                          end if;
            when "011" => if sa = '1' then --011 = shiftare logica dreapta
                            ALURes <= '0' & aluA(15 downto 1);
                          end if;
            when "100" => --100 = and
                            ALURes <= aluA and aluB;
            --100 = branch equal
--                           if aluA = aluB then
--                                Zero <= '1';
--                            end if;
            
            when "101" => --101 = branch greater
                            if aluA > aluB then
                                Greater <= '1';
                            end if;
            when "110" => --110 = xor
                            ALURes <= aluA xor aluB;
            when others => Zero <= '0'; Greater <= '0'; ALURes <= x"AC23";                
        end case;
    end process ALU;
    
    ADRESA_SALT_CONDITIONAT: BranchAddr <= PCN + Ext_Imm;
end Behavioral;
