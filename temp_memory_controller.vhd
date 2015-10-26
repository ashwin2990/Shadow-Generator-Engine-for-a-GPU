-- $Id: $
-- File name:   temp_memory_controller.vhd
-- Created:     11/29/2011
-- Author:      Shantanu Shrikant Joshi
-- Lab Section: 337-04
-- Version:     1.0  Initial Design Entry
-- Description: basically implements the mem controller for the matrix math block. 


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

--algorithm: 
--1. wait for start from overall controller 
--2. output cuurent coordinate in SRAM memory till i reach 16 - if i reach 16 then go to nextstate which is simha init state.
--3. it takes 10ns for data to be ready to be read and 10 more for it to actually be read 
--4. therfore after setting the conditions for a read i want to wait 2 clock cycles. sys clock = 10ns 
--5. Repeat 2-4 till co-ordinates for entire vertex ( that is 4 ) are sent out. 
--6. Wait for write to memroy controller to be asserted 
--7. go to 2 

-- General Comment - It is the matrix_math Controllers responsibility to assert write mem controller appropriate no of times
entity temp_memory_controller is 
port (
					  write_memory_controller : in std_logic ; -- signal from the matrix math controller 
							start_overall_controller : in std_logic ; -- signal from the overall controller of the GPU 
							clk : in std_logic ; 
       reset : in std_logic ;
       sram_read_enable : out std_logic ; 
							sram_write_enable : out std_logic ; 
							addr      : out    std_logic_vector((16 - 1) downto 0) -- find out how to declare constants from tim here would 
                                                                -- code easier to change 
							 
           
);
end temp_memory_controller ; 


architecture fuck_purdue of temp_memory_controller is 

type stateType is (IDLE , Send_coordinate, wait1loopback, wait2loopback ) ; 
signal state, nextstate : stateType ;  



--need to declare a couple of integeres here... 


begin  -- architecture begins 

process( reset , clk ) -- process for clk and reset and nextstate = state 
begin 
if ( reset = '1' ) then 
state <= IDLE ; 
elsif (rising_edge(clk) ) then 
state <= nextstate ;   
end if ; 
end process ; -- end of clk and reset process 


nextstatelogic: process(state , write_memory_controller, start_overall_controller ) 
variable coordinate_count :integer range 0 to 5 := 0 ; 
variable overall_count : integer range 0 to 19 := 0 ; -- need to specify range 

begin 
case state is 

when IDLE =>

if ( (start_overall_controller = '1' or write_memory_controller = '1') and overall_count < 16 )  then 
nextstate <= Send_coordinate ; 
else 
nextstate <= IDLE ; 
end if ;  

when Send_coordinate  => 

if ( coordinate_count < 4 ) then 
--sram_read_enable <= '1' ; 
--sram_write_enable  <= '0';
--addr<= std_logic_vector(to_unsigned(overall_count, TB_ADDR_SIZE_BITS));
coordinate_count := coordinate_count + 1 ; 
overall_count := overall_count + 1 ; 
--overall_count = overall_count + 1 ; 
nextstate <= wait1loopback ; -- first wait state  
else 
nextstate <= IDLE ;
coordinate_count := 0;  
end if ; 

when wait1loopback => 
nextstate <= wait2loopback ; 

when wait2loopback => 
nextstate <= Send_coordinate ; 

end case ; 

end process nextstatelogic ; 

outlogic: process (state) 
variable overall_count : integer range 0 to 19 := 0 ; 
begin 
case state is 

when IDLE => 
  sram_read_enable  <= '0'; -- hopefully this does nothing as both the enables are 0 
  sram_write_enable  <= '0';
  addr <= std_logic_vector(to_unsigned(overall_count, 16));

when Send_coordinate =>
		sram_read_enable  <= '1'; -- read mode 
  sram_write_enable  <= '0';
  addr <= std_logic_vector(to_unsigned(overall_count, 16));
	 overall_count := overall_count + 1 ; 
  
when others =>
		sram_read_enable  <= '0';
  sram_write_enable  <= '0';
  addr <= std_logic_vector(to_unsigned(overall_count, 16));

end case ; 

end process outlogic ; 

end fuck_purdue ; 

  	



