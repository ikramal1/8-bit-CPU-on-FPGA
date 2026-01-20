library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mar_mem_tb is
end entity;

architecture tb of mar_mem_tb is

  ------------------------------------------------------------------
  -- Components
  ------------------------------------------------------------------
  component mar is
    port(
      clk, rst, load : in  std_logic;
      input          : in  std_logic_vector(3 downto 0);
      output         : out std_logic_vector(3 downto 0)
    );
  end component;

  component mem is
    port(
      clk      : in  std_logic;
      load     : in  std_logic;
      oe       : in  std_logic;
      data_in  : in  std_logic_vector(7 downto 0);
      addr_in  : in  std_logic_vector(3 downto 0);
      data_out : out std_logic_vector(7 downto 0)
    );
  end component;

  ------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------
  signal clk_sig      : std_logic := '0';
  signal rst_sig      : std_logic := '0';

  signal load_mar     : std_logic := '0';
  signal mar_input    : std_logic_vector(3 downto 0) := (others => '0');
  signal mar_output   : std_logic_vector(3 downto 0);

  signal load_mem     : std_logic := '0';
  signal mem_oe       : std_logic := '0';
  signal mem_data_in  : std_logic_vector(7 downto 0) := (others => '0');
  signal mem_data_out : std_logic_vector(7 downto 0);

  constant clk_period : time := 10 ns;

begin

  ------------------------------------------------------------------
  -- DUT instantiation
  ------------------------------------------------------------------
  mar1 : mar
    port map(
      clk    => clk_sig,
      rst    => rst_sig,
      load   => load_mar,
      input  => mar_input,
      output => mar_output
    );

  mem1 : mem
    port map(
      clk      => clk_sig,
      load     => load_mem,
      oe       => mem_oe,
      data_in  => mem_data_in,
      addr_in  => mar_output,
      data_out => mem_data_out
    );

  ------------------------------------------------------------------
  -- Clock generator
  ------------------------------------------------------------------
  clk_process : process
  begin
    while true loop
      clk_sig <= '0';
      wait for clk_period/2;
      clk_sig <= '1';
      wait for clk_period/2;
    end loop;
  end process;

  ------------------------------------------------------------------
  -- Stimulus & verification
  ------------------------------------------------------------------
  stim_process : process
    variable expected : std_logic_vector(7 downto 0);
  begin

    --------------------------------------------------------------
    -- RESET
    --------------------------------------------------------------
    rst_sig   <= '1';
    load_mar  <= '0';
    load_mem  <= '0';
    mem_oe    <= '0';
    wait for 2*clk_period;

    rst_sig <= '0';
    wait for clk_period;

    --------------------------------------------------------------
    -- TEST 1 : Verify memory init file (addresses 0..15)
    -- even address -> 00
    -- odd  address -> FF
    --------------------------------------------------------------
    for i in 0 to 15 loop

      -- Load MAR with address i
      mar_input <= std_logic_vector(to_unsigned(i, 4));
      load_mar  <= '1';
      wait until rising_edge(clk_sig);
      load_mar  <= '0';

      -- small delay so MAR output is stable
      wait for 1 ns;

      -- Expected pattern
      if (i mod 2 = 0) then
        expected := x"00";
      else
        expected := x"FF";
      end if;

      -- Enable read (combinational output of memory)
      mem_oe <= '1';
      wait for 1 ns;  -- allow data_out to update

      -- Check (NO to_hstring)
      assert mem_data_out = expected
        report "ERROR: Init mismatch at address " & integer'image(i) &
               " expected(dec)=" & integer'image(to_integer(unsigned(expected))) &
               " got(dec)=" & integer'image(to_integer(unsigned(mem_data_out)))
        severity error;

      mem_oe <= '0';
      wait for clk_period;

    end loop;

    --------------------------------------------------------------
    -- TEST 2 : Overwrite address 3 and read back
    --------------------------------------------------------------
    -- Load MAR = 3
    mar_input <= "0011";
    load_mar  <= '1';
    wait until rising_edge(clk_sig);
    load_mar  <= '0';
    wait for 1 ns;

    -- Write A5 into RAM[3] (sync write)
    mem_data_in <= x"A5";
    load_mem    <= '1';
    wait until rising_edge(clk_sig);
    load_mem    <= '0';
    wait for 1 ns;

    -- Read back
    mem_oe <= '1';
    wait for clk_period;

    assert mem_data_out = x"A5"
      report "ERROR: Write/read failed at address 3 expected(dec)=165 got(dec)=" &
             integer'image(to_integer(unsigned(mem_data_out)))
      severity error;

    mem_oe <= '0';
    wait for clk_period;

    --------------------------------------------------------------
    -- END
    --------------------------------------------------------------
    report "ALL MAR + MEMORY TESTS PASSED " severity note;
    wait;

  end process;

end architecture;