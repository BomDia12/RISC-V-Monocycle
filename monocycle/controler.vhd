library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control is port (
    instruction : in  std_logic_vector (31 downto 0);
    -- 00 -> PC + 4; 01 & zero -> res_alu; 10 & not zero -> res_alu; 11 -> res_alu;
    branch      : out std_logic_vector (1  downto 0);
    mem_read    : out std_logic;
    -- 00 -> ULA; 01 -> data_mem; 10 -> pc + 4; 11 -> lui
    reg_src     : out std_logic_vector (1  downto 0);
    mem_write   : out std_logic;
    alu_op      : out std_logic_vector (3  downto 0);
    -- alu_src(0) -> 0: Registry; 1: Immediate;
    -- alu_src(1) -> 0: Registry; 1: PC;
    alu_src     : out std_logic_vector (1  downto 0);
    reg_write   : out std_logic
);
end control;

architecture arch of control is

    signal opcode  : std_logic_vector (6 downto 0);
    signal funct_3 : std_logic_vector (2 downto 0);

begin

    opcode  <= instruction (6  downto  0);
    funct_3 <= instruction (14 downto 12);

    process (opcode, funct_3)
    begin
        case opcode is
            when "0110111" => -- lui
                branch     <= "00";
                mem_read   <= '0';
                reg_src    <= "11";
                mem_write  <= '0';
                alu_op     <= "0000";
                alu_src    <= "11";
                reg_write  <= '1';
            when "0010111" => -- auipc
                branch     <= "00";
                mem_read   <= '0';
                reg_src    <= "00";
                mem_write  <= '0';
                alu_op     <= "0000";
                alu_src    <= "11";
                reg_write  <= '1';
            when "1101111" => -- jal
                branch     <= "11";
                mem_read   <= '0';
                reg_src    <= "10";
                mem_write  <= '0';
                alu_op     <= "0000";
                alu_src    <= "11";
                reg_write  <= '1';
            when "1100111" => -- jalr
                branch     <= "11";
                mem_read   <= '0';
                reg_src    <= "10";
                mem_write  <= '0';
                alu_op     <= "0000";
                alu_src    <= "11";
                reg_write  <= '1';
            when "1100011" => -- B instruction
                branch     <= "01";
                mem_read   <= '0';
                mem_write  <= '0';
                alu_src    <= "11";
                reg_write  <= '0';
                case funct_3 is
                    when "000" => -- beq
                        alu_op <= "1100";
                    when "001" => -- bne
                        alu_op <= "1101";
                    when "100" => -- blt
                        alu_op <= "1000";
                    when "101" => -- bge
                        alu_op <= "1010";
                    when "110" => -- bltu
                        alu_op <= "1001";
                    when "111" => -- bgeu
                        alu_op <= "1011";
                    when others => alu_op <= "0000";
                end case;
            when "0000011" => -- Load
                branch     <= "00";
                mem_read   <= '1';
                reg_src    <= "01";
                mem_write  <= '0';
                alu_op     <= "0000";
                alu_src    <= "01";
                reg_write  <= '1';
            when "0100011" => -- Store
                branch     <= "00";
                mem_read   <= '0';
                mem_write  <= '1';
                alu_op     <= "0000";
                alu_src    <= "01";
                reg_write  <= '0';
            when "0010011" => -- ULA I instructions
                branch     <= "00";
                mem_read   <= '0';
                reg_src    <= "00";
                mem_write  <= '0';
                alu_src    <= "01";
                reg_write  <= '1';
                case funct_3 is
                    when "000" => -- addi
                        alu_op <= "0000";
                    when "010" => -- slti
                        alu_op <= "1000";
                    when "011" => -- sltiu
                        alu_op <= "1001";
                    when "100" => -- xori
                        alu_op <= "0100";
                    when "110" => -- ori
                        alu_op <= "0011";
                    when "111" => -- andi
                        alu_op <= "0010";
                    when "001" => -- slli
                        alu_op <= "0101";
                    when "101" => 
                        if instruction(30) = '1' then -- srai
                            alu_op <= "0111";
                        else                        -- srli
                            alu_op <= "0110";
                        end if;
                    when others => alu_op <= "0000";
                end case;
            when "0110011" => -- R instructions
                branch     <= "00";
                mem_read   <= '0';
                reg_src    <= "00";
                mem_write  <= '0';
                alu_src    <= "00";
                reg_write  <= '1';
                case funct_3 is
                    when "000" => 
                        if instruction(30) = '1' then -- sub
                            alu_op <= "0001";
                        else                        -- add
                            alu_op <= "0000";
                        end if;
                    when "001" => -- sll
                        alu_op <= "0101";
                    when "010" => -- slt
                        alu_op <= "1000";
                    when "100" => -- xor
                        alu_op <= "0100";
                    when "101" => 
                        if instruction(30) = '1' then -- sra
                            alu_op <= "0111";
                        else                        -- srl
                            alu_op <= "0110";
                        end if;
                    when "110" => -- or
                        alu_op <= "0011";
                    when "111" => -- or
                        alu_op <= "0010";
                    when others => alu_op <= "0000";
                end case;
            when others => alu_op <= "0000";
        end case;
    end process;
end architecture;
