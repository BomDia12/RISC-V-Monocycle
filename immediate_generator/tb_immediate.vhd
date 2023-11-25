entity tb_immediate is end;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

architecture test of tb_immediate is

    component immediate_generator
    port (
        instruction : in  std_logic_vector (31 downto 0);
        immediate   : out signed           (31 downto 0)
    );
    end component;

    -- I/O signals
    signal instruction : std_logic_vector (31 downto 0);
    signal immediate   : signed           (31 downto 0);

    -- Test Instructions
    constant add       : std_logic_vector (31 downto 0) := x"000002b3";
    constant lw        : std_logic_vector (31 downto 0) := x"01002283";
    constant addi      : std_logic_vector (31 downto 0) := x"f9c00313";
    constant xori      : std_logic_vector (31 downto 0) := x"fff2c293";
    constant jalr      : std_logic_vector (31 downto 0) := x"01800067";
    constant srai      : std_logic_vector (31 downto 0) := x"40a3d313";
    constant lui       : std_logic_vector (31 downto 0) := x"00002437";
    constant sw        : std_logic_vector (31 downto 0) := x"02542e23";
    constant bne       : std_logic_vector (31 downto 0) := x"fe5290e3";
    constant jal       : std_logic_vector (31 downto 0) := x"00c000ef";

    -- Expected Immediates
    constant add_imm   : signed           (31 downto 0) := x"00000000";
    constant lw_imm    : signed           (31 downto 0) := x"00000010";
    constant addi_imm  : signed           (31 downto 0) := x"ffffff9c";
    constant xori_imm  : signed           (31 downto 0) := x"ffffffff";
    constant jalr_imm  : signed           (31 downto 0) := x"00000018";
    constant srai_imm  : signed           (31 downto 0) := x"0000000a";
    constant lui_imm   : signed           (31 downto 0) := x"00002000";
    constant sw_imm    : signed           (31 downto 0) := x"0000003c";
    constant bne_imm   : signed           (31 downto 0) := x"ffffffe0";
    constant jal_imm   : signed           (31 downto 0) := x"0000000c";

    -- Time Constant
    constant wait_for : time := 10 ns;

begin

    generator : immediate_generator port map (instruction, immediate);

    test_proc : process
    begin
        instruction <= add;
        wait for wait_for;
        assert immediate = add_imm  report "Erro no imediato da instrução add";
        instruction <= lw;
        wait for wait_for;
        assert immediate = lw_imm   report "Erro no imediato da instrução lw";
        instruction <= addi;
        wait for wait_for;
        assert immediate = addi_imm report "Erro no imediato da instrução addi";
        instruction <= xori;
        wait for wait_for;
        assert immediate = xori_imm report "Erro no imediato da instrução xori";
        instruction <= jalr;
        wait for wait_for;
        assert immediate = jalr_imm report "Erro no imediato da instrução jalr";
        instruction <= srai;
        wait for wait_for;
        assert immediate = srai_imm report "Erro no imediato da instrução srai";
        instruction <= lui;
        wait for wait_for;
        assert immediate = lui_imm  report "Erro no imediato da instrução lui";
        instruction <= sw;
        wait for wait_for;
        assert immediate = sw_imm   report "Erro no imediato da instrução sw";
        instruction <= bne;
        wait for wait_for;
        assert immediate = bne_imm  report "Erro no imediato da instrução bne";
        instruction <= jal;
        wait for wait_for;
        assert immediate = jal_imm  report "Erro no imediato da instrução jal";
    end process;

end test;
