-- $Id: $
-- File name:   tb_matrix_divide.vhd
-- Created:     11/5/2011
-- Author:      Shantanu Shrikant Joshi
-- Lab Section: 337-04
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_matrix_divide is
end tb_matrix_divide;

architecture TEST of tb_matrix_divide is

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

  component matrix_divide
    PORT(
         result : in std_logic_vector(15 downto 0 );
         clk : in std_logic;
         reset : in std_logic;
         z_l : in std_logic_vector(7 downto 0 );
         multiplication_done : in std_logic;
         divide_result : out std_logic_vector(15 downto 0 );
         divide_done : out std_logic
    );
  end component;

-- Insert signals Declarations here
  signal result : std_logic_vector(15 downto 0 );
  signal clk : std_logic;
  signal reset : std_logic;
  signal z_l : std_logic_vector(7 downto 0 );
  signal multiplication_done : std_logic;
  signal divide_result : std_logic_vector(15 downto 0 );
  signal divide_done : std_logic;

-- signal <name> : <type>;

begin
  DUT: matrix_divide port map(
                result => result,
                clk => clk,
                reset => reset,
                z_l => z_l,
                multiplication_done => multiplication_done,
                divide_result => divide_result,
                divide_done => divide_done
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);


process 

begin 

multiplication_done <= '0' ; 
wait for  5 ns ;
multiplication_done <= '1' ; 
wait for 10 ns ;  
multiplication_done <= '0' ;
--wait for 5 ns ; 
--reset <= '0' ;  
wait ; 
end process ; 




process

  begin

-- Insert TEST BENCH Code Here

    --fifo_empty <= 

    clk <= '0' ; 
    wait for 5 ns ; 
    clk <= '1' ; 
    wait for 5 ns ; 

   -- reset <= 

  end process;


process 
begin 
z_l <= "11111111" ; 
result <= X"FFFF" ;
wait ;  
end process ; 

process 
begin 
reset <= '0' ; 
wait for 35 ns ; 
reset <= '1' ; 
wait for 10 ns; 
reset <= '0' ; 
wait ; 
end process ; 
end TEST;
