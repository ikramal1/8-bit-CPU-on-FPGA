library ieee;
use ieee.std_logic_1164.all;


entity reg is

port(
     clk,rst,out_en,load: in std_logic;
	 input              : in std_logic_vector(7 downto 0);
	 output             : out std_logic_vector(7 downto 0)

);

end reg;

architecture behave of reg is

signal stored_value : std_logic_vector(7 downto 0) ;

begin

process(clk, rst)
begin
     if rst = '1' then
	     stored_value<=(others=>'0');
	 elsif rising_edge(clk) then
	     if load = '1' then
		     stored_value <= input;
		 end if;
	 end if;
end process;

output<= stored_value when out_en = '1' else (others=>'Z');

end behave;
