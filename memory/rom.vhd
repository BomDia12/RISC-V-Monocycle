library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity rom_rv is port (
    address  : in  std_logic_vector;
    data_out : out std_logic_vector
);
end entity rom_rv;

architecture arch of rom_rv is

    type mem_type is array (0 to (2 ** address'length) - 1) of std_logic_vector(data_out'range);

    signal mem : mem_type;

begin
    data_out <= mem(to_integer(unsigned(address)));
end arch;
