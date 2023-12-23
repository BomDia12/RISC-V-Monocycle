library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registry is port (
    clk       : in  std_logic;
    new_value : in  std_logic_vector (31 downto 0);
    cur_value : out std_logic_vector (31 downto 0)
);
end registry;

architecture arch of registry is
    signal value : std_logic_vector (31 downto 0);

begin

    curr_value <= value;

    process (clk)
    begin
        if rising_edge(clk) then
            value <= new_value;
        end if;
    end process;

end architecture;
