-- $Id: $
-- File name:   tb_input_fifo.vhd
-- Created:     11/24/2011
-- Author:      Ashwin Shankar
-- Lab Section: 337-04
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_input_fifo is
end tb_input_fifo;

architecture TEST of tb_input_fifo is

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

  component input_fifo
    PORT(
         reset : in std_logic;
         clk : in std_logic;
         data_in : in std_logic_vector(7 downto 0 );
         data_out_a : out std_logic_vector(7 downto 0 );
         data_out_b : out std_logic_vector(7 downto 0);
         write_enable : in std_logic;
         read_enable : in std_logic;
         input_fifo_empty : out std_logic;
         input_fifo_full : out std_logic
    );
  end component;

-- Insert signals Declarations here
  signal reset : std_logic;
  signal clk : std_logic;
  signal data_in : std_logic_vector(7 downto 0 );
  signal data_out_a : std_logic_vector(7 downto 0 );
  signal data_out_b : std_logic_vector(7 downto 0);
  signal write_enable : std_logic;
  signal read_enable : std_logic;
  signal input_fifo_empty : std_logic;
  signal input_fifo_full : std_logic;

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



  DUT: input_fifo port map(
                reset => reset,
                clk => clk,
                data_in => data_in,
                data_out_a => data_out_a,
                data_out_b => data_out_b,
                write_enable => write_enable,
                read_enable => read_enable,
                input_fifo_empty => input_fifo_empty,
                input_fifo_full => input_fifo_full
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

    reset <= '0';

    data_in <= X"00";

    write_enable <= '0';

    read_enable <= '0';

    wait for 2.5 ns;

   reset <= '1';

    data_in <= X"00";

    write_enable <= '0';

    read_enable <= '0';

   wait for 2.5 ns;

   reset <= '1';

    data_in <= X"00";

    write_enable <= '0';

    read_enable <= '0';

   wait for 2.5 ns;

   reset <= '0';

    data_in <=X"12" ;

    write_enable <= '1';

    read_enable <= '0';

    wait for 10 ns;

   reset <= '0';

    data_in <= X"34";

    write_enable <= '1';

    read_enable <= '0';

    wait for 10 ns;


   reset <= '0';

    data_in <= X"AB";

    write_enable <= '0';

    read_enable <= '0';

    wait for 10 ns;


   reset <= '0';

    data_in <= X"23";

    write_enable <= '1';

    read_enable <= '0';

    wait for 10 ns;

   reset <= '0';

    data_in <= X"45";

    write_enable <= '1';

    read_enable <= '0';

    wait for 10 ns;


   reset <= '0';

    data_in <= X"CF";

    write_enable <= '0';

    read_enable <= '1';

    wait for 10 ns;

   reset <= '0';

    data_in <= X"CF";

    write_enable <= '0';

    read_enable <= '1';

    wait for 10 ns;

   reset <= '0';

    data_in <= X"45";

    write_enable <= '0';

    read_enable <= '0';

    wait ;

  end process;
end TEST;
