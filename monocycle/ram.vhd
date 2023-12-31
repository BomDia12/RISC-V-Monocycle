library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity ram_rv is port (
    clock    : in  std_logic;
    we       : in  std_logic;
    address  : in  std_logic_vector;
    data_in  : in  std_logic_vector;
    data_out : out std_logic_vector
);
end entity ram_rv;

architecture arch of ram_rv is

    type mem_type is array (0 to (2 ** address'length) - 1) of std_logic_vector(data_in'range);

    signal mem          : mem_type;

begin

    data_out <= mem(to_integer(unsigned(address)));

    process (clock)
    begin
        if rising_edge(clock) then
            if we = '1' then
                mem(to_integer(unsigned(address))) <= data_in;
            end if;
        end if;
    end process;
end arch;
