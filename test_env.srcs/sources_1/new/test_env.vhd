----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/23/2023 06:56:18 AM
-- Design Name: 
-- Module Name: test_env - Behavioral
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
-- NOTA; IMPLEMENTEAZA MEMORIA ROM CU CLK, FA ACTIUNEA DE CITIRE IN FUNCTIE DE CLK
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0); --switch
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is

component mpg
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           enable : out STD_LOGIC);
end component mpg;

component SSD
Port ( digit0 : in STD_LOGIC_VECTOR (3 downto 0);
           digit1 : in STD_LOGIC_VECTOR (3 downto 0);
           digit2 : in STD_LOGIC_VECTOR (3 downto 0);
           digit3 : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end component SSD;

component ROM is
    Port ( A : in STD_LOGIC_VECTOR (7 downto 0);
           D : out STD_LOGIC_VECTOR (15 downto 0));
end component ROM;

component RF is
    port (
        clk : in std_logic;
        ra1 : in std_logic_vector (2 downto 0);
        ra2 : in std_logic_vector (2 downto 0);
        wa : in std_logic_vector (2 downto 0);
        wd : in std_logic_vector (15 downto 0);
        RegWrite: in std_logic;
        wen : in std_logic; --buton trecut prin MPG, valideaza scrierea pe PC
        rd1 : out std_logic_vector (15 downto 0);
        rd2 : out std_logic_vector (15 downto 0)
        );
    end component RF;
    
component RAM_comp is
    port ( clk : in std_logic;
        we : in std_logic;
        en : in std_logic;
        addr : in std_logic_vector(7 downto 0);
        di : in std_logic_vector(15 downto 0);
        do : out std_logic_vector(15 downto 0));    
end component RAM_comp;

component IF_entity
    Port ( CLK: in STD_LOGIC;
           reset: in STD_LOGIC;
           writeEn: in STD_LOGIC; --buton trecut prin MPG, valideaza scrierea pe PC
           Jump : in STD_LOGIC;
           PCSrc : in STD_LOGIC;
           JumpAddr : in STD_LOGIC_VECTOR (15 downto 0);
           BranchAddr : in STD_LOGIC_VECTOR (15 downto 0);
           PC_plus_4 : out STD_LOGIC_VECTOR (15 downto 0);
           instr : out STD_LOGIC_VECTOR (15 downto 0) );
end component IF_entity;

component ID_entity
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
end component ID_entity;

component UC_entity
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
end component UC_entity;

component EX_entity
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
end component EX_entity;


component MEM_entity
    Port ( clk: in STD_LOGIC;
           butonEn: in std_logic;
           MemWrite : in STD_LOGIC;
           ALURes : inout STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           MemData : out STD_LOGIC_VECTOR (15 downto 0));
end component MEM_entity;

component WB_entity
    Port ( MemtoReg : in STD_LOGIC;
           PCSrc : out STD_LOGIC;
           beq : in STD_LOGIC;
           bgt : in STD_LOGIC;
           zero : in STD_LOGIC;
           greater : in STD_LOGIC;
           ALURes0 : in STD_LOGIC_VECTOR (15 downto 0);
           MemData1 : in STD_LOGIC_VECTOR (15 downto 0);
           writeBack : out STD_LOGIC_VECTOR (15 downto 0));
end component WB_entity;
signal en_temp, en_temp2: std_logic:='0';
signal cnt : std_logic_vector(15 downto 0) := x"0000";
signal outssd16: std_logic_vector(15 downto 0);
-- semnale pentru ALU - Lab 2 --
signal selectie_mux_alu : std_logic_vector(1 downto 0) := "00";
signal output_mux_alu : std_logic_vector(15 downto 0) := x"0000";
signal zeroExt1: std_logic_vector(15 downto 0) := x"0000";
signal zeroExt2: std_logic_vector(15 downto 0) := x"0000";
signal zeroExt3: std_logic_vector(15 downto 0) := x"0000";
signal mux_alu_in1: std_logic_vector(15 downto 0) := x"0000";
signal mux_alu_in2: std_logic_vector(15 downto 0) := x"0000";
signal mux_alu_in3: std_logic_vector(15 downto 0) := x"0000";
signal mux_alu_in4: std_logic_vector(15 downto 0) := x"0000";
-- end semnale pentru ALU --

-- semnale pentru ROM --
signal output_rom_16b: std_logic_vector(15 downto 0) := x"0000";
signal generator_addr_8b: std_logic_vector(7 downto 0):=x"00";
-- end semnale pentru ROM --

-- semnale pentru reg_file --
signal adrese_rf_3b: std_logic_vector(2 downto 0):= "000";
signal output_regfile_16b: std_logic_vector(15 downto 0):= x"0000";
signal mpg_enable_2: std_logic := '0';
signal rd1_regfile_16b, rd2_regfile_16b: std_logic_vector(15 downto 0):= x"0000";
-- end semnale pentru reg_file --

-- semnale pentru RAM --
signal output_ram_16b: std_logic_vector(15 downto 0) := x"0000";
signal adrese_ram_8b: std_logic_vector(7 downto 0) := x"00";
signal ram_do: std_logic_vector(15 downto 0) := x"0000";
signal ram_di: std_logic_vector(15 downto 0) := x"ABCD";
-- end semnale pentru RAM --

-- semnale pentru IF (instr fetch) --
signal PC_plus_4 : STD_LOGIC_VECTOR (15 downto 0):= x"0000";
signal instr : STD_LOGIC_VECTOR (15 downto 0):= x"0000";
-- end semnale pentru IF

-- semnale pentru ID (instr decoder) --
signal rd1_id: std_logic_vector (15 downto 0);
signal rd2_id: std_logic_vector (15 downto 0);
signal ext_imm_id: std_logic_vector (15 downto 0);
signal func_id: std_logic_vector (2 downto 0);
signal shift_amount_id: std_logic;
-- end semnale pentru ID

-- semnale pentru UC --
signal RegDst : STD_LOGIC;
signal ExtOp : STD_LOGIC;
signal     ALUSrc : STD_LOGIC;
signal     BranchEQ : STD_LOGIC;
signal     BranchGT : STD_LOGIC;
signal     Jump : STD_LOGIC;
signal     ALUOp : STD_LOGIC_VECTOR (2 downto 0);
signal     MemWrite : STD_LOGIC;
signal     MemtoReg : STD_LOGIC;
signal     RegWrite : STD_LOGIC;
-- end semnale pentru UC

-- semnale pentru EX --
signal Zero, Greater: STD_LOGIC;
signal ALURes, BranchAddr, JumpAddr: STD_LOGIC_VECTOR(15 downto 0);
-- end semnale pentru EX --

-- semnale pentru MEM --
signal MemData: STD_LOGIC_VECTOR(15 downto 0);
-- end semnale pentru MEM --

-- semnale pentru write back --
signal PCSrc: STD_LOGIC;
signal writeBack: STD_LOGIC_VECTOR(15 downto 0);
-- end semnale pentru write back
begin
    
    C_MPG: mpg PORT MAP (clk, btn(1), en_temp);
    --C2: SSD PORT MAP (cnt(3 downto 0), cnt(7 downto 4), cnt(11 downto 8), cnt(15 downto 12), clk, an, cat); -- pentru aplicatia cu SSD + un simplu NUMARATOR
    --C3: SSD PORT MAP (output_mux_alu(3 downto 0), output_mux_alu(7 downto 4), output_mux_alu(11 downto 8), output_mux_alu(15 downto 12), clk, an, cat);
    process (clk) -- NUMARATOR bidirectional
    begin
       if rising_edge(clk) then
          if en_temp='1' then
              if sw(0)='1' then
                 cnt <= cnt + 1;
              else
                 cnt <= cnt - 1;
              end if;
          end if;
       end if;
    end process;
    
    --led <= cnt;
    --an <= btn(3 downto 0);
    --cat <= (others=>'0');
    
    --PARTEA DE ALU--
--    CNT_SEL_MUX_ALU: process (clk)
--    begin
--        if rising_edge(clk) then
--            if en_temp = '1' then
--                selectie_mux_alu <= selectie_mux_alu + 1;
--            end if;
--        end if;
--    end process CNT_SEL_MUX_ALU;
    
--    zeroExt1 <= x"000" & sw(3 downto 0);
--    zeroExt2 <= x"000" & sw(7 downto 4);
--    zeroExt3 <= x"00" & sw(7 downto 0);
    
--    MUX_ALU: process
--    begin   
--        case selectie_mux_alu is
--            when "00" => output_mux_alu <= zeroExt1 + zeroExt2;
--            when "01" => output_mux_alu <= zeroExt1 - zeroExt2;
--            when "10" => output_mux_alu <= zeroExt3(13 downto 0) & "00";
--            when others => output_mux_alu <= "00" & zeroExt3(15 downto 2);
--        end case;
--    end process MUX_ALU;
    
    --ALU_ZERO_DETECTION: process
    --begin
    --    if output_mux_alu = x"0000" then
    --        led(7) <= '1';
    --    else
    --        led(7) <= '0';
    --    end if;    
    --end process ALU_ZERO_DETECTION;
    --END PARTEA DE ALU
    
--    COUNTER_REG_FILE_LAB3: process(clk)
--    begin
--        if rising_edge(clk) then
--            if '1' = en_temp then
--                counter_regfile <= counter_regfile + 1;
--            end if;
--        end if;
--    end process COUNTER_REG_FILE_LAB3;

--  PARTEA DE ROM:
--    process(clk)
--    begin
--        if rising_edge(clk) then
--        if en_temp = '1' then
--            if sw(15) = '1' then
--            generator_addr_8b <= generator_addr_8b + 1;
--            else
--                generator_addr_8b <= generator_addr_8b - 1;
--            end if;
--        end if;
--        end if;
--    end process;
--    C_SSD_ROM: SSD PORT MAP (output_rom_16b(3 downto 0), output_rom_16b(7 downto 4), output_rom_16b(11 downto 8), output_rom_16b(15 downto 12), clk, an, cat);--ssd pentru ROM C3: 
--    C_ROM: ROM PORT MAP(generator_addr_8b, output_rom_16b);
--    led(7 downto 0) <= generator_addr_8b;
--  END PARTEA DE ROM

--    PARTEA DE REGFILE
--    C_btn2: mpg PORT MAP (clk, btn(4), en_temp2);
    --counter care genereaza adrese pentru REGFILE
--    process(clk)
--    begin
--    if rising_edge(clk) then
--        if en_temp = '1' then
--            if sw(15) = '1' then
--                adrese_rf_3b <= adrese_rf_3b + 1;
--            else
--                adrese_rf_3b <= adrese_rf_3b - 1;
--            end if;
--        end if;
--    end if;
--    end process;
    
--    C_SSD_REGFILE: SSD PORT MAP (output_regfile_16b(3 downto 0), output_regfile_16b(7 downto 4), 
--        output_regfile_16b(11 downto 8), output_regfile_16b(15 downto 12), clk, an, cat);
    
--    C_REGFILE: RF PORT MAP (clk, adrese_rf_3b, adrese_rf_3b, adrese_rf_3b, 
--    output_regfile_16b, sw(0), en_temp2, rd1_regfile_16b, rd2_regfile_16b); --in loc de sw(0) (poate) pui mai bine btn(3)
--    led(2 downto 0) <= adrese_rf_3b;
--    led(5) <= en_temp;
--    output_regfile_16b <= rd1_regfile_16b + rd2_regfile_16b;
--    END PARTEA DE REGFILE

--    PARTEA DE RAM:
--    process(clk)
--    begin
--    if rising_edge(clk) then
       
--        if en_temp = '1' then
--            if sw(15) = '1' then
--                adrese_ram_8b <= adrese_ram_8b + 1;
--            else
--                adrese_ram_8b <= adrese_ram_8b - 1;
--            end if;
--        end if;
   
--    end if;
--    end process;
--    C_SSD_RAM: SSD PORT MAP (ram_do(3 downto 0), ram_do(7 downto 4), ram_do(11 downto 8), ram_do(15 downto 12), clk, an, cat);
--    C_RAM: RAM_comp PORT MAP (clk, sw(0), sw(1), adrese_ram_8b, ram_di, ram_do);
--    ram_di <= ram_do(13 downto 0) & "00";
--    led(7 downto 0) <= adrese_ram_8b;
--    END PARTEA DE RAM

-- PARTEA DE INSTRUCTION FETCH (IF)
--    C_IF: IF_entity PORT MAP (clk, sw(0), btn(1), sw(1), sw(2), x"0002", x"0004", PC_plus_4, Instr);
--    C_IF_SSD: SSD PORT MAP(PC_plus_4(3 downto 0), PC_plus_4(7 downto 4), PC_plus_4(11 downto 8), 
--    PC_plus_4(15 downto 12), clk, an, cat);
--    C_IF_SSD: SSD PORT MAP(Instr(3 downto 0), Instr(7 downto 4), Instr(11 downto 8), 
--    Instr(15 downto 12), clk, an, cat);
--    C_btn2: mpg PORT MAP (clk, btn(4), en_temp2);
--    C_IF: IF_entity PORT MAP (clk, en_temp, en_temp2, sw(0), sw(1), x"0002", x"0004", PC_plus_4, Instr);
--    C_IF_SSD: SSD PORT MAP(outssd16(3 downto 0), outssd16(7 downto 4), outssd16(11 downto 8), outssd16(15 downto 12), clk, an, cat);
--    led(7) <= '1'; --ca sa imi marchez dracului sw(7) fizic
--    process(sw(7))
--    begin
--        if sw(7) = '0' then
--            outssd16 <= Instr;
--        else outssd16 <= PC_plus_4;
--        end if;
--   end process;
-- END PARTEA DE INSTRUCTION FETCH (IF)

-- PARTEA DE INSTRUCTION DECODE (ID)
--    C_ID: ID_entity PORT MAP (clk, btn(1), btn(2), btn(3), sw, 
--        x"AC10", rd1_id, rd2_id, ext_imm_id, func_id, shift_amount_id);
--    C_ID_SSD_EXTINDERE: SSD PORT MAP(ext_imm_id(3 downto 0), ext_imm_id(7 downto 4), ext_imm_id(11 downto 8), 
--        ext_imm_id(15 downto 12), clk, an, cat);
--    C_ID_SSD_RD1: SSD PORT MAP(rd1_id(3 downto 0), rd1_id(7 downto 4), rd1_id(11 downto 8), 
--        rd1_id(15 downto 12), clk, an, cat);
--    led(0) <= shift_amount_id;
--    led(3 downto 1) <= func_id;
-- END PARTEA DE INSTRUCTION DECODE (ID)

-- PARTEA DE UNITATE DE CONTROL (UC)
--    C_UC: UC_entity port map (instr(15 downto 13), RegDst, ExtOp, ALUSrc, BranchEQ, BranchGT, Jump, ALUOp, MemWrite, MemtoReg, RegWrite);
-- END PARTEA DE UNITATE DE CONTROL (UC)

-- LABORATOR 6: TESTARE ID + UC
--    C_btn2: mpg PORT MAP (clk, btn(4), en_temp2);
--    C_IF: IF_entity PORT MAP (clk, en_temp, en_temp2, sw(0), sw(1), BranchAddr, JumpAddr, PC_plus_4, Instr);
--    --inainte, BranchAddr era x"0002" in port map, iar JumpAddr era x"0004"
--    C_UC: UC_entity port map (instr(15 downto 13), RegDst, ExtOp, ALUSrc, BranchEQ, BranchGT, Jump, ALUOp, MemWrite, MemtoReg, RegWrite);
--    C_ID: ID_entity PORT MAP (clk, RegWrite, RegDst, ExtOp, instr, x"AC23", RegWrite, rd1_id, rd2_id, ext_imm_id, func_id, shift_amount_id);
--    --inainte, writeBack era output_regfile_16b
--    output_regfile_16b <= rd1_id + rd2_id;
--    led(7 downto 5) <= "111"; --ca sa imi marchez sw(7..5) fizic
--    C_IF_SSD: SSD PORT MAP(outssd16(3 downto 0), outssd16(7 downto 4), outssd16(11 downto 8), outssd16(15 downto 12), clk, an, cat);
--    process(sw(7 downto 5))
--    begin
--        case sw(7 downto 5) is
--            when "000" => outssd16 <= instr;
--            when "001" => outssd16 <= PC_plus_4;
--            when "010" => outssd16 <= rd1_id;
--            when "011" => outssd16 <= rd2_id;
--            when "100" => outssd16 <= output_regfile_16b;
--            when "101" => outssd16 <= ext_imm_id;
--            when others => outssd16 <= x"AAEE";
--        end case;
--   end process;
-- END LABORATOR 6

-- LABORATOR 7
    C_btn2: mpg PORT MAP (clk, btn(4), en_temp2);
    C_IF: IF_entity PORT MAP (clk, en_temp, en_temp2, Jump, PCSrc, JumpAddr, BranchAddr, PC_plus_4, instr);
    --inainte, BranchAddr era x"0002" in port map, iar JumpAddr era x"0004"
    C_UC: UC_entity port map (instr(15 downto 13), RegDst, ExtOp, ALUSrc, BranchEQ, BranchGT, Jump, ALUOp, MemWrite, MemtoReg, RegWrite);
    C_ID: ID_entity PORT MAP (clk, RegWrite, RegDst, ExtOp, instr, writeBack, RegWrite, rd1_id, rd2_id, ext_imm_id, func_id, shift_amount_id);
--led(7 downto 5) <= "111"; --ca sa imi marchez sw(7..5) fizic
    C_SSD: SSD PORT MAP(outssd16(3 downto 0), outssd16(7 downto 4), outssd16(11 downto 8), outssd16(15 downto 12), clk, an, cat);
    C_EX: EX_entity PORT MAP (PC_plus_4, rd1_id, rd2_id, ALUSrc, ext_imm_id, shift_amount_id, func_id, ALUOp, Zero, ALURes, Greater, BranchAddr);
    C_MEM: MEM_entity PORT MAP (clk, en_temp2, MemWrite, ALURes, rd2_id, MemData);
    C_WB: WB_entity PORT MAP (MemtoReg, PCSrc, BranchEQ, BranchGT, Zero, Greater, ALURes, MemData, writeBack);
    REZOLVAT_JUMP_ADDRESS_AICI: JumpAddr <= PC_plus_4(15 downto 13) & instr(12 downto 0); --la dimensiuni, exceptand, instr, am mers la buleala
    --REZOLVAT BRANCH TARGET ADDRESS AICI; Rezolvata in EX_entity
    process(sw(2 downto 0))
    begin
        case sw(2 downto 0) is
            when "000" => outssd16 <= instr;
            when "001" => outssd16 <= PC_plus_4;
            when "010" => outssd16 <= rd1_id;
            when "011" => outssd16 <= rd2_id;
            when "100" => outssd16 <= ext_imm_id;
            when "101" => outssd16 <= ALURes;
            when "110" => outssd16 <= MemData;
            when others => outssd16 <= writeBack;
        end case;
   end process;
--   led(15 downto 13) <= instr(12 downto 10); -- RS
--   led(11 downto 9) <= instr(9 downto 7); -- RT
--   led(2 downto 0) <= instr(6 downto 4); -- RD (daca e cazul)
--  verific semnalele emise de UC
--    led(15) <= RegDst;
--    led(14) <= ExtOp;
--    led(13) <= ALUSrc;
--    led(12 downto 11) <= BranchEQ & BranchGT;
--    led(10) <= Jump;
--    led(9) <= MemWrite;
--    led(8) <= MemtoReg;
--    led(7) <= RegWrite;
--    led(2 downto 0) <= ALUOp;

    led <= writeBack;
    --led <= JumpAddr;
-- END LABORATOR 7
end Behavioral;
