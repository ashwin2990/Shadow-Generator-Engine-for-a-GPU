-- $Id: $
-- File name:   matrix_controller.vhd
-- Created:     11/12/2011
-- Author:      Shantanu Shrikant Joshi
-- Lab Section: 337-04
-- Version:     1.0  Initial Design Entry
-- Description: overall controller for the matrix math block send and receives various signals that are critical for the timing and the correct functioning of the matrix math block . 
-- . 
-- 

-- BARRING SENSITIVITY LISTS THAT MAY CAUSE SOME PROBLEMS 


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity matrix_controller is 
port ( clk : in std_logic ; 
       reset : in std_logic ; 
       write_to_memory_controller : out std_logic ; 
       
       input_fifo_full : in std_logic ; 

       divide_done : in std_logic ; 
       multiplication_done : in std_logic ;  
       

       multiply_controller : in std_logic ;
       multiply  : out std_logic ;
 
       external_trigger : in std_logic ; 
       read_enable : out std_logic ;  -- this is for the input fifo 
       write_enable : out std_logic ;  -- again this is for the input fifo 

      intermediate_buffer_full : in std_logic ; 
      
      intermediate_buffer_read_enable : out std_logic ; 
      intermediate_buffer_write_enable: out std_logic ; 
      
      output_buffer_empty : in std_logic ; 
      output_buffer_full : in std_logic ; 
      read_enable_output_buffer : out std_logic ; 
      write_enable_output_buffer: out std_logic ; 

      reset_intermediate_buffer : out  std_logic ; 
      add_ass : out std_logic ) ; 

end matrix_controller ; 

architecture controller of matrix_controller is 

type stateType is ( initial, assert_write_enable ,dummy1,  assert_multiply , divideDone , assert_write_int_buff,assert_write_int_buff_dummy,assert_add_ass ,assert_read_enable_on_input_fifo,dummy3,
assert_read_enable_on_output_fifo1,assert_reset_intermediate_buffer,assert_write_to_memory_controller,
assert_read_enable_on_output_fifo2,  ResetIntermediateFIFO,AssertWriteToMemoryController, assert_write_on_output_buffer , pre_assert_write_on_output_buffer ) ; 
signal state, nextstate : stateType ;     

signal q1_add_ass, q2_add_ass : std_logic ; 

begin 

process( reset , clk ) 
begin 
if ( reset = '1' ) then 
state <= initial ; 
q2_add_ass <=q1_add_ass ; 
add_ass<= q2_add_ass ; 
   

elsif (rising_edge(clk) ) then 
state <= nextstate ; 
q2_add_ass <=q1_add_ass ; 
--q3_add_ass <= q2_add_ass ; 
add_ass  <= q2_add_ass;  
end if ; 

end process ; 

nextstatelogic : process ( state , external_trigger ,input_fifo_full , divide_done , multiply_controller , multiplication_done, intermediate_buffer_full, output_buffer_full, output_buffer_empty )

begin 

case state is 

when initial => 

if ( external_trigger = '1' ) then 
nextstate <= assert_write_enable ; 
else 
nextstate <= initial ; 
end if ; 

when assert_write_enable =>

if ( input_fifo_full = '1')  then
nextstate <= assert_multiply ; 
else 
nextstate <= assert_write_enable ; 
end if ; 

--when assert_input_fifo_read_enable =>
--nextstate <= assert_multiply ; 

when assert_multiply => -- do i go into a dummty state after this to ensure that multiply is asserted only for a clock cyle  
nextstate <= dummy1 ; 

when dummy1 =>
--if multiplication_done = '1' then 
nextstate <= divideDone ; 
--else 
--nextstate <=dummy1; 
--end if ; 

when divideDone => 
if ( divide_done = '1' ) then 
nextstate <= assert_write_int_buff  ; 
else 
nextstate <= divideDone ; 
end if ; 

when assert_write_int_buff => 
nextstate <=  assert_write_int_buff_dummy ;


when assert_write_int_buff_dummy =>

if(intermediate_buffer_full = '1' ) then  -- again same question does write_enable have to be a pulse or not ?  
nextstate <= assert_add_ass ; 
elsif ( multiply_controller = '1' ) then 
nextstate <= assert_read_enable_on_input_fifo ; 
else 
nextstate <= assert_write_int_buff_dummy ; 
end if  ; 

