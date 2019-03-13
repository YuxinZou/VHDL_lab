library IEEE;
use IEEE.STD_LOGIC_1164.all;

package graphic_output_package is

component sync_pulse_generator is
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
	port(
		clk : in  std_logic;
        	reset : in std_logic;
         	o_h_sync : out std_logic;
         	o_v_sync : out std_logic;
         	o_in_active_region : out std_logic);
end component sync_pulse_generator;

component graphic_buffer is
  port (clk   : in std_logic;
        reset : in std_logic;

        i_select       : in std_logic;
        i_shift_enable : in std_logic;
        i_load         : in std_logic;
        i_rgb_data     : in std_logic_vector (32*8-1 downto 0);

        o_data_req : out std_logic;
        o_rgb      : out std_logic_vector (7 downto 0));
end component graphic_buffer;

component graphic_buffer_controller is
  generic (G_H_RESOLUTION : integer := 640;
           G_V_RESOLUTION : integer := 480);
  port (clk   : in std_logic;
        reset : in std_logic;

        i_data_req_reg_0  : in std_logic;
        i_data_req_reg_1  : in std_logic;
        i_read_done       : in std_logic;
        i_new_frame_ready : in std_logic;

        o_reg_select    : out std_logic;
        o_load_reg      : out std_logic;
        o_read_req      : out std_logic;
        o_read_address  : out std_logic_vector (22 downto 0);
        o_page_switched : out std_logic);
end component graphic_buffer_controller;



end graphic_output_package;
