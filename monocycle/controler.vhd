library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control is port (
    instruction : in  std_logic_vector (31 downto 0);
    branch      : out std_logic;
    bne         : out std_logic;
    mem_read    : out std_logic;
    mem_to_reg  : out std_logic;
    mem_write   : out std_logic;
    alu_op      : out std_logic_vector (3  downto 0);
    alu_src     : out std_logic;
    reg_write   : out std_logic
);
end control;

architecture arch of control is

    signal opcode  : std_logic_vector (6 downto 0);
    signal funct_3 : std_logic_vector (2 downto 0);
    signal funct_7 : std_logic_vector (6 downto 0);

begin

    opcode  <= instruction (6  downto  0);
    funct_3 <= instruction (14 downto  0);
    funct_7 <= instruction (31 downto 25);

    process (opcode, funct_3, funct_7)
    begin
        case opcode:
            when "0110111" => -- lui
                branch     <= '0';
                bne        <= '0';
                mem_read   <= '0';
                mem_to_reg <= '0';
                mem_write  <= '0';
                alu_op     <= "0000";
                alu_src    <= '1';
                reg_write  <= '1';

end architecture;
