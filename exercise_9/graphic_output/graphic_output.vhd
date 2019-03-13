library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use work.graphic_output_package.all;
entity graphic_output is
  generic (G_H_PIXEL_NUMBER : integer;
           G_H_RESOLUTION   : integer;
           G_H_FRONT_PORCH  : integer;
           G_H_BACK_PORCH   : integer;
           G_H_SYNC_LENGTH  : integer;
           G_H_SYNC_ACTIVE  : std_logic;

           G_V_PIXEL_NUMBER : integer;
           G_V_RESOLUTION   : integer;
           G_V_FRONT_PORCH  : integer;
           G_V_BACK_PORCH   : integer;
           G_V_SYNC_LENGTH  : integer;
           G_V_SYNC_ACTIVE  : std_logic);

  port(
    clk   : in std_logic := '0';
    reset : in std_logic := '0';

    i_read_done       : in std_logic                       := '0';
    i_read_data       : in std_logic_vector (32*8-1 downto 0) := (others => '0');
    i_new_frame_ready : in std_logic                       := '0';

    o_h_sync        : out std_logic                      := '0';
    o_v_sync        : out std_logic                      := '0';
    o_red           : out std_logic_vector(2 downto 0)   := (others => '0');
    o_green         : out std_logic_vector(2 downto 0)   := (others => '0');
    o_blue          : out std_logic_vector(1 downto 0)   := (others => '0');
    o_read_req      : out std_logic                      := '0';
    o_read_address  : out std_logic_vector (22 downto 0) := (others => '0');
    o_page_switched : out std_logic                      := '0');

end graphic_output;


architecture rtl of graphic_output is
signal shift_enable : std_logic;
signal select_buffer  :std_logic;
signal not_select_buffer  :std_logic;
signal load_reg :std_logic;
signal data_req_0 : std_logic;
signal data_req_1 : std_logic;
signal rgb_reg_0 : std_logic_vector (7 downto 0);
signal rgb_reg_1 : std_logic_vector (7 downto 0);

begin
comp_sync_pulse_generator : sync_pulse_generator
	generic map(
	    G_H_PIXEL_NUMBER => G_H_PIXEL_NUMBER,
            G_H_RESOLUTION => G_H_RESOLUTION,
            G_H_FRONT_PORCH => G_H_FRONT_PORCH,
            G_H_BACK_PORCH =>  G_H_BACK_PORCH,
            G_H_SYNC_LENGTH => G_H_SYNC_LENGTH,
            G_H_SYNC_ACTIVE => G_H_SYNC_ACTIVE,
             
            G_V_PIXEL_NUMBER => G_V_PIXEL_NUMBER,
            G_V_RESOLUTION => G_V_RESOLUTION,
            G_V_FRONT_PORCH =>  G_V_FRONT_PORCH,
            G_V_BACK_PORCH => G_V_BACK_PORCH,
            G_V_SYNC_LENGTH => G_V_SYNC_LENGTH,
            G_V_SYNC_ACTIVE => G_V_SYNC_ACTIVE)
	port map(
		clk => clk,
		reset  => reset,
         	o_h_sync  => o_h_sync,
         	o_v_sync  => o_v_sync,
         	o_in_active_region  => shift_enable);

comp_graphic_buffer_0 : graphic_buffer
	port map(
		clk => clk,
		reset  => reset,
        	i_select => not_select_buffer,
        	i_shift_enable => shift_enable,
       		i_load => load_reg,
        	i_rgb_data => i_read_data,
        	o_data_req => data_req_0,
       		o_rgb => rgb_reg_0);

comp_graphic_buffer_1 : graphic_buffer
	port map(
		clk => clk,
		reset  => reset,
        	i_select => select_buffer,
        	i_shift_enable => shift_enable,
       		i_load => load_reg,
        	i_rgb_data => i_read_data,
        	o_data_req => data_req_1,
       		o_rgb => rgb_reg_1);

comp_graphic_buffer_controller  : graphic_buffer_controller
  generic map (G_H_RESOLUTION => G_H_RESOLUTION,
          G_V_RESOLUTION => G_V_RESOLUTION)
  	port map(
		clk => clk,
		reset  => reset,
        	i_data_req_reg_0 => data_req_0,
        	i_data_req_reg_1 => data_req_1,
        	i_read_done => i_read_done,
        	i_new_frame_ready => i_new_frame_ready,
        	o_reg_select => select_buffer,
        	o_load_reg =>  load_reg ,
        	o_read_req => o_read_req,
        	o_read_address => o_read_address,
        	o_page_switched => o_page_switched);

o_red<= rgb_reg_1(7 downto 5) when(select_buffer = '1' AND shift_enable = '1') else
	rgb_reg_0(7 downto 5) when (select_buffer = '0' AND shift_enable = '1') else
	"000";

o_green <= rgb_reg_1(4 downto 2) when(select_buffer = '1' AND shift_enable = '1') else
	   rgb_reg_0(4 downto 2) when (select_buffer = '0' AND shift_enable = '1') else
	   (others => '0');

o_blue <= rgb_reg_1(1 downto 0) when(select_buffer = '1' AND shift_enable = '1') else
          rgb_reg_0(1 downto 0) when (select_buffer = '0' AND shift_enable = '1') else
	  (others => '0');

not_select_buffer <= not(select_buffer);
end rtl;
