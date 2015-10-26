-- $Id: $
-- File name:   raster_controller.vhd
-- Created:     11/12/2011
-- Author:      Aashish Simha
-- Lab Section: 337-04
-- Version:     1.0  Initial Design Entry



LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity raster_controller is 
port( clk : in std_logic ; 
      reset : in std_logic ;
      input_fifo_shader_full : in std_logic ; 
      input_fifo_shader_empty:in std_logic;
      line_raster_busy: in std_logic;
      output_buffer_math_empty : in std_logic ; 
      output_buffer_math_full : in std_logic ; 
      shader_done       : in std_logic; 

      read_enable_input_shader : out std_logic ;  -- this is for the input fifo 
      write_enable_input_shader : out std_logic ;  -- again this is for the input fifo 
      enable_line_raster_out:out std_logic ;
      finsihed_boundary_out: out std_logic;   
      shadow_object     : out std_logic;
      shader_enable     : out std_logic;
      shader_send_data  : out std_logic;
      shader_input      : out std_logic; -- sending data from shader to ram
      shading_or_boundary:out std_logic;    
      buffer_control_signal : out std_logic -- controls where the buffer gets data from ( 1 is ram, 0 is matrix math) also doubles as buffer send data
);
end raster_controller ; 


architecture controller of raster_controller is 

type stateType is (initial, assert_write_enable ,waitforempty, enable_line_raster, wait_for_line_raster, increment_readptr_input_fifo, dummy_raster, dummy_raster1, start_shader, shadow, object, check, done, assert_write_enable_object, waitforDoneSent_object, DUMMY1, DUMMY2,DUMMY3,DUMMY4,DUMMY5,finished_boundary,check2) ; 
signal state, nextstate : stateType ;     
signal count, nextcount: std_logic; 

begin 

process( reset , clk ) 
begin 
if ( reset = '1' ) then 
state <= initial ; 
count <= '0';
elsif (rising_edge(clk) ) then 
state <= nextstate ; 
count <= nextcount;  
end if ; 

end process ; 

nextstatelogic : process ( state , output_buffer_math_full ,input_fifo_shader_full , output_buffer_math_empty , line_raster_busy, input_fifo_shader_empty, shader_done,  count)

begin 

case state is 

when initial => --initial state wait for buffer full from the matrix_math

if ( output_buffer_math_full = '1' ) then 
nextstate <= assert_write_enable ; 
nextcount<=count;
else 
nextstate <= initial ; 
nextcount<=count;
end if ; 

when assert_write_enable =>--assert write enable on raster input buffer
nextstate<=waitforempty;
nextcount<=count;

when waitforempty =>--wait till matrix math buffer gets empty
if(input_fifo_shader_full='1') then
nextstate<=start_shader;
nextcount<=count;
elsif ( output_buffer_math_empty = '1' ) then 
nextstate <= initial ; 
nextcount<=count;
else 
nextstate <= waitforempty ; 
nextcount<=count;
end if ; 

when enable_line_raster =>--set enable the line raster 
nextstate<=dummy_raster;
nextcount<=count;

when dummy_raster =>
  nextcount<=count;
  if(input_fifo_shader_empty='1') then
    nextstate<=finished_boundary;
 else
    nextstate<=wait_for_line_raster;
  end if;

when wait_for_line_raster=>--wait for line raster to become idle
if(line_raster_busy='0') then
  if(input_fifo_shader_empty='1') then
    nextstate<=finished_boundary;
    nextcount<=count;
  else
    nextstate<=increment_readptr_input_fifo;
    nextcount<=count;
   end if;
else
  nextstate<=wait_for_line_raster;
  nextcount<=count;
end if;

when increment_readptr_input_fifo=>
nextstate<=dummy_raster1;
nextcount<=count;

when dummy_raster1 =>
nextstate<=dummy_raster;
nextcount<=count;

when start_shader=>
if(count='0') then
  nextstate<=shadow;
  nextcount<=count;
else
  nextstate<=object;
  nextcount<=count;
end if;

when shadow=>
  nextcount<='1';
  nextstate<=check;

when object=>
  nextcount<='0';
  nextstate<=check2;
  
when check=>
  if(shader_done='1') then
     nextstate<=done;
     nextcount<=count;
  else
     nextstate<=check;
     nextcount<=count;
   end if;

when check2=>
  if(shader_done='1') then
     nextstate<=enable_line_raster;
     nextcount<=count;
  else
     nextstate<=check2;
     nextcount<=count;
   end if;
   
  
when done=>
  nextstate<=assert_write_enable_object;
  nextcount<=count;

when assert_write_enable_object => --assert write enable on raster input buffer
  nextstate<=DUMMY1;      
  nextcount<=count;

when DUMMY1=>
  nextstate<=DUMMY2;
  nextcount<=count;
  
when DUMMY2=>
  nextstate<=waitforDoneSent_object;
  nextcount<=count;

when DUMMY3=>
  nextstate<=DUMMY4;
  nextcount<=count;

when DUMMY4=>
  nextstate<=DUMMY5;
  nextcount<=count;
  
when DUMMY5=>
  nextstate<=object;
  nextcount<=count;



when waitforDoneSent_object =>
if(input_fifo_shader_full='1') then
if(count='1') then 
nextstate<=DUMMY3;
nextcount<=count;
else
nextstate<= enable_line_raster;
nextcount<=count;
end if;
nextcount<=count;
else 
nextstate <=DUMMY1 ; 
nextcount<=count;
end if ; 

when finished_boundary=>
nextstate<=finished_boundary;
nextcount<=count;

when others => 
nextstate <= initial ; 
nextcount<=count;

end case ; 

end process nextstatelogic ;


--Output logic

with state select
read_enable_input_shader <= '1' when increment_readptr_input_fifo,
			    '1' when waitforempty,
			    '1' when waitforDoneSent_object,
                            '0' when others;
                            
with state select
write_enable_input_shader <= '1' when assert_write_enable,
                             '1' when DUMMY2,
                             '0' when others;
                             
with state select
enable_line_raster_out <= '1' when enable_line_raster,
                          '1' when dummy_raster,
                          '1' when dummy_raster1,
                          '1' when wait_for_line_raster,
                          '0' when others;
                          
               
with state select
shadow_object <= '1' when shadow,
		 '1' when assert_write_enable,
		 '1' when waitforempty,
                 '0' when others;
                 
with state select
shader_enable <= '1' when shadow,
                 '1' when object,
                 '1' when check,
                 '1' when check2,
                 '0' when others;
                 
with state select
buffer_control_signal <= '1' when assert_write_enable_object,
                         '1' when DUMMY1,
                         '1' when DUMMY2,
                         '1' when waitforDoneSent_object,
                   --      '1' when DUMMY3,
                   --      '1' when DUMMY4,
                   --      '1' when DUMMY5,
                         '0' when others;
                         
with state select
shader_input <= '1' when shadow,
                '1' when object,
                '0' when others;
                
with state select
shader_send_data <= '1' when shadow,
                    '1' when object,
                    '1' when check,
                    '1' when check2,
                    '0' when others;
with state select
finsihed_boundary_out<='1' when finished_boundary,
			'0' when others;

with state select
shading_or_boundary <= '1' when enable_line_raster,
                       '1' when dummy_raster,
                       '1' when dummy_raster1,
 		       '1' when wait_for_line_raster,
  		       '1' when increment_readptr_input_fifo,
		       '0' when others;

                         
end controller ; 





