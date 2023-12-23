library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is end;

architecture arch of top_level is

    component alu port (
        opcode             : in  std_logic_vector (3  downto 0);
        a, b               : in  std_logic_vector (31 downto 0);
        res                : out std_logic_vector (31 downto 0);
        zero               : out std_logic
    );
    end component;

    component immediate_generator port (
        instruction        : in  std_logic_vector (31 downto 0);
        immediate          : out std_logic_vector (31 downto 0)
    );
    end component;

    component registry is port (
        clk                : in  std_logic;
        new_value          : in  std_logic_vector (31 downto 0);
        cur_value          : out std_logic_vector (31 downto 0)
    );
    end component;

    component register_bank port (
        clk, wren          : in  std_logic;
        rs1, rs2, rd       : in  std_logic_vector(4  downto 0);
        data               : in  std_logic_vector(31 downto 0);
        ro1, ro2           : out std_logic_vector(31 downto 0)
    );
    end component;

    component data_mem port (
        clock              : in  std_logic;
        write_data         : in  std_logic;
        address            : in  std_logic_vector (14 downto 0);
        in_data            : in  std_logic_vector (31 downto 0);
        out_data           : out std_logic_vector (31 downto 0)
    );
    end component;

    component mux4x1 is port (
        ctrl               : in  std_logic_vector (1  downto 0);
        x1                 : in  std_logic_vector (31 downto 0);
        x2                 : in  std_logic_vector (31 downto 0);
        x3                 : in  std_logic_vector (31 downto 0);
        x4                 : in  std_logic_vector (31 downto 0);
        y                  : out std_logic_vector (31 downto 0)
    );
    end component;

    component mux2x1 is port (
        ctrl               : in  std_logic;
        x1                 : in  std_logic_vector (31 downto 0);
        x2                 : in  std_logic_vector (31 downto 0);
        y                  : out std_logic_vector (31 downto 0)
    );
    end component;

    component control port (
        instruction       : in  std_logic_vector (31 downto 0);
        -- 00 -> PC + 4; 01 & zero -> res_alu; 10 & not zero -> res_alu; 11 -> res_alu;
        branch            : out std_logic_vector (1  downto 0);
        mem_read          : out std_logic;
        -- 00 -> ULA; 01 -> data_mem; 10 -> pc + 4; 11 -> lui
        reg_src           : out std_logic_vector (1  downto 0);
        mem_write         : out std_logic;
        alu_op            : out std_logic_vector (3  downto 0);
        -- alu_src(0) -> 0: Registry; 1: Immediate;
        -- alu_src(1) -> 0: Registry; 1: PC;
        alu_src           : out std_logic_vector (1  downto 0);
        reg_write         : out std_logic
    );
    end component;

    component rom_rv port (
        address           : in  std_logic_vector (14 downto 0);
        data_out          : out std_logic_vector (31 downto 0)
    );
    end component;
 
    signal   curr_PC      : std_logic_vector (31 downto 0);
    signal   next_PC      : std_logic_vector (31 downto 0);
    signal   clk          : std_logic                      := '0';
    signal   rs1          : std_logic_vector (31 downto 0);
    signal   rs2          : std_logic_vector (31 downto 0);
    signal   rd           : std_logic_vector (31 downto 0);
    signal   imm          : std_logic_vector (31 downto 0);
    signal   instruction  : std_logic_vector (31 downto 0);
    signal   alu_res      : std_logic_vector (31 downto 0);
    signal   mem_res      : std_logic_vector (31 downto 0);
    signal   branch       : std_logic_vector (1  downto 0);
    signal   mem_read     : std_logic;
    signal   mem_write    : std_logic;
    signal   reg_src      : std_logic_vector (1  downto 0);
    signal   alu_op       : std_logic_vector (3  downto 0);
    signal   alu_src      : std_logic_vector (1  downto 0);
    signal   reg_write    : std_logic;
    signal   alu_in_1     : std_logic_vector (31 downto 0);
    signal   alu_in_2     : std_logic_vector (31 downto 0);
    signal   alu_res_zero : std_logic;
    signal   added_PC     : std_logic_vector (31 downto 0);
    signal   branch_ctrl  : std_logic;

    constant interval     : time                           := 10 ps;
    constant four         : unsigned                       := x"00000100";

begin

    -- Clock
    clk <= not clk after interval / 2;

    PC_reg        : registry             port map (
        clk         => clk,
        new_value   => next_PC,
        cur_value   => curr_PC
    );

    inst_memory   : rom_rv              port map (
        address     => curr_PC (14 downto 0),
        data_out    => instruction
    );

    added_PC        <= std_logic_vector(unsigned(curr_PC) + four);

    ctrl_unit     : control              port map (
        instruction => instruction,
        branch      => branch,
        mem_read    => mem_read,
        mem_write   => mem_write,
        reg_src     => reg_src,
        alu_op      => alu_op,
        alu_src     => alu_src,
        reg_write   => reg_write
    );

    reg_bank      : register_bank        port map (
        clk         => clk,
        wren        => reg_write,
        rs1         => instruction(19 downto 15),
        rs2         => instruction(24 downto 20),
        rd          => instruction(11 downto  7),
        data        => rd,
        ro1         => rs1,
        ro2         => rs2
    );

    immediate_gen : immediate_generator port map (
        instruction => instruction,
        immediate   => imm
    );

    alu_src_1_mux : mux2x1              port map (
        ctrl        => alu_src(1),
        x1          => rs1,
        x2          => curr_PC,
        y           => alu_in_1
    );
    
    alu_src_2_mux : mux2x1              port map (
        ctrl        => alu_src(0),
        x1          => rs2,
        x2          => imm,
        y           => alu_in_2
    );

    alu_comp      : alu                 port map (
        opcode      => alu_op,
        a           => alu_in_1,
        b           => alu_in_2,
        res         => alu_res,
        zero        => alu_res_zero
    );

    -- selecting whether or not to switch PC
    process (branch, alu_res_zero)
    begin
        if branch = "11" then
            branch_ctrl <= '1';
        elsif branch = "10" and alu_res_zero = '1' then
            branch_ctrl <= '1';
        else
            branch_ctrl <= '0';
        end if;
    end process;

    branching     : mux2x1              port map (
        ctrl        => branch_ctrl,
        x1          => added_PC,
        x2          => alu_res,
        y           => next_PC
    );

    data_memory   : data_mem            port map (
        clock       => clk,
        write_data  => mem_write,
        address     => alu_res (14 downto  0),
        in_data     => rs2,
        out_data    => mem_res
    );

end architecture;
