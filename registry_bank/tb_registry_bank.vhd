entity tb_registry_bank is end;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture tb of tb_registry_bank is

    component register_bank
        port (
            clk, wren    : in  std_logic;
            rs1, rs2, rd : in  std_logic_vector(4  downto 0);
            data         : in  std_logic_vector(31 downto 0);
            ro1, ro2     : out std_logic_vector(31 downto 0)
        );
    end component;
    
    -- Test signals
    signal   clk        : std_logic                      := '0';
    signal   wren       : std_logic                      := '0';
    signal   rs1        : std_logic_vector (4  downto 0) := (others => '0');
    signal   rs2        : std_logic_vector (4  downto 0) := (others => '0');
    signal   rd         : std_logic_vector (4  downto 0) := (others => '0');
    signal   data       : std_logic_vector (31 downto 0) := (others => '0');
    signal   ro1        : std_logic_vector (31 downto 0) := (others => '0');
    signal   ro2        : std_logic_vector (31 downto 0) := (others => '0');

    -- Test Data
    constant zero       : std_logic_vector (31 downto 0) := (others => '0');
    constant test_value : std_logic_vector (31 downto 0) := x"01234567";
    constant interval   : time                           := 2 ps;

begin

    -- Component being tested
    test : register_bank port map (clk, wren, rs1, rs2, rd, data, ro1, ro2);

    clk <= not clk after interval/2;

    process
    begin
        -- populates the registry_bank
        wren <= '1';
        for i in 0 to 31 loop
            rd   <= std_logic_vector(to_unsigned(i, 5));
            data <= std_logic_vector(unsigned(test_value) + to_unsigned(i, 32));
            wait for interval;
        end loop;

        -- Tests the registry_bank
        wren <= '0';
        for i in 1 to 31 loop
            for j in 1 to 31 loop
                rs1 <= std_logic_vector(to_unsigned(i, 5));
                rs2 <= std_logic_vector(to_unsigned(j, 5));
                wait for interval;
                assert ro1 = std_logic_vector(unsigned(test_value) + to_unsigned(i, 32))
                    report "error in the registry x" & integer'image(i) & " when used as rs1";
                assert ro2 = std_logic_vector(unsigned(test_value) + to_unsigned(j, 32))
                    report "error in the registry x" & integer'image(j) & " when used as rs2";
            end loop;
        end loop;

        -- Tests zero
        rs1 <= "00000";
        wait for interval;
        assert ro1 = zero
            report "error in the registry x0 when used as rs1";
        rs2 <= "00000";
        wait for interval;
        assert ro2 = zero
            report "error in the registry x0 when used as rs2";
    end process;

end tb;
