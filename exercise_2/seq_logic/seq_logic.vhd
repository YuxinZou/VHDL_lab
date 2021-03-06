library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity seq_logic is
  port (clk   : in std_logic := '0';
        reset : in std_logic := '0';

        i_a : in std_logic := '0';
        i_b : in std_logic := '0';

        o_q : out std_logic := '0');
end seq_logic;



architecture rtl of seq_logic is

-- signal declaration
signal x:std_logic;

-- component declaration

component comb_logic is
		port(	i_a,i_b:in std_logic;
		     	o_c : out std_logic);
end component comb_logic;

component reg is
		port(	clk : in std_logic;
         		reset : in std_logic;
         		i_d : in std_logic;
         		o_q : out std_logic);
end component reg; 
  

begin

-- component instantiation

 
comp_comb_logic : comb_logic
			port map (i_a=>i_a,
				  i_b=>i_b,
				  o_c=>x); 
comp_reg : reg
			port map (clk=>clk,
				  reset=>reset,
				  i_d=>x,
				  o_q=>o_q);


end rtl;

