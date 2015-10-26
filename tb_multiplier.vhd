-- $Id: $
-- File name:   tb_multiplier.vhd
-- Created:     11/7/2011
-- Author:      Ashwin Shankar
-- Lab Section: 337-04
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_multiplier is
end tb_multiplier;

architecture TEST of tb_multiplier is

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

  component multiplier
    PORT(
         a : in std_logic_vector(7 downto 0);
         b : in std_logic_vector(7 downto 0);
         result : out std_logic_vector(15 downto 0);
         multiplication_done : out std_logic;
         output_ready : in std_logic;
         multiply : in std_logic
    );
  end component;

-- Insert signals Declarations here
  signal a : std_logic_vector(7 downto 0);
  signal b : std_logic_vector(7 downto 0);
  signal result : std_logic_vector(15 downto 0);
  signal multiplication_done : std_logic;
  signal output_ready : std_logic;
  signal multiply : std_logic;

-- signal <name> : <type>;

begin
  DUT: multiplier port map(
                a => a,
                b => b,
                result => result,
                multiplication_done => multiplication_done,
                output_ready => output_ready,
                multiply => multiply
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

    a <= X"34";

    b <= X"12";

    output_ready <= '1';

    multiply <= '1';
   
    wait for 20 ns;
    output_ready<='0';
    multiply<='0';
    wait;

  end process;
end TEST;
