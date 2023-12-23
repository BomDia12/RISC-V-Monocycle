library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux4x1 is port (
    ctrl  : in  std_logic_vector (1  downto 0);
    x1    : in  std_logic_vector (31 downto 0);
    x2    : in  std_logic_vector (31 downto 0);
    x3    : in  std_logic_vector (31 downto 0);
    x4    : in  std_logic_vector (31 downto 0);
    y     : out std_logic_vector (31 downto 0)
);
end mux4x1;

architecture arch of mux4x1 is
begin
    process (ctrl, x1, x2, x3, x4)
    begin
        case ctrl is
            when "00"   => y <= x1;
            when "01"   => y <= x2;
            when "10"   => y <= x3;
            when others => y <= x4;
        end case;
    end process;
end architecture;
