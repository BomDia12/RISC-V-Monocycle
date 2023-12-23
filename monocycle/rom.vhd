library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity rom_rv is port (
    address  : in  std_logic_vector (14 downto 0);
    data_out : out std_logic_vector (31 downto 0)
);
end entity rom_rv;

architecture arch of rom_rv is

    type mem_type is array (0 to 32768) of std_logic_vector(31 downto 0);

    
    impure function init_rom_hex return mem_type is
        file text_file : text open read_mode is "inst.txt";
        variable text_line : line;
        variable ram_content : mem_type;
    begin
        for i in 0 to 50 loop
            readline(text_file, text_line);
            hread(text_line, ram_content(i));
        end loop;
        return ram_content;
    end function;

    signal mem : mem_type := init_rom_hex;
begin
    data_out <= mem(to_integer(unsigned(address)));
end arch;
