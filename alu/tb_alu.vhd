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

    -- And test values
    constant and_a1   : std_logic_vector (31 downto 0) := x"abcd" & x"ef01";
    constant and_b1   : std_logic_vector (31 downto 0) := x"0000" & x"ffff";
    constant and_r1   : std_logic_vector (31 downto 0) := x"0000" & x"ef01";
    constant and_z1   : std_logic                      := '0';
    constant and_a2   : std_logic_vector (31 downto 0) := x"1234" & x"5678";
    constant and_b2   : std_logic_vector (31 downto 0) := x"0000" & x"0000";
    constant and_r2   : std_logic_vector (31 downto 0) := x"0000" & x"0000";
    constant and_z2   : std_logic                      := '1';
    constant and_a3   : std_logic_vector (31 downto 0) := x"1234" & x"5678";
    constant and_b3   : std_logic_vector (31 downto 0) := x"ffff" & x"ffff";
    constant and_r3   : std_logic_vector (31 downto 0) := x"1234" & x"5678";
    constant and_z3   : std_logic                      := '0';

    -- Or test values
    constant or_a1   : std_logic_vector (31 downto 0) := x"abcd" & x"ef01";
    constant or_b1   : std_logic_vector (31 downto 0) := x"0000" & x"ffff";
    constant or_r1   : std_logic_vector (31 downto 0) := x"abcd" & x"ffff";
    constant or_z1   : std_logic                      := '0';
    constant or_a2   : std_logic_vector (31 downto 0) := x"0000" & x"0000";
    constant or_b2   : std_logic_vector (31 downto 0) := x"0000" & x"0000";
    constant or_r2   : std_logic_vector (31 downto 0) := x"0000" & x"0000";
    constant or_z2   : std_logic                      := '1';
    constant or_a3   : std_logic_vector (31 downto 0) := x"1234" & x"5678";
    constant or_b3   : std_logic_vector (31 downto 0) := x"ffff" & x"ffff";
    constant or_r3   : std_logic_vector (31 downto 0) := x"ffff" & x"ffff";
    constant or_z3   : std_logic                      := '0';

    -- Xor test values
    constant xor_a1   : std_logic_vector (31 downto 0) := x"abcd" & x"ef01";
    constant xor_b1   : std_logic_vector (31 downto 0) := x"0000" & x"ffff";
    constant xor_r1   : std_logic_vector (31 downto 0) := x"abcd" & x"10fe";
    constant xor_z1   : std_logic                      := '0';
    constant xor_a2   : std_logic_vector (31 downto 0) := x"ffff" & x"ffff";
    constant xor_b2   : std_logic_vector (31 downto 0) := x"ffff" & x"ffff";
    constant xor_r2   : std_logic_vector (31 downto 0) := x"0000" & x"0000";
    constant xor_z2   : std_logic                      := '1';
    constant xor_a3   : std_logic_vector (31 downto 0) := x"1234" & x"5678";
    constant xor_b3   : std_logic_vector (31 downto 0) := x"ffff" & x"ffff";
    constant xor_r3   : std_logic_vector (31 downto 0) := x"edcb" & x"a987";
    constant xor_z3   : std_logic                      := '0';

    -- sll test values
    -- abcdef01 << 4
    constant sll_a1   : std_logic_vector (31 downto 0) := x"abcd" & x"ef01";
    constant sll_b1   : std_logic_vector (31 downto 0) := x"0000" & x"0004";
    constant sll_r1   : std_logic_vector (31 downto 0) := x"bcde" & x"f010";
    constant sll_z1   : std_logic                      := '0';
    -- ffff ffff << 32
    constant sll_a2   : std_logic_vector (31 downto 0) := x"ffff" & x"ffff";
    constant sll_b2   : std_logic_vector (31 downto 0) := x"0000" & x"0020";
    constant sll_r2   : std_logic_vector (31 downto 0) := x"0000" & x"0000";
    constant sll_z2   : std_logic                      := '1';
    -- 0000 ffff << 16
    constant sll_a3   : std_logic_vector (31 downto 0) := x"0000" & x"ffff";
    constant sll_b3   : std_logic_vector (31 downto 0) := x"0000" & x"0010";
    constant sll_r3   : std_logic_vector (31 downto 0) := x"ffff" & x"0000";
    constant sll_z3   : std_logic                      := '0';

    -- srl test values
    -- abcd ef01 >> 4
    constant srl_a1   : std_logic_vector (31 downto 0) := x"abcd" & x"ef01";
    constant srl_b1   : std_logic_vector (31 downto 0) := x"0000" & x"0004";
    constant srl_r1   : std_logic_vector (31 downto 0) := x"0abc" & x"def0";
    constant srl_z1   : std_logic                      := '0';
    -- ffff ffff >> 32
    constant srl_a2   : std_logic_vector (31 downto 0) := x"ffff" & x"ffff";
    constant srl_b2   : std_logic_vector (31 downto 0) := x"0000" & x"0020";
    constant srl_r2   : std_logic_vector (31 downto 0) := x"0000" & x"0000";
    constant srl_z2   : std_logic                      := '1';
    -- ffff 0000 >> 16
    constant srl_a3   : std_logic_vector (31 downto 0) := x"ffff" & x"0000";
    constant srl_b3   : std_logic_vector (31 downto 0) := x"0000" & x"0010";
    constant srl_r3   : std_logic_vector (31 downto 0) := x"0000" & x"ffff";
    constant srl_z3   : std_logic                      := '0';

    -- sra test values
    -- abcd ef01 >> 4
    constant sra_a1   : std_logic_vector (31 downto 0) := x"abcd" & x"ef01";
    constant sra_b1   : std_logic_vector (31 downto 0) := x"0000" & x"0004";
    constant sra_r1   : std_logic_vector (31 downto 0) := x"fabc" & x"def0";
    constant sra_z1   : std_logic                      := '0';
    -- ffff ffff >> 32
    constant sra_a2   : std_logic_vector (31 downto 0) := x"ffff" & x"ffff";
    constant sra_b2   : std_logic_vector (31 downto 0) := x"0000" & x"0020";
    constant sra_r2   : std_logic_vector (31 downto 0) := x"ffff" & x"ffff";
    constant sra_z2   : std_logic                      := '0';
    -- 0000 ff00 >> 16
    constant sra_a3   : std_logic_vector (31 downto 0) := x"0000" & x"ff00";
    constant sra_b3   : std_logic_vector (31 downto 0) := x"0000" & x"0010";
    constant sra_r3   : std_logic_vector (31 downto 0) := x"0000" & x"0000";
    constant sra_z3   : std_logic                      := '1';

    -- slt test values
    -- abcd ef01 < 0fff ffff
    constant slt_a1   : std_logic_vector (31 downto 0) := x"abcd" & x"ef01";
    constant slt_b1   : std_logic_vector (31 downto 0) := x"0fff" & x"ffff";
    constant slt_r1   : std_logic_vector (31 downto 0) := x"0000" & x"0001";
    constant slt_z1   : std_logic                      := '0';
    -- ffff ffff < 8000 0000
    constant slt_a2   : std_logic_vector (31 downto 0) := x"ffff" & x"ffff";
    constant slt_b2   : std_logic_vector (31 downto 0) := x"8000" & x"0000";
    constant slt_r2   : std_logic_vector (31 downto 0) := x"0000" & x"0000";
    constant slt_z2   : std_logic                      := '1';
    -- 0000 ffff < 7fff 0000
    constant slt_a3   : std_logic_vector (31 downto 0) := x"0000" & x"ffff";
    constant slt_b3   : std_logic_vector (31 downto 0) := x"7fff" & x"0000";
    constant slt_r3   : std_logic_vector (31 downto 0) := x"0000" & x"0001";
    constant slt_z3   : std_logic                      := '0';

    -- sltu test values
    -- abcd ef01 < 0fff ffff
    constant sltu_a1   : std_logic_vector (31 downto 0) := x"abcd" & x"ef01";
    constant sltu_b1   : std_logic_vector (31 downto 0) := x"0fff" & x"ffff";
    constant sltu_r1   : std_logic_vector (31 downto 0) := x"0000" & x"0000";
    constant sltu_z1   : std_logic                      := '1';
    -- ffff ffff < 8000 0000
    constant sltu_a2   : std_logic_vector (31 downto 0) := x"ffff" & x"ffff";
    constant sltu_b2   : std_logic_vector (31 downto 0) := x"8000" & x"0000";
    constant sltu_r2   : std_logic_vector (31 downto 0) := x"0000" & x"0000";
    constant sltu_z2   : std_logic                      := '1';
    -- 0000 ffff < 7fff 0000
    constant sltu_a3   : std_logic_vector (31 downto 0) := x"0000" & x"ffff";
    constant sltu_b3   : std_logic_vector (31 downto 0) := x"7fff" & x"0000";
    constant sltu_r3   : std_logic_vector (31 downto 0) := x"0000" & x"0001";
    constant sltu_z3   : std_logic                      := '0';

    -- sge test values
    -- abcd ef01 >= abcdef01
    constant sge_a1   : std_logic_vector (31 downto 0) := x"abcd" & x"ef01";
    constant sge_b1   : std_logic_vector (31 downto 0) := x"abcd" & x"ef01";
    constant sge_r1   : std_logic_vector (31 downto 0) := x"0000" & x"0001";
    constant sge_z1   : std_logic                      := '0';
    -- ffff ffff >= 7fff ffff
    constant sge_a2   : std_logic_vector (31 downto 0) := x"ffff" & x"ffff";
    constant sge_b2   : std_logic_vector (31 downto 0) := x"7fff" & x"ffff";
    constant sge_r2   : std_logic_vector (31 downto 0) := x"0000" & x"0000";
    constant sge_z2   : std_logic                      := '1';
    -- 0000 ffff >= ffff 0000
    constant sge_a3   : std_logic_vector (31 downto 0) := x"0000" & x"ffff";
    constant sge_b3   : std_logic_vector (31 downto 0) := x"ffff" & x"0000";
    constant sge_r3   : std_logic_vector (31 downto 0) := x"0000" & x"0001";
    constant sge_z3   : std_logic                      := '0';

    -- sgeu test values
    -- abcd ef01 >= abcdef01
    constant sgeu_a1   : std_logic_vector (31 downto 0) := x"abcd" & x"ef01";
    constant sgeu_b1   : std_logic_vector (31 downto 0) := x"abcd" & x"ef01";
    constant sgeu_r1   : std_logic_vector (31 downto 0) := x"0000" & x"0001";
    constant sgeu_z1   : std_logic                      := '0';
    -- ffff ffff >= 7fff ffff
    constant sgeu_a2   : std_logic_vector (31 downto 0) := x"ffff" & x"ffff";
    constant sgeu_b2   : std_logic_vector (31 downto 0) := x"7fff" & x"ffff";
    constant sgeu_r2   : std_logic_vector (31 downto 0) := x"0000" & x"0001";
    constant sgeu_z2   : std_logic                      := '0';
    -- 0000 ffff >= ffff 0000
    constant sgeu_a3   : std_logic_vector (31 downto 0) := x"0000" & x"ffff";
    constant sgeu_b3   : std_logic_vector (31 downto 0) := x"ffff" & x"0000";
    constant sgeu_r3   : std_logic_vector (31 downto 0) := x"0000" & x"0000";
    constant sgeu_z3   : std_logic                      := '1';

    -- seq test values
    -- abcd ef01 >= abcdef01
    constant seq_a1   : std_logic_vector (31 downto 0) := x"abcd" & x"ef01";
    constant seq_b1   : std_logic_vector (31 downto 0) := x"abcd" & x"ef01";
    constant seq_r1   : std_logic_vector (31 downto 0) := x"0000" & x"0001";
    constant seq_z1   : std_logic                      := '0';
    -- ffff ffff >= 7fff ffff
    constant seq_a2   : std_logic_vector (31 downto 0) := x"ffff" & x"ffff";
    constant seq_b2   : std_logic_vector (31 downto 0) := x"7fff" & x"ffff";
    constant seq_r2   : std_logic_vector (31 downto 0) := x"0000" & x"0000";
    constant seq_z2   : std_logic                      := '1';
    -- 0000 ffff >= ffff 0000
    constant seq_a3   : std_logic_vector (31 downto 0) := x"0000" & x"ffff";
    constant seq_b3   : std_logic_vector (31 downto 0) := x"ffff" & x"0000";
    constant seq_r3   : std_logic_vector (31 downto 0) := x"0000" & x"0000";
    constant seq_z3   : std_logic                      := '1';

    -- sne test values
    -- abcd ef01 >= abcdef01
    constant sne_a1   : std_logic_vector (31 downto 0) := x"abcd" & x"ef01";
    constant sne_b1   : std_logic_vector (31 downto 0) := x"abcd" & x"ef01";
    constant sne_r1   : std_logic_vector (31 downto 0) := x"0000" & x"0000";
    constant sne_z1   : std_logic                      := '1';
    -- ffff ffff >= 7fff ffff
    constant sne_a2   : std_logic_vector (31 downto 0) := x"ffff" & x"ffff";
    constant sne_b2   : std_logic_vector (31 downto 0) := x"7fff" & x"ffff";
    constant sne_r2   : std_logic_vector (31 downto 0) := x"0000" & x"0001";
    constant sne_z2   : std_logic                      := '0';
    -- 0000 ffff >= ffff 0000
    constant sne_a3   : std_logic_vector (31 downto 0) := x"0000" & x"ffff";
    constant sne_b3   : std_logic_vector (31 downto 0) := x"ffff" & x"0000";
    constant sne_r3   : std_logic_vector (31 downto 0) := x"0000" & x"0001";
    constant sne_z3   : std_logic                      := '0';

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
        -- and tests
        opcode <= and_o;
        a      <= and_a1;
        b      <= and_b1;
        wait for interval;
        assert res  = and_r1 report "Erro no res teste and 1";
        assert zero = and_z1 report "Erro no res teste and 1";
        a      <= and_a2;
        b      <= and_b2;
        wait for interval;
        assert res  = and_r2 report "Erro no res teste and 2";
        assert zero = and_z2 report "Erro no res teste and 2";
        a      <= and_a3;
        b      <= and_b3;
        wait for interval;
        assert res  = and_r3 report "Erro no res teste and 3";
        assert zero = and_z3 report "Erro no res teste and 3";
        -- or tests
        opcode <= or_o;
        a      <= or_a1;
        b      <= or_b1;
        wait for interval;
        assert res  = or_r1 report "Erro no res teste or 1";
        assert zero = or_z1 report "Erro no res teste or 1";
        a      <= or_a2;
        b      <= or_b2;
        wait for interval;
        assert res  = or_r2 report "Erro no res teste or 2";
        assert zero = or_z2 report "Erro no res teste or 2";
        a      <= or_a3;
        b      <= or_b3;
        wait for interval;
        assert res  = or_r3 report "Erro no res teste or 3";
        assert zero = or_z3 report "Erro no res teste or 3";
        -- xor tests
        opcode <= xor_o;
        a      <= xor_a1;
        b      <= xor_b1;
        wait for interval;
        assert res  = xor_r1 report "Erro no res teste xor 1";
        assert zero = xor_z1 report "Erro no res teste xor 1";
        a      <= xor_a2;
        b      <= xor_b2;
        wait for interval;
        assert res  = xor_r2 report "Erro no res teste xor 2";
        assert zero = xor_z2 report "Erro no res teste xor 2";
        a      <= xor_a3;
        b      <= xor_b3;
        wait for interval;
        assert res  = xor_r3 report "Erro no res teste xor 3";
        assert zero = xor_z3 report "Erro no res teste xor 3";
        -- sll tests
        opcode <= sll_o;
        a      <= sll_a1;
        b      <= sll_b1;
        wait for interval;
        assert res  = sll_r1 report "Erro no res teste sll 1";
        assert zero = sll_z1 report "Erro no res teste sll 1";
        a      <= sll_a2;
        b      <= sll_b2;
        wait for interval;
        assert res  = sll_r2 report "Erro no res teste sll 2";
        assert zero = sll_z2 report "Erro no res teste sll 2";
        a      <= sll_a3;
        b      <= sll_b3;
        wait for interval;
        assert res  = sll_r3 report "Erro no res teste sll 3";
        assert zero = sll_z3 report "Erro no res teste sll 3";
        -- srl tests
        opcode <= srl_o;
        a      <= srl_a1;
        b      <= srl_b1;
        wait for interval;
        assert res  = srl_r1 report "Erro no res teste srl 1";
        assert zero = srl_z1 report "Erro no res teste srl 1";
        a      <= srl_a2;
        b      <= srl_b2;
        wait for interval;
        assert res  = srl_r2 report "Erro no res teste srl 2";
        assert zero = srl_z2 report "Erro no res teste srl 2";
        a      <= srl_a3;
        b      <= srl_b3;
        wait for interval;
        assert res  = srl_r3 report "Erro no res teste srl 3";
        assert zero = srl_z3 report "Erro no res teste srl 3";
        -- sra tests
        opcode <= sra_o;
        a      <= sra_a1;
        b      <= sra_b1;
        wait for interval;
        assert res  = sra_r1 report "Erro no res teste sra 1";
        assert zero = sra_z1 report "Erro no res teste sra 1";
        a      <= sra_a2;
        b      <= sra_b2;
        wait for interval;
        assert res  = sra_r2 report "Erro no res teste sra 2";
        assert zero = sra_z2 report "Erro no res teste sra 2";
        a      <= sra_a3;
        b      <= sra_b3;
        wait for interval;
        assert res  = sra_r3 report "Erro no res teste sra 3";
        assert zero = sra_z3 report "Erro no res teste sra 3";
        -- slt tests
        opcode <= slt;
        a      <= slt_a1;
        b      <= slt_b1;
        wait for interval;
        assert res  = slt_r1 report "Erro no res teste slt 1";
        assert zero = slt_z1 report "Erro no res teste slt 1";
        a      <= slt_a2;
        b      <= slt_b2;
        wait for interval;
        assert res  = slt_r2 report "Erro no res teste slt 2";
        assert zero = slt_z2 report "Erro no res teste slt 2";
        a      <= slt_a3;
        b      <= slt_b3;
        wait for interval;
        assert res  = slt_r3 report "Erro no res teste slt 3";
        assert zero = slt_z3 report "Erro no res teste slt 3";
        -- sltu tests
        opcode <= sltu;
        a      <= sltu_a1;
        b      <= sltu_b1;
        wait for interval;
        assert res  = sltu_r1 report "Erro no res teste sltu 1";
        assert zero = sltu_z1 report "Erro no res teste sltu 1";
        a      <= sltu_a2;
        b      <= sltu_b2;
        wait for interval;
        assert res  = sltu_r2 report "Erro no res teste sltu 2";
        assert zero = sltu_z2 report "Erro no res teste sltu 2";
        a      <= sltu_a3;
        b      <= sltu_b3;
        wait for interval;
        assert res  = sltu_r3 report "Erro no res teste sltu 3";
        assert zero = sltu_z3 report "Erro no res teste sltu 3";
        -- sge tests
        opcode <= sge;
        a      <= sge_a1;
        b      <= sge_b1;
        wait for interval;
        assert res  = sge_r1 report "Erro no res teste sge 1";
        assert zero = sge_z1 report "Erro no res teste sge 1";
        a      <= sge_a2;
        b      <= sge_b2;
        wait for interval;
        assert res  = sge_r2 report "Erro no res teste sge 2";
        assert zero = sge_z2 report "Erro no res teste sge 2";
        a      <= sge_a3;
        b      <= sge_b3;
        wait for interval;
        assert res  = sge_r3 report "Erro no res teste sge 3";
        assert zero = sge_z3 report "Erro no res teste sge 3";
        -- sgeu tests
        opcode <= sgeu;
        a      <= sgeu_a1;
        b      <= sgeu_b1;
        wait for interval;
        assert res  = sgeu_r1 report "Erro no res teste sgeu 1";
        assert zero = sgeu_z1 report "Erro no res teste sgeu 1";
        a      <= sgeu_a2;
        b      <= sgeu_b2;
        wait for interval;
        assert res  = sgeu_r2 report "Erro no res teste sgeu 2";
        assert zero = sgeu_z2 report "Erro no res teste sgeu 2";
        a      <= sgeu_a3;
        b      <= sgeu_b3;
        wait for interval;
        assert res  = sgeu_r3 report "Erro no res teste sgeu 3";
        assert zero = sgeu_z3 report "Erro no res teste sgeu 3";
        -- seq tests
        opcode <= seq;
        a      <= seq_a1;
        b      <= seq_b1;
        wait for interval;
        assert res  = seq_r1 report "Erro no res teste seq 1";
        assert zero = seq_z1 report "Erro no res teste seq 1";
        a      <= seq_a2;
        b      <= seq_b2;
        wait for interval;
        assert res  = seq_r2 report "Erro no res teste seq 2";
        assert zero = seq_z2 report "Erro no res teste seq 2";
        a      <= seq_a3;
        b      <= seq_b3;
        wait for interval;
        assert res  = seq_r3 report "Erro no res teste seq 3";
        assert zero = seq_z3 report "Erro no res teste seq 3";
        -- sne tests
        opcode <= sne;
        a      <= sne_a1;
        b      <= sne_b1;
        wait for interval;
        assert res  = sne_r1 report "Erro no res teste sne 1";
        assert zero = sne_z1 report "Erro no res teste sne 1";
        a      <= sne_a2;
        b      <= sne_b2;
        wait for interval;
        assert res  = sne_r2 report "Erro no res teste sne 2";
        assert zero = sne_z2 report "Erro no res teste sne 2";
        a      <= sne_a3;
        b      <= sne_b3;
        wait for interval;
        assert res  = sne_r3 report "Erro no res teste sne 3";
        assert zero = sne_z3 report "Erro no res teste sne 3";
    end process;

end architecture;