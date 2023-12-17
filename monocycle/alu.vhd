library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is port (
    opcode : in  std_logic_vector (3  downto 0);
    a, b   : in  std_logic_vector (31 downto 0);
    res    : out std_logic_vector (31 downto 0);
    zero   : out std_logic
);
end alu;

architecture arch of alu is

    signal z      : signed (31 downto 0);

    constant one  : signed (31 downto 0) := x"00000001";
    constant none : signed (31 downto 0) := x"00000000";

begin

    process (a, b, opcode)
    begin
        case opcode is
            when "0000" =>
                z <= signed(a) + signed(b);
            when "0001" =>
                z <= signed(a) - signed(b);
            when "0010" =>
                z <= signed(a and b);
            when "0011" =>
                z <= signed(a or  b);
            when "0100" =>
                z <= signed(a xor b);
            when "0101" =>
                z <= signed(shift_left(unsigned(a), to_integer(unsigned(b))));
            when "0110" =>
                z <= signed(shift_right(unsigned(a), to_integer(unsigned(b))));
            when "0111" =>
                z <= shift_right(signed(a)  , to_integer(unsigned(b)));
            when "1000" =>
                if signed(a) < signed(b) then
                    z <= one;
                else
                    z <= none;
                end if;
            when "1001" =>
                if unsigned(a) < unsigned(b) then
                    z <= one;
                else
                    z <= none;
                end if;
            when "1010" =>
                if signed(a) >= signed(b) then
                    z <= one;
                else
                    z <= none;
                end if;
            when "1011" =>
                if unsigned(a) >= unsigned(b) then
                    z <= one;
                else
                    z <= none;
                end if;
            when "1100" =>
                if a = b then
                    z <= one;
                else
                    z <= none;
                end if;
            when "1101" =>
                if a = b then
                    z <= none;
                else
                    z <= one;
                end if;
            when others =>
                    z <= none;
        end case;
    end process;

    process (z)
    begin
        if z = none then
            zero <= '1';
        else
            zero <= '0';
        end if;
    end process;

    res <= std_logic_vector(z);

end architecture;
