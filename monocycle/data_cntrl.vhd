library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_mem is port (
    clock      : in  std_logic;
    write_data : in  std_logic;
    read_data  : in  std_logic;
    funct_3    : in  std_logic_vector (2  downto 0);
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

    signal   raw_out_data      : std_logic_vector (31 downto 0);
    signal   processed_in_data : std_logic_vector (31 downto 0);
    signal   addr              : std_logic_vector (12 downto 0);
    signal   clk               : std_logic;
    
    constant byte_mask         : std_logic_vector (31 downto 0 ) := x"000000ff";
    constant half_mask         : std_logic_vector (31 downto 0 ) := x"0000ffff";
    constant byte_shift        : unsigned         (5  downto 0 ) := 8;
    constant half_shift        : unsigned         (5  downto 0 ) := 16;
    constant byte_fill         : std_logic_vector (31 downto 8 ) := x"ffffff";
    constant half_fill         : std_logic_vector (31 downto 16) := x"ffff";

begin
    clk  <= clock after 1 ps;
    addr <= shift_right(address, 2);

    mem : ram port map (
        clock    => clk,
        we       => write_data,
        address  => addr,
        data_in  => processed_in_data,
        data_out => raw_out_data
    );

    -- Read Data
    process(clk)
        variable shift_amount : integer; 
        variable intermidiate : std_logic_vector (31 downto 0);
    begin
        if read_data = '1' and rising_edge(clk) then
            case funct_3 is
                when "000" => -- lb
                    shift_amount := to_integer(unsigned(address(1 downto 0) * 8));
                    intermidiate := std_logic_vector(shift_right(unsigned(raw_data_out), shift_amount)) and byte_mask;
                    if intermidiate(7) = '1' then
                        data_out <= byte_fill & intermidiate(7 downto 0);
                    else
                        data_out <= intermidiate;
                    end if;
                when "001" => -- lh
                    shift_amount := to_integer(unsigned(address(1)) * 16);
                    intermidiate := std_logic_vector(shift_right(unsigned(raw_data_out), shift_amount)) and half_mask;
                    if intermidiate(7) = '1' then
                        data_out <= half_fill & intermidiate(15 downto 0);
                    else
                        data_out <= intermidiate;
                    end if;
                when "010" => -- lw
                    data_out <= raw_data_out;
                when "100" => -- lbu
                    shift_amount := to_integer(unsigned(address(1 downto 0) * 8));
                    data_out     <= std_logic_vector(shift_right(unsigned(raw_data_out), shift_amount)) and byte_mask;
                when "101" => -- lhu
                    shift_amount := to_integer(unsigned(address(1)) * 16);
                    data_out     <= std_logic_vector(shift_right(unsigned(raw_data_out), shift_amount)) and half_mask;
            end case;
        end if;
    end process;

    -- write data
    process (clk)
    begin
        if write_data = '1' then
            case funct_3 is 
                when "000" => -- sb
                    processed_in_data <= data_in and byte_mask;
                when "001" => -- sh
                    processed_in_data <= data_in and half_maks;
                when "010" => -- sh
                    processed_in_data <= data_in;
            end case;
        end if;
    end process;

end architecture;
