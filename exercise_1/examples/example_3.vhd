library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity example is
   port (i_in : in std_logic := '0';
         
         o_out : out std_logic := '0');
end example;



architecture rtl of example is

signal a : std_logic := '0';

begin
   process (i_in, a)
   begin 
      a <= i_in;
      o_out <= a;
   end process;
   
end rtl;
