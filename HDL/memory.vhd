library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use ieee.std_logic_textio.all;

entity mem is
  port(
    clk      : in  std_logic;
    load     : in  std_logic;  -- write enable
    oe       : in  std_logic;  -- output enable (read)
    data_in  : in  std_logic_vector(7 downto 0);
    addr_in  : in  std_logic_vector(3 downto 0);
    data_out : out std_logic_vector(7 downto 0)
  );
end mem;

architecture behave of mem is
  type mem_type is array (0 to 15) of std_logic_vector(7 downto 0);

  function init(file_name : string) return mem_type is
    file file_data : text;
    variable fstatus     : file_open_status;
    variable text_line   : line;
    variable line_content: std_logic_vector(7 downto 0);
    variable i           : integer := 0;
    variable temp_mem    : mem_type := (others => (others => '0'));
  begin
    file_open(fstatus, file_data, file_name, READ_MODE);

    if fstatus /= OPEN_OK then
      report "ERROR: Cannot open memory init file: " & file_name severity warning;
      return temp_mem;
    end if;

    while (not endfile(file_data)) and (i <= 15) loop
      readline(file_data, text_line);
      read(text_line, line_content);      -- expects 8 chars like 01010101
      temp_mem(i) := line_content;
      i := i + 1;
    end loop;

    file_close(file_data);
    return temp_mem;
  end function;

  signal mon_obj : mem_type := init("init_mem.txt");

begin

  -- WRITE: synchronous
  process(clk)
  begin
    if rising_edge(clk) then
      if load = '1' then
        mon_obj(to_integer(unsigned(addr_in))) <= data_in;
      end if;
    end if;
  end process;

  -- READ: combinational (drives bus only when oe='1')
  data_out <= mon_obj(to_integer(unsigned(addr_in))) when oe = '1'
              else (others => 'Z');

end behave;