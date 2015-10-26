-- $Id: $
-- File name:   input_fifo.vhd
-- Created:     11/4/2011
-- Author:      Ashwin Shankar
-- Lab Section: 337-04
-- Version:     1.0  Initial Design Entry
-- Description: fifo VHDL File

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
use ieee.std_logic_ARITH.all ; 
use ieee.std_logic_UNSIGNED.all ; 

entity input_fifo is
	port(
    reset : in std_logic;
    clk : in std_logic;
		data_in: 	in	  std_logic_vector(15 downto 0 ) ;
		data_out_a: 		 out std_logic_vector(7 downto 0 );
    data_out_b:      out std_logic_vector(7 downto 0);
    write_enable:in std_logic;
    read_enable :in std_logic;
    input_fifo_empty : out std_logic;
    input_fifo_full: 		out std_logic
		);
END input_fifo;


architecture behavioral of input_fifo is
 constant m : integer:=8;
 constant n : integer:=4;
 signal readptr,writeptr :std_logic_vector(1 downto 0);
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
 readptr<="00";
 writeptr<="00";
 empty_buf<='1';
 full_buf<='0';
 for k in 0 to n-1 loop
  regis(k) <= (others=>'0');
 end loop;

 elsif(rising_edge(clk)) then 
 case rw is

 when "10"=>
  if(empty_buf='0') then
   if(readptr+2=writeptr) then
   empty_buf<='1';
   end if;
   readptr<=readptr+2;
  end if; 
   full_buf<='0';
 
 when "01"=>
  if(full_buf='0') then
   regis(conv_integer(writeptr))<=data_in(7 downto 0);
   if(writeptr+1=readptr) then
   full_buf<='1';
   end if;
  writeptr<=writeptr+1;
  readptr<="00";
  end if;
  empty_buf<='0';

 
 when others=>
  if(readptr+2=writeptr) then
   empty_buf<='1';
   end if;
 end case;
 end if;
 end process;



 data_out_a<=(regis(conv_integer(readptr))) when readptr="10" else (not(regis(conv_integer(readptr)))+1);
 data_out_b<=(regis(conv_integer(readptr+1))) when readptr="10" else (regis(conv_integer(readptr+1)));
 input_fifo_full<=full_buf;
 input_fifo_empty<=empty_buf;
 
 end behavioral;
