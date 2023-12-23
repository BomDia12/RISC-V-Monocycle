library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_bank is
    port (
        clk, wren    : in  std_logic;
        rs1, rs2, rd : in  std_logic_vector(4  downto 0);
        data         : in  std_logic_vector(31 downto 0);
        ro1, ro2     : out std_logic_vector(31 downto 0)
    );
end register_bank;

architecture arch of register_bank is

    -- Declares the registrt type
    type registers is array (31 downto 1) of std_logic_vector (31 downto 0);

    constant zero : std_logic_vector (31 downto 0) := (others => '0');

    function seed_registers return registers is
        variable value: registers;
    begin
        for i in 1 to 31 loop
            value(i) := zero;
        end loop;
        return value;
    end function seed_registers;

    signal registry_data : registers := seed_registers;
begin

    process (clk)
    begin
        if rising_edge(clk) then
            if rs1 /= "00000" and rs2 /= "00000" then
                ro1 <= registry_data(to_integer(unsigned(rs1)));
                ro2 <= registry_data(to_integer(unsigned(rs2)));
            elsif rs1 /= "00000" then
                ro1 <= registry_data(to_integer(unsigned(rs1)));
                ro2 <= zero;
            elsif rs2 /= "00000" then
                ro1 <= zero;
                ro2 <= registry_data(to_integer(unsigned(rs2)));
            else
                ro1 <= zero;
                ro2 <= zero;
            end if;
            if wren = '1' then
                if rd /= "00000" then
                    registry_data(to_integer(unsigned(rd))) <= data;
                end if;
            end if;
        end if;
    end process;

end arch; 
