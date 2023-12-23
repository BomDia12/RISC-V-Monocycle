library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_mem is port (
    clock      : in  std_logic;
    write_data : in  std_logic;
    address    : in  std_logic_vector (14 downto 0);
    in_data    : in  std_logic_vector (31 downto 0);
    out_data   : out std_logic_vector (31 downto 0)
);
end data_mem;

architecture arch of data_mem is

    component ram is port (
        clock    : in  std_logic;
        we       : in  std_logic;
        address  : in  std_logic_vector;
        data_in  : in  std_logic_vector;
        data_out : out std_logic_vector
    );
    end component;

    signal addr     : std_logic_vector (14 downto 0);
    signal tmp_addr : unsigned         (14 downto 0);

begin
    tmp_addr <= shift_right(unsigned(address), 2);
    addr     <= std_logic_vector(tmp_addr);

    mem : ram port map (
        clock    => clock,
        we       => write_data,
        address  => addr (12 downto 0),
        data_in  => in_data,
        data_out => out_data
    );

end architecture;
