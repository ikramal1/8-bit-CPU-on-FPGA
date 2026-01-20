library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
  port(
    oe       : in std_logic;
    A        : in  std_logic_vector(7 downto 0);
    B        : in  std_logic_vector(7 downto 0);
    ALU_op   : in  std_logic_vector(1 downto 0);
    Result   : out std_logic_vector(7 downto 0);
    Carry    : out std_logic;
    Zero     : out std_logic
  );
end alu;

architecture rtl of alu is
  signal temp : unsigned(8 downto 0);
begin

  process(A, B, ALU_op)
  begin
    case ALU_op is
      when "00" =>  -- ADD
        temp <= ('0' & unsigned(A)) + ('0' & unsigned(B));

      when "01" =>  -- SUB
        temp <= ('0' & unsigned(A)) - ('0' & unsigned(B));

      when "10" =>  -- AND
        temp <= '0' & (unsigned(A) and unsigned(B));

      when "11" =>  -- OR
        temp <= '0' & (unsigned(A) or unsigned(B));

      when others =>
        temp <= (others => '0');
    end case;
  end process;

  Result <= std_logic_vector(temp(7 downto 0)) when oe='1' else (others=>'Z');
  Carry  <= temp(8);
  Zero   <= '1' when temp(7 downto 0) = "00000000" else '0';

end rtl;