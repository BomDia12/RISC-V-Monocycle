entity tb_alu is end;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture test of tb_alu is

    -- Opcode constants
    constant add      : std_logic_vector (3  downto 0) := "0000";
    constant sub      : std_logic_vector (3  downto 0) := "0001";
    constant and_o    : std_logic_vector (3  downto 0) := "0010";
    constant or_o     : std_logic_vector (3  downto 0) := "0011";
    constant xor_o    : std_logic_vector (3  downto 0) := "0100";
    constant sll_o    : std_logic_vector (3  downto 0) := "0101";
    constant srl_o    : std_logic_vector (3  downto 0) := "0110";
    constant sra_o    : std_logic_vector (3  downto 0) := "0111";
    constant slt      : std_logic_vector (3  downto 0) := "1000";
    constant sltu     : std_logic_vector (3  downto 0) := "1001";
    constant sge      : std_logic_vector (3  downto 0) := "1010";
    constant sgeu     : std_logic_vector (3  downto 0) := "1011";
    constant seq      : std_logic_vector (3  downto 0) := "1100";
    constant sne      : std_logic_vector (3  downto 0) := "1101";

    -- Add test values
    -- f0 + 0f = ff
    constant add_a1   : std_logic_vector (31 downto 0) := x"0000" & x"00f0";
    constant add_b1   : std_logic_vector (31 downto 0) := x"0000" & x"000f";
    constant add_r1   : std_logic_vector (31 downto 0) := x"0000" & x"00ff";
    constant add_z1   : std_logic                      := '0';
    -- 6000 + (-6000) = 0
    constant add_a2   : std_logic_vector (31 downto 0) := x"0000" & x"1770";
    constant add_b2   : std_logic_vector (31 downto 0) := x"ffff" & x"e890";
    constant add_r2   : std_logic_vector (31 downto 0) := x"0000" & x"0000";
    constant add_z2   : std_logic                      := '1';
    -- 243 + (-2) = 241
    constant add_a3   : std_logic_vector (31 downto 0) := x"0000" & x"00f3";
    constant add_b3   : std_logic_vector (31 downto 0) := x"ffff" & x"fffe";
    constant add_r3   : std_logic_vector (31 downto 0) := x"0000" & x"00f1";
    constant add_z3   : std_logic                      := '0';

    -- Sub test values
    -- f0 - 0f = e1
    constant sub_a1   : std_logic_vector (31 downto 0) := x"0000" & x"00f0";
    constant sub_b1   : std_logic_vector (31 downto 0) := x"0000" & x"000f";
    constant sub_r1   : std_logic_vector (31 downto 0) := x"0000" & x"00e1";
    constant sub_z1   : std_logic                      := '0';
    -- 6000 - 6000 = 0
    constant sub_a2   : std_logic_vector (31 downto 0) := x"0000" & x"1770";
    constant sub_b2   : std_logic_vector (31 downto 0) := x"0000" & x"1770";
    constant sub_r2   : std_logic_vector (31 downto 0) := x"0000" & x"0000";
    constant sub_z2   : std_logic                      := '1';
    -- 243 - (-2) = 245
    constant sub_a3   : std_logic_vector (31 downto 0) := x"0000" & x"00f3";
    constant sub_b3   : std_logic_vector (31 downto 0) := x"ffff" & x"fffe";
    constant sub_r3   : std_logic_vector (31 downto 0) := x"0000" & x"00f5";
    constant sub_z3   : std_logic                      := '0';

    -- Input signals
    signal a, b       : std_logic_vector (31 downto 0);
    signal opcode     : std_logic_vector (3  downto 0);

    -- Output signals
    signal res        : std_logic_vector (31 downto 0);
    signal zero       : std_logic;

    -- time interval
    constant interval : time                           := 5 ns;

    -- component declaration
    component alu port (
        opcode : in  std_logic_vector (3  downto 0);
        a, b   : in  std_logic_vector (31 downto 0);
        res    : out std_logic_vector (31 downto 0);
        zero   : out std_logic
    );
    end component;

begin

    -- component instance
    arith : alu port map (opcode, a, b, res, zero);

    -- testing process
    process
    begin
        -- add tests
        opcode <= add;
        a      <= add_a1;
        b      <= add_b1;
        wait for interval;
        assert res  = add_r1 report "Erro no res teste add 1";
        assert zero = add_z1 report "Erro no res teste add 1";
        a      <= add_a2;
        b      <= add_b2;
        wait for interval;
        assert res  = add_r2 report "Erro no res teste add 2";
        assert zero = add_z2 report "Erro no res teste add 2";
        a      <= add_a3;
        b      <= add_b3;
        wait for interval;
        assert res  = add_r3 report "Erro no res teste add 3";
        assert zero = add_z3 report "Erro no res teste add 3";
        -- sub tests
        opcode <= sub;
        a      <= sub_a1;
        b      <= sub_b1;
        wait for interval;
        assert res  = sub_r1 report "Erro no res teste sub 1";
        assert zero = sub_z1 report "Erro no res teste sub 1";
        a      <= sub_a2;
        b      <= sub_b2;
        wait for interval;
        assert res  = sub_r2 report "Erro no res teste sub 2";
        assert zero = sub_z2 report "Erro no res teste sub 2";
        a      <= sub_a3;
        b      <= sub_b3;
        wait for interval;
        assert res  = sub_r3 report "Erro no res teste sub 3";
        assert zero = sub_z3 report "Erro no res teste sub 3";
    end process;

end architecture;