LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
use ieee.std_logic_ARITH.all ; 
use ieee.std_logic_UNSIGNED.all ; 

entity line_buffer is
	port(
    reset       :  in std_logic;
    clk         :  in std_logic;
		data_in     : 	in	std_logic_vector(15 downto 0 ) ;
		data_in_ram: 	in	std_logic_vector(15 downto 0 ) ;
		x1_output   : 	out std_logic_vector(7 downto 0 );
		y1_output   :  out std_logic_vector(7 downto 0);
		x2_output   : 	out std_logic_vector(7 downto 0 );
		y2_output   :  out std_logic_vector(7 downto 0);
		control     :  in std_logic;--connected to shadow_object
      shading_or_boundary:in std_logic;  
    write_enable:  in std_logic;
    read_enable :  in std_logic;
    fifo_empty  :  out std_logic;
    buffer_full :  out std_logic
		);
END line_buffer;

architecture behavioral of line_buffer is
 constant m : integer:=8;
 constant n : integer:=8;
 signal readptr,writeptr :std_logic_vector(2 downto 0);
 subtype wrdtype is std_logic_vector(m-1 downto 0);
 type regtype is array(0 to n-1) of wrdtype;
 signal reg : regtype;
 signal rw  : std_logic_vector(1 downto 0);
 signal full_buf,empty_buf: std_logic;
 
begin
 rw<=read_enable & write_enable;
 buffering:process(reset, clk, control, data_in, data_in_ram,shading_or_boundary)
 begin 
 if(reset='1') then
 readptr<="000";
 writeptr<="000";
 empty_buf<='1';
 full_buf<='0';
 for k in 0 to n-1 loop
  reg(k) <= (others=>'0');
 end loop;

--for the else if case since we are writing twice and reading only once, the read_enable signal only ought to clean the buffer. 

 elsif(rising_edge(clk)) then 
 case rw is
  
 when "10"=>
  if(empty_buf='0') then
   if(shading_or_boundary='1') then
   if(readptr+2=writeptr) then
   empty_buf<='1';
   end if;
  readptr<=readptr+2;
  end if;
  end if; 
   full_buf<='0';
 
 when "01"=>
  if(full_buf='0') then
    if(control = '1') then
      reg(conv_integer(writeptr))<=data_in_ram(7 downto 0);      --object
    writeptr<=writeptr+1;
    if(writeptr+1=readptr) then
      full_buf<='1';
    end if;
    else 
      reg(conv_integer(writeptr))<=data_in(15 downto 8);     --shadow
      reg(conv_integer(writeptr+1))<=data_in(7 downto 0);
      writeptr<=writeptr+2;
    if(writeptr+2=readptr) then
      full_buf<='1';
    end if;
    end if; 
        
  end if;
  empty_buf<='0';
  
 when others=>
  null;

 end case;
 end if;
 end process;
 
 line_buffer_out:process(shading_or_boundary,read_enable, readptr, reg)
 begin
 if(shading_or_boundary='1') then
 x1_output<=128+reg(conv_integer(readptr));
 y1_output<=128-reg(conv_integer(readptr+1));
 x2_output<=128+reg(conv_integer(readptr+2));
 y2_output<=128-reg(conv_integer(readptr+3)); 
 else
 x1_output<=128+reg(conv_integer(readptr));
 y1_output<=128-reg(conv_integer(readptr+1));
 x2_output<=128+reg(conv_integer(readptr+6));
 y2_output<=128-reg(conv_integer(readptr+7));
 end if;
 end process;

 buffer_full<=full_buf;
 fifo_empty<=empty_buf;

 end behavioral;

  
