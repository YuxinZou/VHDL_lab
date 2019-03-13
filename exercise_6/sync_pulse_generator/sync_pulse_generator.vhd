library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--This module creates the horizontal and vertical synchronisation impulses for
--the monitor.
--It also sets an output when the electron beam on the screen is in the active 
--picture area.
--The first and last rows and columns of a picture are not displayed. They are 
--used for synchronisation impulses and to move the electron beam back to the 
--left or top of the screen. For that time the colour data must not be send to 
--the monitor because otherwise it could not synchronise correctly. To indicate 
--if the electron beam is in the picture area, there is an output called 
--in_active_region.

entity sync_pulse_generator is
   --generics:
   --G_H_PIXEL_NUMBER   : horizontal pixel number (incl. non visible)
   --G_H_RESOLUTION     : horizontal resolution
   --G_H_FRONT_PORCH    : horizontal front porch length in pixels
   --G_H_BACK_PORCH     : horizontal back porch length in pixels
   --G_H_SYNC_LENGTH    : horizontal sync pulse length in pixels
   --G_H_SYNC_ACTIVE    : horizontal sync pulse polarity (1 = pos, 0 = neg)
   --
   --G_V_PIXEL_NUMBER   : vertical pixel number (incl. non visible)
   --G_V_RESOLUTION     : vertical resolution
   --G_V_FRONT_PORCH    : vertical front porch length in pixels
   --G_V_BACK_PORCH     : vertical back porch length in pixels
   --G_V_SYNC_LENGTH    : vertical sync pulse length in pixels
   --G_V_SYNC_ACTIVE    : vertical sync pulse polarity (1 = pos, 0 = neg)
   generic (G_H_PIXEL_NUMBER : integer := 800;
            G_H_RESOLUTION : integer := 640;
            G_H_FRONT_PORCH : integer := 8;
            G_H_BACK_PORCH : integer := 48;
            G_H_SYNC_LENGTH : integer := 96;
            G_H_SYNC_ACTIVE : std_logic := '0';
             
            G_V_PIXEL_NUMBER : integer := 525;
            G_V_RESOLUTION : integer := 480;
            G_V_FRONT_PORCH : integer := 2;
            G_V_BACK_PORCH : integer := 33;
            G_V_SYNC_LENGTH : integer := 2;
            G_V_SYNC_ACTIVE : std_logic := '0');

   port (clk : in  std_logic := '0';
         reset : in std_logic := '0';
         
         o_h_sync : out std_logic := G_H_SYNC_ACTIVE;
         o_v_sync : out std_logic := G_V_SYNC_ACTIVE;
         o_in_active_region : out std_logic := '0');
end sync_pulse_generator;



architecture rtl of sync_pulse_generator is

signal o_h_sync_reg :  std_logic := G_H_SYNC_ACTIVE;
signal o_v_sync_reg :  std_logic := G_V_SYNC_ACTIVE;
signal o_in_active_region_reg :  std_logic := '0';
signal cnt_h_sync : integer := 0;
signal cnt_v_sync : integer := 0;

begin
o_h_sync<= o_h_sync_reg;
o_v_sync<= o_v_sync_reg;
o_in_active_region <= o_in_active_region_reg;
	-- set horizontal sync pulse
	process(cnt_h_sync,reset)
	begin
		if (reset= '1') then
			o_h_sync_reg <= NOT(G_H_SYNC_ACTIVE);
		elsif ((G_H_FRONT_PORCH -1 < cnt_h_sync) and (cnt_h_sync < (G_H_FRONT_PORCH + G_H_SYNC_LENGTH))) then
			o_h_sync_reg <= G_H_SYNC_ACTIVE;
		else
			o_h_sync_reg <= NOT(G_H_SYNC_ACTIVE);
		end if;
	end process;
		
	-- set vertical sync pulse
	process(cnt_v_sync,reset)
	begin
		if (reset= '1') then
			o_v_sync_reg <= NOT(G_V_SYNC_ACTIVE);
		elsif ((G_V_FRONT_PORCH -1 < cnt_v_sync) and (cnt_v_sync< (G_V_FRONT_PORCH + G_V_SYNC_LENGTH))) then
			o_v_sync_reg <= G_V_SYNC_ACTIVE;
		else
			o_v_sync_reg <= NOT(G_V_SYNC_ACTIVE);
		end if;
	end process;

	-- set active region
	process(cnt_v_sync,reset,cnt_h_sync)
	begin
		if (reset= '1') then
			o_in_active_region_reg <= '0';
		elsif (((G_H_FRONT_PORCH + G_H_BACK_PORCH + G_H_SYNC_LENGTH-1) < cnt_h_sync ) and (cnt_h_sync< (G_H_FRONT_PORCH + G_H_BACK_PORCH + G_H_SYNC_LENGTH + G_H_RESOLUTION)) and ((G_V_FRONT_PORCH + G_V_BACK_PORCH + G_V_SYNC_LENGTH-1) < cnt_v_sync) and (cnt_v_sync< (G_V_FRONT_PORCH + G_V_BACK_PORCH + G_V_SYNC_LENGTH + G_V_RESOLUTION))) then
			o_in_active_region_reg <= '1';
		else
			o_in_active_region_reg <= '0';
		end if;
	end process;

	-- counter for horizontal lines
	process(clk,reset)
	begin
		if(reset= '1') then
			cnt_h_sync <= 0;
		elsif(rising_edge(clk)) then
			if(cnt_h_sync < G_H_PIXEL_NUMBER - 1) then
				cnt_h_sync <= cnt_h_sync + 1;
			else
				cnt_h_sync <= 0;
			end if;
		end if;
	end process;

	--counter for vertical lines
	process(clk,reset)
	begin
		if(reset= '1') then
			cnt_v_sync <= 0;
		elsif(rising_edge(clk)) then
			if(cnt_v_sync < G_V_PIXEL_NUMBER - 1) then
				if(cnt_h_sync = G_H_PIXEL_NUMBER - 1) then
					cnt_v_sync <= cnt_v_sync + 1;
				end if;
			else
				if(cnt_h_sync = G_H_PIXEL_NUMBER - 1) then
					cnt_v_sync <= 0;
				end if;
			end if;		
		end if;
	end process;

	 	
end rtl;

