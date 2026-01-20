library ieee;
use ieee.std_logic_1164.all;

entity alu_tb is
end entity;

architecture tb of alu_tb is

  -- Component declaration
  component alu is
    port(
      A        : in  std_logic_vector(7 downto 0);
      B        : in  std_logic_vector(7 downto 0);
      ALU_op   : in  std_logic_vector(1 downto 0);
      Result   : out std_logic_vector(7 downto 0);
      Carry    : out std_logic;
      Zero     : out std_logic
    );
  end component;

  -- Signals
  signal A_sig      : std_logic_vector(7 downto 0);
  signal B_sig      : std_logic_vector(7 downto 0);
  signal ALU_op_sig : std_logic_vector(1 downto 0);
  signal Result_sig : std_logic_vector(7 downto 0);
  signal Carry_sig  : std_logic;
  signal Zero_sig   : std_logic;

begin

  -- Instantiate ALU
  uut : alu
    port map (
      A        => A_sig,
      B        => B_sig,
      ALU_op   => ALU_op_sig,
      Result   => Result_sig,
      Carry    => Carry_sig,
      Zero     => Zero_sig
    );

  ------------------------------------------------------------------
  -- Stimulus process
  ------------------------------------------------------------------
  stim_process : process
  begin

    -- ======================
    -- ADD: 10 + 20 = 30
    -- ======================
    A_sig      <= "00001010"; -- 10
    B_sig      <= "00010100"; -- 20
    ALU_op_sig <= "00";       -- ADD
    wait for 10 ns;

    -- ======================
    -- ADD with carry: 255 + 1 = 0 (carry=1)
    -- ======================
    A_sig      <= "11111111"; -- 255
    B_sig      <= "00000001"; -- 1
    ALU_op_sig <= "00";       -- ADD
    wait for 10 ns;

    -- ======================
    -- SUB: 20 - 5 = 15
    -- ======================
    A_sig      <= "00010100"; -- 20
    B_sig      <= "00000101"; -- 5
    ALU_op_sig <= "01";       -- SUB
    wait for 10 ns;

    -- ======================
    -- AND: 1100 AND 1010 = 1000
    -- ======================
    A_sig      <= "00001100";
    B_sig      <= "00001010";
    ALU_op_sig <= "10";       -- AND
    wait for 10 ns;

    -- ======================
    -- OR: 1100 OR 1010 = 1110
    -- ======================
    ALU_op_sig <= "11";       -- OR
    wait for 10 ns;

    -- ======================
    -- ZERO test: 5 - 5 = 0
    -- ======================
    A_sig      <= "00000101";
    B_sig      <= "00000101";
    ALU_op_sig <= "01";       -- SUB
    wait for 10 ns;

    -- End simulation
    wait;

  end process;

end architecture;