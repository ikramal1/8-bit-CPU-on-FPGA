library ieee;
use ieee.std_logic_1164.all;

entity pc_tb is
end pc_tb;

architecture tb of pc_tb is


  component pc is
    port(
      clk    : in  std_logic;
      rst    : in  std_logic;
      en     : in  std_logic;
      ld     : in  std_logic;
      input  : in  std_logic_vector(3 downto 0);
      output : out std_logic_vector(3 downto 0)
    );
  end component;

  
  signal clk_sig    : std_logic := '0';
  signal rst_sig    : std_logic := '0';
  signal en_sig     : std_logic := '0';
  signal ld_sig     : std_logic := '0';
  signal input_sig  : std_logic_vector(3 downto 0) := (others => '0');
  signal output_sig : std_logic_vector(3 downto 0);

  constant clk_period : time := 10 ns;

begin

  -- UUT instantiation
  uut: pc
    port map(
      clk    => clk_sig,
      rst    => rst_sig,
      en     => en_sig,
      ld     => ld_sig,
      input  => input_sig,
      output => output_sig
    );

  -- Clock generator (free-running)
  clk_process : process
  begin
    while true loop
      clk_sig <= '0';
      wait for clk_period/2;
      clk_sig <= '1';
      wait for clk_period/2;
    end loop;
  end process;

  -- Stimulus process (tests reset, increment, load)
  stim_process : process
  begin
    -- 1) Apply reset
    rst_sig   <= '1';
    en_sig    <= '0';
    ld_sig    <= '0';
    input_sig <= "0000";
    wait for 2*clk_period;

    -- 2) Release reset
    rst_sig <= '0';
    wait for clk_period;

    -- 3) Enable counting for a few cycles
    en_sig <= '1';
    wait for 6*clk_period;   -- PC should increment

    -- 4) Test LOAD (jump) to 10
    ld_sig    <= '1';
    en_sig    <= '1';        -- even if en=1, ld has priority
    input_sig <= "1010";
    wait for clk_period;     -- load happens on rising edge

    -- 5) Disable load, keep counting
    ld_sig <= '0';
    wait for 4*clk_period;

    -- 6) Pause counting
    en_sig <= '0';
    wait for 3*clk_period;

    -- 7) Another jump to 3
    ld_sig    <= '1';
    input_sig <= "0011";
    wait for clk_period;

    ld_sig <= '0';
    en_sig <= '1';
    wait for 4*clk_period;

    -- End simulation
    wait;
  end process;

end tb;