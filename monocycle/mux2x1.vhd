library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux2x1 is port (
    ctrl  : in  std_logic;
    x1    : in  std_logic_vector (31 downto 0);
    x2    : in  std_logic_vector (31 downto 0);
    y     : out std_logic_vector (31 downto 0)
);
end mux2x1;

architecture arch of mux2x1 is
begin
    process (ctrl, x1, x2)
    begin
        case ctrl is
            when '0'    => y <= x1;
            when others => y <= x2;
        end case;
    end process;
end architecture;
