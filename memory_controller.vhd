-- $Id: $
-- File name:   memory_controller.vhd
-- Created:     11/12/2011
-- Author:      Aashish Simha
-- Lab Section: 337-04
-- Version:     1.0  Initial Design Entry



LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity memory_controller is
port ( clk : in std_logic ;
       reset : in std_logic ;
       write_memory_controller : in std_logic; -- signal from the matrix math controller to get object data from sram for matrix math
       start_overall_controller : in std_logic ; -- signal from the overall controller of the GPU
       boundry_input : in std_logic ;--line raster input
       shadow_object : in std_logic;--0->object raster controller
       boundry_data_x : in std_logic_vector(7 downto 0);--x from line raster
       boundry_data_y : in std_logic_vector(7 downto 0);--y raster
       shader_input : in std_logic;--sending data from shader(raster controller)
       shader_object_shadow : in std_logic;--decides to shade object or shadow
       shader_datain_x : in std_logic_vector(7 downto 0);--pixel data from shader
       shader_datain_y : in std_logic_vector(7 downto 0);
       buffer_send_data : in std_logic;--ask for object co ordinates to sram buffer
       finished_boundry:in std_logic;
       shader_done : in std_logic;--shader control signal/tell whether shader has finished
       data_in : in std_logic_vector(15 downto 0);


       data_out : out std_logic_vector(15 downto 0);
       address : out std_logic_vector(15 downto 0);
       read_enable_sram : out std_logic;
       write_enable_sram : out std_logic;
       write_enable_input_fifo : out std_logic
);
end memory_controller ;
architecture behavioral of memory_controller is

type stateType is (IDLE, SEND_MATRIX_MATH_DATA, DUMMY1, DUMMY2,  STORE_OBJECT_BOUNDRY,DUMMYC, DUMMYD,SHADOW_SHADER_WAIT, OBJECT_SHADER_WAIT,DUMMYE,DUMMYF,SHADER_SHADOW_DONE,OBJECT_SHADOW_DONE,GET_BUFFER_DATA,DUMMYA,DUMMYA2,SEND_BUFFER_DATA,PRE_SEND_MATRIX_MATH_DATA) ;
signal state, nextstate : stateType ;
signal count, nextcount : std_logic_vector(9 downto 0);
signal nextcount_shadow,count_shadow: std_logic_vector(15 downto 0);
signal matrix_math_count, next_matrix_math_count: std_logic_vector(5 downto 0);
signal coordinate_count, next_coordinate_count: std_logic_vector(2 downto 0);
--signal check: std_logic_vector(7 downto 0);
--signal address_out: std_logic_vector(15 downto 0);
--signal data_out_signal:std_logic_vector(15 downto 0);

begin

process( reset , clk ) 
begin
if ( reset = '1' ) then
count <= "0000000000";
count_shadow <= "0000000000000000";
matrix_math_count <= "000000";
coordinate_count<="000";
state <= IDLE ;
elsif (rising_edge(clk) ) then
state <= nextstate ;
count <= nextcount;
count_shadow<=nextcount_shadow;
coordinate_count<=next_coordinate_count;
matrix_math_count  <= next_matrix_math_count;
end if ;

end process ;

nextstatelogic : process (state, boundry_input, shadow_object, shader_input,  buffer_send_data, shader_done, count_shadow, count,  finished_boundry, write_memory_controller, start_overall_controller, matrix_math_count, coordinate_count)
begin
case state is

when IDLE =>
  nextcount <="0000000000";
  nextcount_shadow <= "0000000000000000";
  next_coordinate_count <= coordinate_count;
  
  if(boundry_input = '1') then
    nextstate <= STORE_OBJECT_BOUNDRY;
    next_matrix_math_count <= "000000";

  elsif(shader_input = '1' and shadow_object='1') then
    nextstate <= SHADOW_SHADER_WAIT;
    next_matrix_math_count <= "000000";

  elsif(shader_input = '1' and shadow_object='0') then
    nextstate <= OBJECT_SHADER_WAIT;
    next_matrix_math_count <= "000000";

 
  elsif((start_overall_controller = '1' or write_memory_controller = '1') and matrix_math_count<"100000")  then 
    nextstate <= PRE_SEND_MATRIX_MATH_DATA; 
    next_matrix_math_count <= matrix_math_count;
  
  else
    nextstate <= IDLE;
    next_matrix_math_count <= matrix_math_count;
  end if;

