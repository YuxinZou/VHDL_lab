library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--This module generates events for ball or paddle movement. This is done with
--a counter for each event. When the counter reaches its limit it is reset
--to 0 and the event output signal is set to 1 for one clock cycle.

entity event_trigger is
   --generics: 
   --G_PADDLE_EVENT_INTERVAL  : clock cycles between two paddle events
   --G_BALL_EVENT_INTERVAL    : clock cycles between two ball events
   generic (G_PADDLE_EVENT_INTERVAL : integer := 100000;
            G_BALL_EVENT_INTERVAL : integer := 20000);
   
   --ports:
   --clk             : system clock
   --reset           : synchronous reset
   --
   --o_paddle_event  : set to one if a paddle event occurs
   --o_ball_event    : set to one if a ball event occurs
   port (clk : in std_logic := '0';
         reset : in std_logic := '0';
         
         o_paddle_event : out std_logic := '0';
         o_ball_event : out std_logic := '0');
end event_trigger;



architecture rtl of event_trigger is

signal counter_paddle : integer := 0;
signal counter_ball : integer := 0;

begin
process(clk)
begin
if rising_edge(clk) then
      if reset = '1' then
	counter_paddle <= 0;
	counter_ball <= 0;
	o_paddle_event <= '0';
	o_ball_event <= '0';
      else
	if(counter_paddle < G_PADDLE_EVENT_INTERVAL ) then
		counter_paddle <= counter_paddle + 1;
		o_paddle_event <= '0';
	else
		counter_paddle <= 0;
		o_paddle_event <= '1';
	end if;

	if(counter_ball < G_BALL_EVENT_INTERVAL) then
		counter_ball <= counter_ball + 1;
		o_ball_event <= '0';
	else
		counter_ball <= 0;
		o_ball_event <= '1';
	end if;
end if;
end if;
end process;





  
end rtl;

