-- $Id: $
-- File name:   tb_output_buffer.vhd
-- Created:     12/2/2011
-- Author:      Ashwin Shankar
-- Lab Section: 337-04
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_output_buffer is
end tb_output_buffer;

architecture TEST of tb_output_buffer is

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

  component output_buffer
    PORT(
         reset : in std_logic;
         clk : in std_logic;
         adder_result : in std_logic_vector(15 downto 0 );
         shadow_vertices : out std_logic_vector(15 downto 0);
         write_enable : in std_logic;
         read_enable : in std_logic;
         output_buffer_empty : out std_logic;
         output_buffer_full : out std_logic
    );
  end component;

-- Insert signals Declarations here
  signal reset : std_logic;
  signal clk : std_logic;
  signal adder_result : std_logic_vector(15 downto 0 );
  signal shadow_vertices : std_logic_vector(15 downto 0);
  signal write_enable : std_logic;
  signal read_enable : std_logic;
  signal output_buffer_empty : std_logic;
  signal output_buffer_full : std_logic;

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


  DUT: output_buffer port map(
                reset => reset,
                clk => clk,
                adder_result => adder_result,
                shadow_vertices => shadow_vertices,
                write_enable => write_enable,
                read_enable => read_enable,
                output_buffer_empty => output_buffer_empty,
                output_buffer_full => output_buffer_full
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

-- Insert TEST BENCH Code Here

    reset <= '0';

   -- reset_buffer <='0' ;

    adder_result <= X"2345";

    write_enable <= '0';

    read_enable <= '0';

   wait for 2.5 ns;

    reset <= '1';

 --   reset_buffer <='0' ;

    adder_result <= X"2345";

    write_enable <= '0';

    read_enable <= '0';

   wait for 2.5 ns;

    reset <= '0';

    --reset_buffer <='0' ;

    adder_result <= X"2345";

    write_enable <= '0';

    read_enable <= '0';

   wait for 2.5 ns;

    reset <= '0';

   -- reset_buffer <='0' ;

    adder_result <= X"2345";

    write_enable <= '1';

    read_enable <= '0';

   wait for 10 ns;

    reset <= '0';

    --reset_buffer <='0' ;

    adder_result <= X"ABCD";

    write_enable <= '1';

    read_enable <= '0';

   wait for 10 ns;

    reset <= '0';

    --reset_buffer <='0' ;

    adder_result <= X"2345";

    write_enable <= '0';

    read_enable <= '1';

   wait for 20 ns;

    reset <= '0';

    --reset_buffer <='0' ;

    adder_result <= X"6745";

    write_enable <= '1';

    read_enable <= '0';

   wait for 10 ns;

    reset <= '0';

    --reset_buffer <='1' ;

    adder_result <= X"6745";

    write_enable <= '0';

    read_enable <= '0';

   wait for 2.5 ns;

    reset <= '0';

    --reset_buffer <='0' ;

    adder_result <= X"6745";

    write_enable <= '0';

    read_enable <= '1';

   wait for 10 ns;

    reset <= '0';

   -- reset_buffer <='0' ;

    adder_result <= X"6745";

    write_enable <= '0';

    read_enable <= '0';

   wait for 10 ns;

    reset <= '0';

  --  reset_buffer <='0' ;

    adder_result <= X"6745";

    write_enable <= '0';

    read_enable <= '1';

   wait for 10 ns;

    reset <= '0';

  --  reset_buffer <='0' ;

    adder_result <= X"6745";

    write_enable <= '0';

    read_enable <= '1';

   wait ;



  end process;
end TEST;