when PRE_SEND_MATRIX_MATH_DATA =>
  nextcount <= count;
  nextcount_shadow <= count_shadow;
  next_coordinate_count <= coordinate_count;
  next_matrix_math_count <= matrix_math_count;
  nextstate<=SEND_MATRIX_MATH_DATA;
  
when SEND_MATRIX_MATH_DATA =>
  nextcount <= count;
  nextcount_shadow <= count_shadow;
  if (coordinate_count="100") then 
    nextstate <= IDLE ;
    next_coordinate_count <= "000"; 
    next_matrix_math_count <= matrix_math_count;
  else 
    next_coordinate_count <= coordinate_count + '1' ; 
    next_matrix_math_count <= matrix_math_count + '1' ; 
    nextstate <= DUMMY1; -- first wait state  
    
  end if ; 
  
when DUMMY1 => 
  nextcount <= count;
  nextcount_shadow <= count_shadow;
  next_coordinate_count <= coordinate_count;
  next_matrix_math_count <= matrix_math_count;
  nextstate <= DUMMY2; 

when DUMMY2 => 
  nextcount <= count;
  nextcount_shadow <= count_shadow;
  next_coordinate_count <= coordinate_count;
  next_matrix_math_count <= matrix_math_count;
  nextstate <= SEND_MATRIX_MATH_DATA; 
  

when STORE_OBJECT_BOUNDRY =>--needs to store the x value in x1
  nextcount_shadow <= count_shadow;
  next_coordinate_count <= coordinate_count;
  next_matrix_math_count <= matrix_math_count;
  if(boundry_input = '1') then
    nextstate <= STORE_OBJECT_BOUNDRY;
    nextcount <= count+'1';
  elsif(finished_boundry='1') then 
    nextstate <= IDLE;
    nextcount <=count;
  else
    nextstate <= STORE_OBJECT_BOUNDRY;
    nextcount <= count;
  end if;

when DUMMYC =>
  next_matrix_math_count <= matrix_math_count;
  next_coordinate_count <= coordinate_count;
  if(shader_done = '1') then
    nextcount <= count;
    nextcount_shadow <= count_shadow;
    nextstate <= SHADER_SHADOW_DONE;
  else
    nextcount <= count;
    nextcount_shadow <=count_shadow;
    nextstate<= DUMMYD;
  end if;

when DUMMYD =>
nextcount <= count;
nextcount_shadow <= count_shadow + '1';
next_coordinate_count <= coordinate_count;
next_matrix_math_count <= matrix_math_count;
nextstate <= SHADOW_SHADER_WAIT;

when SHADOW_SHADER_WAIT =>--waiting till 1 line is done
  next_matrix_math_count <= matrix_math_count;
  next_coordinate_count <= coordinate_count;
  if(shader_done = '1') then
    nextcount <= count;
    nextcount_shadow <= count_shadow;
    nextstate <= SHADER_SHADOW_DONE;
  else
    nextcount <= count;
    nextcount_shadow <=count_shadow;
    nextstate<= DUMMYC;
  end if;



when OBJECT_SHADER_WAIT =>--waiting till 1 line is done
  next_matrix_math_count <= matrix_math_count;
  next_coordinate_count <= coordinate_count;
  if(shader_done = '1') then
    nextcount <= count;
    nextcount_shadow <= count_shadow;
    nextstate <= OBJECT_SHADOW_DONE;
  else
    nextcount <= count;
    nextcount_shadow <=count_shadow;
    nextstate<= DUMMYE;
  end if;

when DUMMYE =>
next_coordinate_count <= coordinate_count;
next_matrix_math_count <= matrix_math_count;
if(shader_done = '1') then
    nextcount <= count;
    nextcount_shadow <= count_shadow;
    nextstate <= OBJECT_SHADOW_DONE;
  else
    nextcount <= count;
    nextcount_shadow <=count_shadow;
    nextstate<= DUMMYF;
end if;

when DUMMYF =>
nextcount <= count;
nextcount_shadow <= count_shadow + '1';
next_coordinate_count <= coordinate_count;
next_matrix_math_count <= matrix_math_count;
nextstate <= OBJECT_SHADER_WAIT;



when SHADER_SHADOW_DONE =>
  nextcount <= "0000000000";
  nextcount_shadow <= "0000000000000000";
  next_matrix_math_count <= matrix_math_count;
  next_coordinate_count <= coordinate_count;
  nextstate <= GET_BUFFER_DATA;

