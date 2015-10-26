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

entity interm_buffer is
	port(
    reset : in std_logic;
    clk : in std_logic;
		data_in: 	in	  std_logic_vector(15 downto 0 ) ;
		data_out_a: 		 out std_logic_vector(31 downto 16 );
    data_out_b:      out std_logic_vector(15 downto 0);
    write_enable:in std_logic;
    read_enable :in std_logic;
    reset_buffer:in std_logic;
    fifo_empty : out std_logic;
    buffer_full: 		out std_logic
		);
END interm_buffer;

architecture behavioral of interm_buffer is
 constant m : integer:=16;
 constant n : integer:=2;
 signal readptr,writeptr :std_logic;
 subtype wrdtype is std_logic_vector(m-1 downto 0);
 type regtype is array(0 to n-1) of wrdtype;
 signal regis : regtype;
 signal rw  : std_logic_vector(1 downto 0);
 signal full_buf,empty_buf: std_logic;
 
begin
 rw<=read_enable & write_enable;
 buffering:process(reset,clk,reset_buffer)
 begin 
 if (reset = '1') then 
 readptr<='0';
 writeptr<='0';
 empty_buf<='1';
 full_buf<='0';
 for k in 0 to n-1 loop
  regis(k) <= (others=>'0');
 end loop;

--elsif (reset_buffer='1') then 
-- readptr<='0';
-- writeptr<='0';
 --empty_buf<='1';
-- full_buf<='0';
 --for k in 0 to n-1 loop
 -- regis(k) <= (others=>'0');
-- end loop;
--for the else if case since we are writing twice and reading only once, the read_enable signal only ought to clean the buffer. 

 elsif(rising_edge(clk)) then 
 case rw is
  
 when "10"=>
  if(empty_buf='0') then
   empty_buf<='1';
   full_buf<='0';
	 readptr<='0';
   end if;
 
 
 when "01"=>
  if(full_buf='0') then
   regis(conv_integer(writeptr))<=data_in;
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
 
 data_out_a<=regis(conv_integer(readptr));
 data_out_b<=regis(conv_integer(not(readptr)));
 buffer_full<=full_buf;
 fifo_empty<=empty_buf;

 end behavioral;

  
 
 
 
