entity tb_rom is end;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture test of tb_rom is

    component rom_rv port (
        address  : in  std_logic_vector (7  downto 0);
        data_out : out std_logic_vector (31 downto 0)
    );
    end component;

    signal address         : std_logic_vector (7  downto 0);
    signal data_out        : std_logic_vector (31 downto 0);

    -- Test constant
    constant initial_value : std_logic_vector (31 downto 0) := x"76543210";

    constant interval      : time                           := 1 ps;

begin

    mem : rom_rv port map (address, data_out);

    process
    begin
        for i in 0 to 255 loop
            address <= std_logic_vector(to_unsigned(i, 8));
            wait for interval;
            assert data_out = std_logic_vector(unsigned(initial_value) + to_unsigned(i, 32))
                report "Erro no valor da rom no endereço " & integer'image(i);
        end loop;
    end process;
end test;