when OBJECT_SHADOW_DONE=>
  nextcount <= "0000000000";
  nextcount_shadow <= "0000000000000000";
  next_matrix_math_count <= matrix_math_count;
  next_coordinate_count <= coordinate_count;
  nextstate <= IDLE;

when GET_BUFFER_DATA =>
   nextcount <= count;
   nextcount_shadow <= count_shadow;
   next_matrix_math_count <= matrix_math_count;
   next_coordinate_count <= coordinate_count;
  if(buffer_send_data = '1') then
    nextstate <= DUMMYA;
  else
    nextstate <= GET_BUFFER_DATA;
  end if;

when DUMMYA=>--1 clock cycle of delay for data to become available
   nextcount <= count;
   nextcount_shadow <= count_shadow;
   next_matrix_math_count <= matrix_math_count;
   next_coordinate_count <= coordinate_count;
  nextstate<=DUMMYA2;

when DUMMYA2 =>
   nextcount <= count;
   nextcount_shadow <= count_shadow;
   next_coordinate_count <= coordinate_count;
   next_matrix_math_count <= matrix_math_count;
   nextstate<=SEND_BUFFER_DATA;

when SEND_BUFFER_DATA =>
  nextcount_shadow <= count_shadow;
  next_matrix_math_count <= matrix_math_count;
  next_coordinate_count <= coordinate_count;
  if(buffer_send_data = '1') then--when object co ordinates need to be sent to the buffer
    nextcount <= count+'1';
    nextstate <= DUMMYA;
  else
    nextcount <= count;
    nextstate <= IDLE;
  end if;

when others =>
  nextcount_shadow <= count_shadow;
  nextcount <= count;
  next_coordinate_count <= coordinate_count;
  next_matrix_math_count <= matrix_math_count;
  nextstate<= IDLE;

end case;

end process;
--Output Logic

with state select
read_enable_sram <= '1' when SEND_MATRIX_MATH_DATA,
		'1' when PRE_SEND_MATRIX_MATH_DATA,
               '1' when DUMMY1,
               '1' when DUMMY2,
		'1' when GET_BUFFER_DATA,
               '1' when SEND_BUFFER_DATA,
               '1' when IDLE,
               '1' when DUMMYA,
               '1' when DUMMYA2,
               '0' when others;

with state select
write_enable_sram <= '1' when STORE_OBJECT_BOUNDRY,
		'1' when DUMMYC,
		'1' when DUMMYD,
                '1' when SHADOW_SHADER_WAIT,
		'1' when OBJECT_SHADER_WAIT,
		'1' when DUMMYE,
		'1' when DUMMYF,
                '0' when others;

with state select
address <=     X"0000" + matrix_math_count when SEND_MATRIX_MATH_DATA,
	       X"0000" + matrix_math_count when PRE_SEND_MATRIX_MATH_DATA,
               X"0000" + matrix_math_count when DUMMY1,
               X"0000" + matrix_math_count when DUMMY2,
               
               X"0020" +  count when STORE_OBJECT_BOUNDRY,
 
	       X"0420" + count_shadow when SHADOW_SHADER_WAIT,
	       X"0420" + count_shadow when DUMMYC,
	       X"0420" + count_shadow when DUMMYD,
               X"3420" + count_shadow when OBJECT_SHADER_WAIT,
               X"3420" + count_shadow when DUMMYE,
               X"3420" + count_shadow when DUMMYF,


               X"0000"  + (count + count + count +count) when SEND_BUFFER_DATA,
               X"0000"  + (count + count + count +count) when DUMMYA,
               X"0000"  + (count + count + count +count) when DUMMYA2,
               X"0000" when others;

with state select
data_out <= (shader_datain_x & shader_datain_y) when SHADOW_SHADER_WAIT,
	    (shader_datain_x & shader_datain_y) when DUMMYC,
	    (shader_datain_x & shader_datain_y) when DUMMYD,
	    (shader_datain_x & shader_datain_y) when OBJECT_SHADER_WAIT,
	    (shader_datain_x & shader_datain_y) when DUMMYE,
	    (shader_datain_x & shader_datain_y) when DUMMYF,
	    (boundry_data_x&boundry_data_y) when STORE_OBJECT_BOUNDRY,
                   X"0000" when others;


with state select
write_enable_input_fifo <=  '1' when DUMMY1,
                            '0' when others;
end behavioral;
