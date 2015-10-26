-- $Id: $
-- File name:   tb_math_raster_test.vhd
-- Created:     11/27/2011
-- Author:      Ashwin Shankar
-- Lab Section: 337-04
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_math_raster_test is
end tb_math_raster_test;

architecture TEST of tb_math_raster_test is

  function UINT_TO_STD_LOGIC( X: INTEGER; NumBits: INTEGER )
     return STD_LOGIC_VECTOR is
  begin
    return std_logic_vector(to_unsigned(X, NumBits));
  end;

  function STD_LOGIC_TO_UINT( X: std_logic_vector)
     return integer is
  begin
    return to_integer(unsigned(x));
  end;

  component math_raster_test
    PORT(
         clk : IN std_logic;
         control : IN std_logic;
         data_in : IN std_logic_vector (7 DOWNTO 0 );
         data_in_ram : IN std_logic_vector (15 DOWNTO 0 );
         external_trigger : IN std_logic;
         reset : IN std_logic;
         z_l : IN std_logic_vector (7 DOWNTO 0 );
         Addr : OUT std_logic_vector (15 DOWNTO 0);
         finsihed_boundary_out : OUT std_logic;
         input_fifo_empty : OUT std_logic;
         input_fifo_full : OUT std_logic;
         write_to_memory_controller : OUT std_logic;
         write_to_memory_controller_shader : OUT std_logic
    );
  end component;

-- Insert signals Declarations here
  signal clk : std_logic;
  signal control : std_logic;
  signal data_in : std_logic_vector (7 DOWNTO 0 );
  signal data_in_ram : std_logic_vector (15 DOWNTO 0 );
  signal external_trigger : std_logic;
  signal reset : std_logic;
  signal z_l : std_logic_vector (7 DOWNTO 0 );
  signal Addr : std_logic_vector (15 DOWNTO 0);
  signal finsihed_boundary_out : std_logic;
  signal input_fifo_empty : std_logic;
  signal input_fifo_full : std_logic;
  signal write_to_memory_controller : std_logic;
  signal write_to_memory_controller_shader : std_logic;

-- signal <name> : <type>;
constant Period1 : time := 10 ns;


