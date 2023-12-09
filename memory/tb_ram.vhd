entity tb_ram is end;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture test of tb_ram is

    component ram_rv port (
        clock    : in  std_logic;
        we       : in  std_logic;
        address  : in  std_logic_vector;
        data_in  : in  std_logic_vector;
        data_out : out std_logic_vector
    );
    end component;

    signal   clock      : std_logic                      := '0';
    signal   we         : std_logic                      := '0';
    signal   address    : std_logic_vector (7  downto 0) := (others => '0');
    signal   data_in    : std_logic_vector (31 downto 0) := (others => '0');
    signal   data_out   : std_logic_vector (31 downto 0) := (others => '0');

    constant interval   : time                           := 1 ns;

    constant test_value : std_logic_vector (31 downto 0) := x"01234567";

begin

    clock <= not clock after interval / 2;

    mem : ram_rv port map (clock, we, address, data_in, data_out);
    process
    begin
        -- Writing data to memory
        we <= '1';
        for i in 0 to 255 loop
            address <= std_logic_vector(to_unsigned(i, 8));
            data_in <= std_logic_vector(unsigned(test_value) + to_unsigned(i, 32));
            wait for interval;
        end loop;

        -- Reading data from memory
        we <= '0';
        for i in 0 to 255 loop
            address <= std_logic_vector(to_unsigned(i, 8));
            wait for interval;
            assert data_out = std_logic_vector(unsigned(test_value) + to_unsigned(i, 32))
                report "error in memory address " & integer'image(i);
        end loop;
    end process;

end architecture;
