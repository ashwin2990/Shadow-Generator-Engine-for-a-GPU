-- $Id: $
-- File name:   intermbuffer.vhd
-- Created:     11/4/2011
-- Author:      Ashwin Shankar
-- Lab Section: 337-04
-- Version:     1.0  Initial Design Entry
-- Description: fifo VHDL File

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
use ieee.std_logic_ARITH.all ; 
use ieee.std_logic_UNSIGNED.all ; 

entity output_buffer is
	port(
    reset : in std_logic;
    clk : in std_logic;
  --  reset_buffer: in std_logic;
    adder_result: in std_logic_vector(15 downto 0 ) ;
    shadow_vertices:out std_logic_vector(15 downto 0);
    write_enable:in std_logic;
    read_enable :in std_logic;
    output_buffer_empty : out std_logic;
    output_buffer_full: 		out std_logic);
end output_buffer;

architecture behavioral of output_buffer is
 constant m: integer :=16;
 constant n: integer :=2;
 signal readptr,writeptr:std_logic;
 subtype wrdtype is std_logic_vector(m-1 downto 0);
 type regtype is array(0 to n-1) of wrdtype;
 signal regis : regtype;
 signal rw  : std_logic_vector(1 downto 0);
 signal full_buf,empty_buf: std_logic;

begin
 rw<=read_enable & write_enable;
 output_buffer:process(reset,clk)
 begin 
 if(reset='1') then
 readptr<='0';
 writeptr<='0';
 empty_buf<='1';
 full_buf<='0';
 for k in 0 to n-1 loop
  regis(k) <= (others=>'0');
 end loop;

 elsif(rising_edge(clk)) then 
 case rw is
 
 when "10"=>
  if(empty_buf='0') then
   empty_buf<='1';
  end if; 
   full_buf<='0';
	 readptr<='0';
 
 when "01"=>
  if(full_buf='0') then
   regis(conv_integer(writeptr))<=adder_result;
   if(not(writeptr)=readptr) then
   full_buf<='1';
   end if;
  writeptr<=not(writeptr);
  end if;
  empty_buf<='0';
 
 when others=>
 null;
 end case;
 end if;
 end process;

 shadow_vertices<=(regis(conv_integer(readptr))(7 DOWNTO 0))&(regis(conv_integer(not(readptr)))(7 DOWNTO 0));
 output_buffer_full<=full_buf;
 output_buffer_empty<=empty_buf;
 
 end behavioral;

 
 
