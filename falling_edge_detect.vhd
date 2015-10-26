-- $Id: $
-- File name:   falling_edge_detect
-- Created:     11/4/2011
-- Author:      Shantanu Shrikant Joshi
-- Lab Section: 337-04
-- Version:     1.0  Initial Design Entry
-- Description: this block sees the falling edge detect of the intermediate buffer before the adder and outputs a multiply_controller signal to the matrix math controller .


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity falling_edge_detect is 
port ( fifo_empty: in std_logic ;
       clk : in std_logic ; 
       reset: in std_logic ;  
       multiply_controller : out std_logic) ; 
end falling_edge_detect ; 

architecture simple of falling_edge_detect is 

 signal q1	: std_logic;
	signal q2:	std_logic;
	signal q3	:	std_logic;

begin 
multiply_controller <=  ( (not (q2)) and q3  )  ; -- should detect a rising edge 

process( reset , clk ) 
begin 
if ( reset = '1' ) then 
q1 <= '0' ; 
q2 <= '0' ;
q3 <= '0' ; 
-- i am implementing the rising edge detect so is  
elsif (rising_edge(clk) ) then 
q3 <= q2 ; 
q2 <= q1 ;  
q1 <= fifo_empty ;  
end if ; 

end process ; 


end simple ; 



 
