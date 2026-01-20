library ieee;
use ieee.std_logic_1164.all;

entity reg_tb is
end reg_tb;

architecture archi of reg_tb is

component reg is
port(
     clk,rst,out_en,load: in std_logic;
     input              : in std_logic_vector(7 downto 0);
     output             : out std_logic_vector(7 downto 0)
);
end component;

signal clk_sig ,rst_sig ,out_en_sig ,load_sig : std_logic := '0';
signal input_sig : std_logic_vector(7 downto 0) := (others => '0');
signal output_sig: std_logic_vector(7 downto 0);

constant clk_period : time := 10 ns;

begin

uut: reg port map(
  clk    => clk_sig,
  rst    => rst_sig,
  out_en => out_en_sig,
  load   => load_sig,
  input  => input_sig,
  output => output_sig
);

clk_process : process
begin
  while true loop
    clk_sig <= '0';
    wait for clk_period/2;
    clk_sig <= '1';
    wait for clk_period/2;
  end loop;
end process;

stim_process : process
begin
  rst_sig    <= '1';
  out_en_sig <= '0';
  load_sig   <= '0';
  input_sig  <= "00000000";
  wait for 2*clk_period;

  rst_sig <= '0';
  wait for clk_period;

  out_en_sig <= '0';
  load_sig   <= '1';
  input_sig  <= "00001000";
  wait for clk_period;     
  
  load_sig <= '0';
  wait for 2*clk_period;

  out_en_sig <= '1';
  wait for 4*clk_period;

  wait;
end process;

end archi;