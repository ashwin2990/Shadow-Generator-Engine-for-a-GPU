-- $Id: $
-- File name:   matrix_divide_zl
-- Created:     11/4/2011
-- Author:      Shantanu Shrikant Joshi
-- Lab Section: 337-04
-- Version:     1.0  IDLE Design Entry
-- Description: inputs are the 16 bit output from the multiply block 
-- input is the busy signal from the multiply block and Zl from the SRAM which is 8 bits wide and clock and asynchronus reset are also inputs 
-- ouputs are the 16 bit result of division 
-- the busy signal in divide and the write enable which is an input to the buffer before the adder block . 
-- we want the write enable to be pulse and not an enable 


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
use ieee.std_logic_ARITH.all ; 
use ieee.std_logic_UNSIGNED.all ; 


entity matrix_divide is 
port ( result: in std_logic_vector(15 downto 0 )  ;
       clk : in std_logic ; 
       reset: in std_logic ; 
       z_l : in std_logic_vector(7 downto 0 ) ; 
       multiplication_done : in std_logic ; -- not check for busy == '1' 
              
       divide_result : out std_logic_vector(15 downto 0 ) ;
       divide_done : out std_logic ) ;  
end matrix_divide ; 



architecture divide of matrix_divide is 

signal internal_z : std_logic_vector(7 downto 0 ) ;-- copy of divsor
signal dividend : std_logic_vector( 15 downto 0 ) ; -- that which is being divided 
signal dividend_signal: std_logic_vector(15 downto 0);
signal internal_z_signal:std_logic_vector(7 downto 0);
type stateType is (IDLE, divide1 ,divide2, divide3,divide4,divide5,divide6,divide7, outputDoneSignal, lockState, takeCareOfOdd,takeCareOfOdd2 ) ; 
signal state, nextstate : stateType ;  

begin 

SETUP: process( reset , clk , multiplication_done,z_l ,result) 
begin 

-- in this process i am saying that initiliaze if Asyn reset happens or if the  multiplication block is ready for its output
-- to be read . We set up a state machine such that it bit shift zl to the right till it reaches 0 that is when you know that
-- you have divided by 2 as much as you can
-- similary as you are bitshifting zl you also bit shift the input signal to the right  
if (reset = '1') then 
 
state <= IDLE ; 
internal_z <=X"00" ; 
dividend<=X"0000" ;

elsif ( multiplication_done = '1' )  then
state <= IDLE ; 
internal_z <= z_l ; 
dividend <= result ; 



elsif (rising_edge(clk) ) then 
state <= nextstate ;   
internal_z<=internal_z_signal;
dividend<=dividend_signal;
end if ; 

end process SETUP  ;

nextstatelogic : process( state, internal_z_signal) 
begin 

-- in this process block i am specifying the nextstate it goes to for what inputs 
-- statemachine implemented using a mooore model 
-- when zl = 0 we go into a dummy state for one clock cycle to ensure that the divide_done signal is a pulse 
-- and then we go into a lock state till multiplication_done = 1 again 

case state is 

when IDLE => 
nextstate <= divide1 ; 

when divide1  => 

if( internal_z_signal = "00000001" or internal_z_signal ="11111111"   )  then  
nextstate <= outputDoneSignal ;
elsif ( internal_z_signal = "00000011") then 
nextstate <= takeCareOfOdd ;  
elsif ( internal_z_signal = "11111101"  ) then 
nextstate <= takeCareOfOdd2 ;
else 
nextstate <= divide2 ; 
end if ; 

when divide2  => 

if(internal_z_signal = "00000001" or internal_z_signal ="11111111"    )  then  
nextstate <= outputDoneSignal ;
elsif ( internal_z_signal = "00000011") then 
nextstate <= takeCareOfOdd ;  
elsif ( internal_z_signal = "11111101"  ) then 
nextstate <= takeCareOfOdd2 ;
else 
nextstate <= divide3 ; 
end if ; 

when divide3  => 
if( internal_z_signal = "00000001"  or internal_z_signal ="11111111"    )  then  
nextstate <= outputDoneSignal ;
elsif ( internal_z_signal = "00000011") then 
nextstate <= takeCareOfOdd ;  
elsif ( internal_z_signal = "11111101"  ) then 
nextstate <= takeCareOfOdd2 ;
else 
nextstate <= divide4 ; 
end if ; 


