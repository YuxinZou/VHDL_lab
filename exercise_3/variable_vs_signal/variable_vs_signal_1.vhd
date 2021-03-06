library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.numeric_std.all;



entity variable_vs_signal_1 is
  port (clk   : in  std_logic;
        reset : in  std_logic;
        a_in  : in  std_logic_vector (3 downto 0) := "0000";
        b_in  : in  std_logic_vector (3 downto 0) := "0000";
        q     : out std_logic_vector (15 downto 0));
end variable_vs_signal_1;

architecture behavioral of variable_vs_signal_1 is

begin



  calc : process (clk, reset)

  variable int_c: integer    :=0;
  variable int_d: integer range 0 to 511  :=0;
  variable int_e: integer range 0 to 8400 :=0;

  begin
	if rising_edge(clk) then
		if (reset = '1') then
			int_c := 0;
			int_d := 0;
			int_e := 0;
		else
			int_c := to_integer(unsigned(a_in)) + to_integer(unsigned(b_in));
			int_d := int_c * to_integer(unsigned(b_in));
			int_e := int_d * to_integer(unsigned(b_in)) + to_integer(unsigned(a_in));
			q <= std_logic_vector(to_unsigned(int_e,16));
		end if;
	end if; 
	
  end process calc;
  
end behavioral;
