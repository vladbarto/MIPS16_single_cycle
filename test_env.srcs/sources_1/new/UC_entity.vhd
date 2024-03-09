----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/06/2023 05:11:20 PM
-- Design Name: 
-- Module Name: UC_entity - Behavioral
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

entity UC_entity is
    Port ( opcode : in STD_LOGIC_VECTOR (2 downto 0); --pe intrare, aici, va fi opCode
           RegDst : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           BranchEQ : out STD_LOGIC;
           BranchGT : out STD_LOGIC;
           Jump : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR (2 downto 0);--trebe 3 biti
           MemWrite : out STD_LOGIC;
           MemtoReg : out STD_LOGIC;
           RegWrite : out STD_LOGIC);
end UC_entity;

architecture Behavioral of UC_entity is

begin
    process(opcode)
    begin
        RegDst <= '0';
        RegWrite <= '0';
        ALUSrc <= '0';
        ALUOp <= opcode;
        BranchEQ <= '0';
        BranchGT <= '0';
        Jump <= '0';
        MemWrite <= '0';
        MemtoReg <= '0';
        ExtOp <= '0';
        case opcode is --cand opcode este:
            ---000 tip R:
            when "000" => --avem instructiune de tip R
                        --pe ALUOp va merge codul Function   
                            RegDst   <= '1';
                            RegWrite <= '1';
                            
            ---001 ADDI (de tip I):
            when "001" =>   RegWrite <= '1';
                            ALUSrc   <= '1';    
                            ExtOp    <= '1';
                   
            ---010 LW (de tip I): 
            when "010" =>   ALUSrc   <= '1';
                            ExtOp    <= '1';
                            RegWrite <= '1';
                            MemtoReg <= '1';
                            --ALUOp <=    "00";--sa fie aferent lui LW (in alu fac +)
            
            ---011 SW (de tip I):
            when "011" =>   ALUSrc   <= '1';
                            MemWrite <= '1';
                            ExtOp    <= '1';
            
            ---100 BEQ (de tip I) Branch on Equals
            when "100" =>   BranchEQ <= '1';
                            ExtOp    <= '1';  
                            
            --101 BGT (de tip I) Branch on Greater
            when "101" =>   BranchGT <= '1';
                            ExtOp    <= '1';
            
            ---111 JUMP (J)
            when "111" =>   Jump <= '1';
            when others => ExtOp <= '0';
        end case;
    end process;
end Behavioral;