when divide4  => 
if( internal_z_signal = "00000001"  or internal_z_signal ="11111111"    )  then  
nextstate <= outputDoneSignal ;
elsif ( internal_z_signal = "00000011") then 
nextstate <= takeCareOfOdd ;  
elsif ( internal_z_signal = "11111101"  ) then 
nextstate <= takeCareOfOdd2 ;
else 
nextstate <= divide5 ; 
end if ; 

when divide5  => 
if( internal_z_signal = "00000001" or internal_z_signal ="11111111"      )  then  
nextstate <= outputDoneSignal ;
elsif ( internal_z_signal = "00000011") then 
nextstate <= takeCareOfOdd ;  
elsif ( internal_z_signal = "11111101"  ) then 
nextstate <= takeCareOfOdd2 ;
else 
nextstate <= divide6 ; 
end if ; 


when divide6  => 
if( internal_z_signal = "00000001" or internal_z_signal ="11111111"   )  then  
nextstate <= outputDoneSignal ;
elsif ( internal_z_signal = "00000011" ) then 
nextstate <= takeCareOfOdd ; 
elsif ( internal_z_signal = "11111101"  ) then 
nextstate <= takeCareOfOdd2 ;
else 
nextstate <= divide7; 
end if ; 




when divide7  =>  
nextstate <= outputDoneSignal ;

when outputDoneSignal => 

nextstate <= lockState ; 

when lockState =>
nextstate <= state ; 

when takeCareOfOdd  => 
nextstate <= divide6 ;

when takeCareOfOdd2  => 
nextstate <= divide6 ; 

when others => 
nextstate <= IDLE ; 

end case ; 
end process nextstatelogic ;  

outputlogic: process ( state , z_l , result,internal_z,dividend) 
begin 


case state is 

when IDLE => 
internal_z_signal <= z_l ; 
dividend_signal <= result ;
divide_done <= '0' ; 

when divide1 => 
internal_z_signal <= internal_z(7) &  internal_z(7 downto 1 ) ; -- bit shift to the right 
dividend_signal <= dividend(15) & dividend(15 downto 1 ) ; 
divide_done <= '0' ;

when divide2 => 
internal_z_signal <= internal_z(7) &  internal_z(7 downto 1 ) ; -- bit shift to the right 
dividend_signal <= dividend(15) & dividend(15 downto 1 ) ; 
divide_done <= '0' ;

when divide3 => 
internal_z_signal <= internal_z(7) &  internal_z(7 downto 1 ) ; -- bit shift to the right 
dividend_signal <= dividend(15) & dividend(15 downto 1 ) ; 
divide_done <= '0' ;

when divide4 => 
internal_z_signal <= internal_z(7) &  internal_z(7 downto 1 ) ; -- bit shift to the right 
dividend_signal <= dividend(15) & dividend(15 downto 1 ) ; 
divide_done <= '0' ;

when divide5 => 
internal_z_signal<= internal_z(7) &  internal_z(7 downto 1 ) ; -- bit shift to the right 
dividend_signal <= dividend(15) & dividend(15 downto 1 ) ; 
divide_done <= '0' ;

when divide6 => 
internal_z_signal <= internal_z(7) &  internal_z(7 downto 1 ) ; -- bit shift to the right 
dividend_signal <= dividend(15) & dividend(15 downto 1 ) ; 
divide_done <= '0' ;

when divide7 => 
internal_z_signal <= internal_z(7) &  internal_z(7 downto 1 ) ; -- bit shift to the right 
dividend_signal <= dividend(15) & dividend(15 downto 1 ) ; 
divide_done <= '0' ;

when takeCareOfOdd => 
internal_z_signal<= "00000010" ; 
dividend_signal <= dividend(15) & dividend(15 downto 1 ) ; 
divide_done <= '0' ;

when takeCareOfOdd2 => 
internal_z_signal <= "11111110" ; 
dividend_signal <= dividend(15) & dividend(15 downto 1 ) ; 
divide_done <= '0' ;


when outputDoneSignal =>
internal_z_signal <= internal_z;
dividend_signal<=dividend;
divide_done <= '1' ; 

when others => 
internal_z_signal<=internal_z;
dividend_signal<=dividend;
divide_done <= '0' ; 

end case ; 

end process outputlogic ; 


divide_result <= not ( dividend(15 downto 0 ) ) + 1    ; 

end divide  ; 

-- add two's complement to this whole thing 


















 