begin

 CLKGEN1: process
   variable clk_tmp: std_logic := '0'; 
 begin
   clk_tmp := not clk_tmp;
   clk <= clk_tmp;
   wait for Period1/2;
 end process CLKGEN1;

  DUT: math_raster_test port map(
                clk => clk,
                control => control,
                data_in => data_in,
                data_in_ram => data_in_ram,
                external_trigger => external_trigger,
                reset => reset,
                z_l => z_l,
                Addr => Addr,
                finsihed_boundary_out => finsihed_boundary_out,
                input_fifo_empty => input_fifo_empty,
                input_fifo_full => input_fifo_full,
                write_to_memory_controller => write_to_memory_controller,
                write_to_memory_controller_shader => write_to_memory_controller_shader
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here


 



--first X co ordinate


   control <= '1';

    data_in <= X"00";

    data_in_ram <= X"0000";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";


		wait for 2.5 ns;
 
   control <= '1';

    data_in <= X"00";

    data_in_ram <= X"0000";

    external_trigger <= '0';

    reset <= '1';

    z_l <= X"40";


		wait for 2.5 ns;

    control <= '1';

    data_in <= X"00";

    data_in_ram <= X"0000";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";


		wait for 10 ns;

   control <= '1';

    data_in <= X"20";

    data_in_ram <= X"0000";

    external_trigger <= '1';

    reset <= '0';

    z_l <= X"40";


    wait for 20 ns;
   
    control <= '1';

    data_in <= X"40";

    data_in_ram <= X"0000";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";


    wait for 10 ns;

    control <= '1';

    data_in <= X"40";

    data_in_ram <= X"0000";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";


    wait for 10 ns;

    control <= '1';

    data_in <= X"22";

    data_in_ram <= X"0000";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";


    wait for 10 ns;    

--First y co ordinate

    wait for 300 ns;
   control <= '1';

    data_in <= X"E0";

    data_in_ram <= X"0000";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";


    wait for 20 ns;
   
   control <= '1';

    data_in <= X"40";

    data_in_ram <= X"0000";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";


    wait for 10 ns;
   control <= '1';

    data_in <= X"40";

    data_in_ram <= X"0000";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";


    wait for 10 ns;

   control <= '1';

    data_in <= X"22";

    data_in_ram <= X"0000";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";


    wait for 370 ns;

--Second X co ordinate

   control <= '1';

    data_in <= X"20";

    data_in_ram <= X"0000";

    external_trigger <= '1';

    reset <= '0';

    z_l <= X"40";


    wait for 20 ns;
   
    control <= '1';

    data_in <= X"40";

    data_in_ram <= X"0000";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";


    wait for 10 ns;

    control <= '1';

    data_in <= X"40";

    data_in_ram <= X"0000";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";


    wait for 10 ns;

    control <= '1';

    data_in <= X"22";

    data_in_ram <= X"0000";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";


    wait for 10 ns;    

--Second y co ordinate

    wait for 300 ns;
   control <= '1';

    data_in <= X"20";

    data_in_ram <= X"0000";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";


    wait for 20 ns;
   
   control <= '1';

    data_in <= X"40";

    data_in_ram <= X"0000";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";


    wait for 10 ns;
   control <= '1';

    data_in <= X"40";

    data_in_ram <= X"0000";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";


    wait for 10 ns;

   control <= '1';

    data_in <= X"22";

    data_in_ram <= X"0000";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";


    wait for 370 ns;

--Third X co ordinate

   control <= '1';

    data_in <= X"E0";

    data_in_ram <= X"0000";

    external_trigger <= '1';

    reset <= '0';

    z_l <= X"40";


    wait for 20 ns;
   
    control <= '1';

    data_in <= X"40";

    data_in_ram <= X"0000";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";


    wait for 10 ns;

    control <= '1';

    data_in <= X"40";

    data_in_ram <= X"0000";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";


    wait for 10 ns;

    control <= '1';

    data_in <= X"22";

    data_in_ram <= X"0000";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";


    wait for 10 ns;    

--third y co ordinate

    wait for 300 ns;
   control <= '1';

    data_in <= X"20";

    data_in_ram <= X"0000";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";


    wait for 20 ns;
   
   control <= '1';

    data_in <= X"40";

    data_in_ram <= X"0000";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";


    wait for 10 ns;
   control <= '1';

    data_in <= X"40";

    data_in_ram <= X"0000";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";


    wait for 10 ns;

   control <= '1';

    data_in <= X"22";

    data_in_ram <= X"0000";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";


    wait for 370 ns;

--Fourth X co ordinate
   control <= '1';

    data_in <= X"E0";

    data_in_ram <= X"0000";

    external_trigger <= '1';

    reset <= '0';

    z_l <= X"40";


    wait for 20 ns;
   
    control <= '1';

    data_in <= X"40";

    data_in_ram <= X"0000";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";


    wait for 10 ns;

    control <= '1';

    data_in <= X"40";

    data_in_ram <= X"0000";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";


    wait for 10 ns;

    control <= '1';

    data_in <= X"22";

    data_in_ram <= X"0000";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";


    wait for 10 ns;    

--fourth y co ordinate

    wait for 300 ns;
   control <= '1';

    data_in <= X"E0";

    data_in_ram <= X"0000";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";


    wait for 20 ns;
   
   control <= '1';

    data_in <= X"40";

    data_in_ram <= X"0000";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";


    wait for 10 ns;
   control <= '1';

    data_in <= X"40";

    data_in_ram <= X"0000";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";


    wait for 10 ns;

   control <= '1';

    data_in <= X"22";

    data_in_ram <= X"0000";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";


    wait ;










  end process;
end TEST;
