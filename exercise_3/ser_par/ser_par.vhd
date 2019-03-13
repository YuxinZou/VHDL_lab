library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity ser_par is
	port( clk : in std_logic;
			ncl : in std_logic;
			reset : in std_logic;
			i_enable : in std_logic;
			i_serial_in : in std_logic;
			o_parallel_out : out std_logic_vector(25 downto 0);
			o_conv_complete : out std_logic
	);
end ser_par;


architecture behavioral of ser_par is

signal o_conv_complete_reg : std_logic :='0';
signal tem_out : std_logic_vector (26 downto 0) := (others => '0');
signal o_parallel_out_reg : std_logic_vector (25 downto 0) := (others => '0');

begin



process(clk,ncl)
begin
	if (ncl = '0') then        
			o_conv_complete_reg<='0';
			o_parallel_out_reg<= (others => '0');
			tem_out<= (others => '0');
   	elsif (rising_edge(clk)) then
        	if (reset = '1') then  		
        		o_conv_complete_reg <='0';
			o_parallel_out_reg<= (others => '0');
			tem_out<= (others => '0');
        	elsif ((tem_out(26) = '0')) then
			tem_out <= tem_out(25 downto 0) & i_serial_in;
			else
				o_conv_complete_reg <= '1';
				o_parallel_out_reg<= tem_out(25 downto 0);
			
        	end if;
    	end if;
end process;

o_parallel_out<= o_parallel_out_reg;
o_conv_complete<=o_conv_complete_reg;

end behavioral;
