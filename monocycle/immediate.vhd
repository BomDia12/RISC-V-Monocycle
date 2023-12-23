library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity immediate_generator is port (
    instruction : in  std_logic_vector (31 downto 0);
    immediate   : out std_logic_vector (31 downto 0)
);
end immediate_generator;

architecture arch of immediate_generator is

    type FORMAT_RV is ( R_type, I_type, S_type, SB_type, UJ_type, U_type );

    signal opcode           : std_logic_vector (6  downto  0);
    signal final_number     : std_logic_vector (31 downto  0) := x"00000000";

    signal instruction_type : FORMAT_RV;

begin

    opcode <= instruction(6 downto 0);
    -- select instruction type
    type_proc : process (instruction, opcode)
    begin
        case opcode is
            when "0110111" => -- lui
                instruction_type <= U_type;
            when "0010111" => -- auipc
                instruction_type <= U_type;
            when "1101111" => -- jal
                instruction_type <= UJ_type;
            when "1100111" => -- jalr
                instruction_type <= I_type;
            when "1100011" => -- B instructions
                instruction_type <= SB_type;
            when "0000011" => -- load instructions
                instruction_type <= I_type;
            when "0100011" => -- store instructions
                instruction_type <= S_type;
            when "0010011" => -- I instructions
                instruction_type <= I_type;
            when "0011011" => -- R instructions
                instruction_type <= R_type;
            when others    => -- como não é reconhecido, será tratado como se não tiver imediato
                instruction_type <= R_type;
        end case;
    end process;

    imm_proc : process (instruction, instruction_type)
    -- calculate immediate
    begin
        final_number <= x"00000000";
        case instruction_type is
            when I_type =>
                if (instruction(14 downto 12) = "101") then
                    final_number (4  downto 0) <= instruction(24 downto 20);
                    final_number (31 downto 5) <= x"000000" & "000";
                else
                    final_number (11 downto 0) <= instruction(31 downto 20);
                    if (instruction(31) = '1') then
                        final_number (31 downto 12) <= x"fffff";
                    else
                        final_number (31 downto 12) <= x"00000";
                    end if;
                end if;
            when S_type =>
                final_number (11 downto 0) <= instruction (31 downto 25) & instruction (11 downto 7);
                if instruction(31) = '1' then
                    final_number (31 downto 12) <= x"fffff";
                else
                    final_number (31 downto 12) <= x"00000";
                end if;
            when SB_type =>
                final_number (12 downto 0) <= instruction (31) & instruction (7) & instruction (30 downto 25) & instruction (11 downto 8) & '0';
                if instruction(31) = '1' then
                    final_number (31 downto 13) <= x"ffff" & "111";
                else
                    final_number (31 downto 13) <= x"0000" & "000";
                end if;
            when UJ_type =>
                final_number (20 downto 0) <= instruction (20) & instruction (19 downto 12) & instruction (20) & instruction (30 downto 21) & '0';
                if instruction(20) = '1' then
                    final_number (31 downto 21) <= "111" & x"ff";
                else
                    final_number (31 downto 21) <= "000" & x"00";
                end if;
            when U_type =>
                final_number (31 downto 0) <= instruction(31 downto 12) & x"000";
            when others =>
                final_number               <= x"00000000";
        end case;
    end process;

    immediate <= final_number;

end arch;