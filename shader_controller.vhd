-- $Id: $
-- File name:   shader_controller.vhd
-- Created:     11/12/2011
-- Author:      Aashish Simha
-- Lab Section: 337-04
-- Version:     1.0  Initial Design Entry
-- Description: overall controller for the matrix math block send and receives various signals that are critical for the timing and the correct functioning of the matrix math block . 
-- . 
-- 

-- BARRING SENSITIVITY LISTS THAT MAY CAUSE SOME PROBLEMS 


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity shader_controller is 
port ( clk : in std_logic ; 
       reset : in std_logic ; 
       write_to_memory_controller_shader : out std_logic ; 
       
       input_fifo_shader_full : in std_logic ; 
			input_fifo_shader_empty:in std_logic;
    

       read_enable_input_shader : out std_logic ;  -- this is for the input fifo 
       write_enable_input_shader : out std_logic ;  -- again this is for the input fifo 
       enable_line_raster_out:out std_logic ;
       line_raster_busy: in std_logic;
       finsihed_boundary_out: out std_logic;
     
      output_buffer_math_empty : in std_logic ; 
      output_buffer_math_full : in std_logic );  

end shader_controller ; 


architecture controller of shader_controller is 

type stateType is (initial, assert_write_enable ,waitforempty, enable_line_raster, wait_for_line_raster, increment_readptr_input_fifo, finished_boundary,dummy_raster,dummy_raster1) ; 
signal state, nextstate : stateType ;     


begin 

process( reset , clk ) 
begin 
if ( reset = '1' ) then 
state <= initial ; 

elsif (rising_edge(clk) ) then 
state <= nextstate ;   
end if ; 

end process ; 

nextstatelogic : process ( state , output_buffer_math_full ,input_fifo_shader_full , output_buffer_math_empty , line_raster_busy, input_fifo_shader_empty)

begin 

case state is 

when initial => --initial state wait for buffer full from the matrix_math

if ( output_buffer_math_full = '1' ) then 
nextstate <= assert_write_enable ; 
else 
nextstate <= initial ; 
end if ; 

when assert_write_enable =>--assert write enable on raster input buffer
nextstate<=waitforempty;

when waitforempty =>--wait till matrix math buffer gets empty
if(input_fifo_shader_full='1') then
nextstate<=enable_line_raster;
elsif ( output_buffer_math_empty = '1' ) then 
nextstate <= initial ; 
else 
nextstate <= waitforempty ; 
end if ; 

when enable_line_raster =>--set enable the line raster 
nextstate<=dummy_raster;

when dummy_raster =>
nextstate<=wait_for_line_raster;

when wait_for_line_raster=>--wait for line raster to become idle
if(line_raster_busy='0') then
if(input_fifo_shader_empty='1') then
nextstate<=finished_boundary;
else
nextstate<=increment_readptr_input_fifo;
end if;
else
if(input_fifo_shader_empty='1') then
nextstate<=finished_boundary;
else
nextstate<=wait_for_line_raster;
end if;
end if;

when increment_readptr_input_fifo=>
nextstate<=dummy_raster1;

when dummy_raster1 =>
nextstate<=dummy_raster;


when finished_boundary=>
nextstate<=initial;


when others => 
nextstate <= initial ; 

end case ; 

end process nextstatelogic ;





outputlogic: process ( state  ) 
begin 


read_enable_input_shader <= '0';
write_enable_input_shader<='0';
enable_line_raster_out<='0';
write_to_memory_controller_shader<='0';
finsihed_boundary_out<='0';

case state is 

when assert_write_enable =>
write_enable_input_shader<='1';

when enable_line_raster =>
enable_line_raster_out<='1';

when dummy_raster =>
enable_line_raster_out<='1';

when dummy_raster1 =>
enable_line_raster_out<='1';

when wait_for_line_raster =>
enable_line_raster_out<='1';

when increment_readptr_input_fifo =>
read_enable_input_shader <= '1'; 

when finished_boundary =>
finsihed_boundary_out<='1';


when others => 

  
read_enable_input_shader <= '0';
write_enable_input_shader<='0';
enable_line_raster_out<='0';
write_to_memory_controller_shader<='0';
finsihed_boundary_out<='0';

end case ; 

end process outputlogic ; 

end controller ; 





