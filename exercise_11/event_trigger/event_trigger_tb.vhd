library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity event_trigger_tb is
end event_trigger_tb;

architecture beh of event_trigger_tb is

--Component declaration for the Unit Under Test (UUT)
component event_trigger
	generic (G_PADDLE_EVENT_INTERVAL : integer := 100000;
            G_BALL_EVENT_INTERVAL : integer := 20000);
port (clk : in std_logic;
         reset : in std_logic;
         
         o_paddle_event : out std_logic;
         o_ball_event : out std_logic);
end component;

	signal clk :  std_logic := '0';
         signal reset :  std_logic := '0';
         
         signal o_paddle_event :  std_logic := '0';
         signal o_ball_event :  std_logic := '0';
begin
   --Instantiate the Unit Under Test (UUT)
   uut_event_trigger : event_trigger 
	   port map (clk => clk,
			reset => reset,
			o_paddle_event => o_paddle_event,
			o_ball_event => o_ball_event);
   
   
   --Clock
   process
   begin
      clk <= '0';
      wait for 10 ns;
      clk <= '1';
      wait for 10 ns;
      
      --Stop the simulation
   end process;

reset <= '1', '0' after 50 ns;

end beh;