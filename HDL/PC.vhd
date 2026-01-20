library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
      port(
	    clk,rst,en,ld : in std_logic;
		input         : in std_logic_vector(3 downto 0);
		output        : out std_logic_vector(3 downto 0)
	  
	  );
	  
end pc;

architecture archi of pc is 

signal count : std_logic_vector(3 downto 0) := "0000";

begin 

process(clk, rst)
begin
    if rst= '1' then count <= (others=>'0');
	elsif rising_edge(clk) then 
	   if ld ='1' then count <= input;
	   elsif en ='1' then count <= count + 1;
	   end if;
	end if;
end process;

output <= count;

end archi;

	
