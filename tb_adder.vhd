-- $Id: $
-- File name:   tb_adder.vhd
-- Created:     11/2/2011
-- Author:      Shantanu Shrikant Joshi
-- Lab Section: 337-04
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_adder is
end tb_adder;

architecture TEST of tb_adder is

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

  component adder
    PORT(
         a : in std_logic_vector(15 downto 0 );
         b : in std_logic_vector(15 downto 0 );
         add_ass : IN STD_LOGIC;
         result : OUT std_logic_vector(15 downto 0 )
    );
  end component;

-- Insert signals Declarations here
  signal a : std_logic_vector(15 downto 0 );
  signal b : std_logic_vector(15 downto 0 );
  signal add_ass : STD_LOGIC;
  signal result : std_logic_vector(15 downto 0 );

-- signal <name> : <type>;

begin
  DUT: adder port map(
                a => a,
                b => b,
                add_ass => add_ass,
                result => result
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

    --buffer_full <= '0' ; 
   -- wait for 20 ns ; 
    add_ass <= '1' ; 
    wait  ; 
  end process;

process -- plugging random values for a  

begin 

a <= X"FFFF" ; 
--wait for 100 ns ; 

a<= X"0000" ; 
--wait for 100 ns ; 

a <= X"1010" ; 
--wait for 100 ns ; 

a <= X"0101" ; 
--wait for 100 ns ; 

a <= X"2345" ; 
--wait for 100 ns ;
wait ;
end process ; 






process 

begin 


b <= X"BBBB" ; 
--wait for 100 ns ; 

b<= X"ABCD" ; 
--wait for 100 ns ; 

b <= X"5678" ; 
--wait for 100 ns ; 

b <= X"0101" ; 
--wait for 100 ns ; 

b <= X"9A0C" ; 
--wait for 100 ns ;
wait ;
end process ; 


end TEST;






