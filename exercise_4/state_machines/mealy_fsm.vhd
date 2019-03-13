library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--Mealy state machine with unregistered outputs

entity mealy_fsm is
   port (clk : in std_logic := '0';
         reset : in std_logic := '0';
         
         i_a : in std_logic := '0';
         i_b : in std_logic := '0';
         
         o_c : out std_logic := '0';
         o_d : out std_logic := '0');
end mealy_fsm;



architecture rtl of mealy_fsm is

type fsm_states is (STATE_ONE, STATE_TWO, STATE_THREE);
signal state_fsm : fsm_states := STATE_ONE;
begin
state_transitions : process(clk)
		begin
			if rising_edge(clk) then
				if reset = '1' then
					state_fsm <= STATE_ONE;
					o_c <= '0';
					o_d <= '0';
				else
					case state_fsm is
						when STATE_ONE =>
								state_fsm <= STATE_TWO;
								o_c <= '0';
								o_d <= '1';
						when STATE_TWO =>
							if (i_a = '0' AND i_b = '1') then
								state_fsm <= STATE_THREE;
								o_c <= '0';
								o_d <= '0';
							elsif (i_a = '1' AND i_b = '1') then
								state_fsm <= STATE_THREE;
								o_c <= '0';
								o_d <= '1';
							else
								state_fsm <= STATE_TWO;
								o_c <= '1';
								o_d <= '0';	
							end if;
						when STATE_THREE =>
							if (i_a = '1' AND i_b = '0') then
								state_fsm <= STATE_ONE;
								o_c <= '1';
								o_d <= '1';
							elsif (i_b = '1') then
								state_fsm <= STATE_TWO;
								o_c <= '0';
								o_d <= '1';
							else
								state_fsm <= STATE_THREE;
								o_c <= '1';
								o_d <= '1';	
							end if;
	
					end case;
				end if;
			end if;
		end process state_transitions;
  
end rtl;
