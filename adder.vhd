-- $Id: $
-- File name:   adder.vhd
-- Created:     11/2/2011
-- Author:      Shantanu Shrikant Joshi
-- Lab Section: 337-04
-- Version:     1.0  Initial Design Entry
-- Description: this is going to take 2 16 bit inputs and output a 16 bit result. It only adds when the control signal is high .


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
use ieee.std_logic_ARITH.all ; 
use ieee.std_logic_UNSIGNED.all ; 
--use ieee.numeric_std.all;



ENTITY adder IS
	PORT
	(
		a: 	in	  std_logic_vector(15 downto 0 ) ;
		b: 		 in std_logic_vector(15 downto 0 );
		add_ass: 		IN STD_LOGIC;
		result: 		OUT std_logic_vector(15 downto 0 ) -- i am going to have to increase the bit on this to take into the carry 
	);
END adder;

ARCHITECTURE rtl OF adder IS


BEGIN
	
PROCESS (a, b, add_ass)

	BEGIN
		IF (add_ass = '1') THEN
			result<=a+b;
		ELSE
			result <= X"0000" ;
		END IF;
	END PROCESS;
END rtl;


