-- $Id: $
-- File name:   tb_matrix_math.vhd
-- Created:     12/5/2011
-- Author:      Aashish Raj Simha
-- Lab Section: 337-04
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_matrix_math is
end tb_matrix_math;

architecture TEST of tb_matrix_math is

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

  component matrix_math
    PORT(
         clk : IN std_logic;
         data_in : IN std_logic_vector (15 DOWNTO 0 );
         external_trigger : IN std_logic;
         reset : IN std_logic;
         write_enable : IN std_logic;
         z_l : IN std_logic_vector (7 DOWNTO 0 );
         input_fifo_empty : OUT std_logic;
         input_fifo_full : OUT std_logic;
         output_buffer_empty : OUT std_logic;
         output_buffer_full : OUT std_logic;
         shadow_vertices : OUT std_logic_vector (15 DOWNTO 0);
         write_to_memory_controller : OUT std_logic
    );
  end component;

-- Insert signals Declarations here
  signal clk : std_logic;
  signal data_in : std_logic_vector (15 DOWNTO 0 );
  signal external_trigger : std_logic;
  signal reset : std_logic;
  signal write_enable : std_logic;
  signal z_l : std_logic_vector (7 DOWNTO 0 );
  signal input_fifo_empty : std_logic;
  signal input_fifo_full : std_logic;
  signal output_buffer_empty : std_logic;
  signal output_buffer_full : std_logic;
  signal shadow_vertices : std_logic_vector (15 DOWNTO 0);
  signal write_to_memory_controller : std_logic;

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


  DUT: matrix_math port map(
                clk => clk,
                data_in => data_in,
                external_trigger => external_trigger,
                reset => reset,
                write_enable => write_enable,
                z_l => z_l,
                input_fifo_empty => input_fifo_empty,
                input_fifo_full => input_fifo_full,
                output_buffer_empty => output_buffer_empty,
                output_buffer_full => output_buffer_full,
                shadow_vertices => shadow_vertices,
                write_to_memory_controller => write_to_memory_controller
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

    -- Insert TEST BENCH Code Here

    data_in <= X"0000";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";
    
    write_enable <= '0' ; 

		wait for 2.5 ns;
 
    data_in <= X"0000";

    external_trigger <= '0';

    reset <= '1';

    z_l <= X"40"; 
    
      write_enable <= '0' ;

		wait for 2.5 ns;

    data_in <= X"0000";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";

     write_enable <= '0' ;

		wait for 10 ns;

    data_in <= X"0020";

    external_trigger <= '1';

    reset <= '0';

    z_l <= X"40";
      write_enable <= '1' ;

    wait for 10 ns;
      write_enable <= '0' ;  
    wait for 10 ns;
   
    data_in <= X"0040";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";
    
      write_enable <= '1' ;

    wait for 10 ns;

    data_in <= X"0040";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";
    
     write_enable <= '1' ;

    wait for 10 ns;

    data_in <= X"0022";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";

      write_enable <= '1' ;

    wait for 10 ns;    
  write_enable <= '0' ;
    wait for 300 ns;
		data_in <= X"00E0";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";
    
     write_enable <= '1' ;

    wait for 10 ns;
      write_enable <= '0' ;  
    wait for 10 ns;
   
    data_in <= X"0040";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";

    write_enable <= '1' ;

    wait for 10 ns;

    data_in <= X"0040";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";
    
     write_enable <= '1' ;

    wait for 10 ns;

    data_in <= X"0022";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";
     write_enable <= '1' ;
   wait for 10 ns ; 
  write_enable <= '0' ;
    wait for 350 ns;

--Second co ordinate
    data_in <= X"0020";

    external_trigger <= '1';

    reset <= '0';

    z_l <= X"40";
     write_enable <= '1' ;

    wait for 10 ns;
      write_enable <= '0' ;  
    wait for 10 ns;
   
    data_in <= X"0040";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";
     write_enable <= '1' ;

    wait for 10 ns;

    data_in <= X"0040";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";
     write_enable <= '1' ;

    wait for 10 ns;

    data_in <= X"0022";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";
     write_enable <= '1' ;

    wait for 10 ns;    
  write_enable <= '0' ;
    wait for 300 ns;
		data_in <= X"0020";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";
    write_enable <= '1' ;
    wait for 10 ns;
      write_enable <= '0' ;  
    wait for 10 ns;
   
    data_in <= X"0040";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";
    write_enable <= '1' ;
    wait for 10 ns;

    data_in <= X"0040";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";
   write_enable <= '1' ;
    wait for 10 ns;

    data_in <= X"0022";

    external_trigger <= '0';

    reset <= '0';

    z_l <= X"40";
  write_enable <= '1' ;
  wait for 10 ns;
  write_enable<='0';
    wait ;

  end process;
end TEST;
