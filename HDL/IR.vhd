library ieee;
use ieee.std_logic_1164.all;


entity ir is
  port(
    clk   : in  std_logic;
    rst   : in  std_logic;
    load  : in  std_logic;
    oe    : in  std_logic;                  -- output enable (bus drive)
    din   : in  std_logic_vector(7 downto 0);
    dout   : out std_logic_vector(7 downto 0)
  );
end ir;

architecture rtl of ir is
  signal r : std_logic_vector(7 downto 0) := (others => '0');
begin
  process(clk, rst)
  begin
    if rst='1' then
      r <= (others => '0');
    elsif rising_edge(clk) then
      if load='1' then
        r <= din;
      end if;
    end if;
  end process;

  dout <= r when oe='1' else (others => 'Z');  -- tri-state
end rtl;