when assert_read_enable_on_input_fifo =>
nextstate <= assert_multiply ; 

--when BufferFull =>  -- am in the add_ass part of the state diagram  the multipication loop has been completed --
--nextstate <= assert_reset ;  

when assert_add_ass => 
nextstate <= pre_assert_write_on_output_buffer  ;

when pre_assert_write_on_output_buffer =>
nextstate <= assert_write_on_output_buffer ; 

when assert_write_on_output_buffer => 
nextstate <= dummy3 ; 

when dummy3 =>
if (output_buffer_full = '1' ) then 
nextstate <= assert_read_enable_on_output_fifo1 ; 
elsif  (output_buffer_empty = '0' ) then 
nextstate <= assert_reset_intermediate_buffer ; 
else 
nextstate <= dummy3 ; 
end if  ; 

when assert_reset_intermediate_buffer =>
nextstate <= assert_write_to_memory_controller ; 

when assert_write_to_memory_controller => 
nextstate <= assert_write_enable ; 

when assert_read_enable_on_output_fifo1 => 
nextstate <= assert_read_enable_on_output_fifo2 ; 

when assert_read_enable_on_output_fifo2 =>
nextstate <= ResetIntermediateFIFO ; 

when ResetIntermediateFIFO => 
nextstate <= AssertWriteToMemoryController ; 

when AssertWriteToMemoryController =>
nextstate <= initial ; 




--when ReadBuffer =>  
--nextstate <= add_ass ; 

--when assert_reset =>

--nextstate <= DealingWithOutputBuffer ; 

--when DealingWithOutputBuffer => 
--nextstate <= initial ; 

when others => 
nextstate <= initial ; 

end case ; 

end process nextstatelogic ; 


outputlogic: process ( state  ) 
begin 

write_to_memory_controller <= '0' ;  
write_enable <= '0' ; 
multiply <= '0' ; 
q1_add_ass <='0' ; 
read_enable <= '0' ;  
intermediate_buffer_read_enable <= '0' ; 
intermediate_buffer_write_enable <= '0' ; 

reset_intermediate_buffer <= '0' ;  
read_enable_output_buffer <= '0' ; 
write_enable_output_buffer <= '0' ; 


case state is 

when assert_write_enable => 
 
write_enable <= '1' ; 

when assert_reset_intermediate_buffer => 
--reset_intermediate_buffer <= '1' ;
intermediate_buffer_read_enable <= '1' ; 
when assert_multiply => 

multiply <= '1' ; 
--read_enable<='1';--????

when assert_write_int_buff  => 

intermediate_buffer_write_enable <= '1' ; 

when assert_add_ass => 

q1_add_ass <='1' ; 

when assert_read_enable_on_output_fifo1 => 

read_enable_output_buffer <= '1' ; 
--reset_intermediate_buffer <= '1' ;--added so that intermediate buffer gets reset after x and y  
intermediate_buffer_read_enable <= '1' ;  
when assert_write_on_output_buffer => 
write_enable_output_buffer  <= '1' ; 
q1_add_ass<='1';

when assert_read_enable_on_output_fifo2 => 

read_enable_output_buffer <= '1' ; 
 

when assert_read_enable_on_input_fifo => 

 
read_enable <= '1' ;  


when assert_write_to_memory_controller => 

write_to_memory_controller <= '1' ;  

when ResetIntermediateFIFO =>

--reset_intermediate_buffer <= '1' ;
intermediate_buffer_read_enable <= '1' ; 

when AssertWriteToMemoryController => 
write_to_memory_controller <= '1' ;

when others => 

write_to_memory_controller <= '0' ;  
write_enable <= '0' ; 
multiply <= '0' ; 
q1_add_ass <='0' ; 
read_enable <= '0' ;  
intermediate_buffer_read_enable <= '0' ; 
intermediate_buffer_write_enable <= '0' ; 
reset_intermediate_buffer <= '0' ;  
read_enable_output_buffer <= '0' ; 
write_enable_output_buffer  <= '0' ; 

end case ; 

end process outputlogic ; 

end controller ; 





