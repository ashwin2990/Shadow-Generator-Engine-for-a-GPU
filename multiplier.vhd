-- $Id: $
-- File name:   multiplier.vhd
-- Created:     11/04/2011
-- Author:      Ashwin Shankar
-- Lab Section: 337-04
-- Version:     1.0  Initial Design Entry
-- Description: multiplier VHDL file

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier is
port 
	(
		a		: in std_logic_vector(7 downto 0);
		b		: in std_logic_vector(7 downto 0);
		result	: out std_logic_vector(15 downto 0);
    multiplication_done : out std_logic;
    output_ready:in std_logic;
    multiply:in std_logic
	);

end entity;

architecture rtl of multiplier is
begin
  PROCESS (a ,b, multiply )

	BEGIN
		IF ((multiply='1')) THEN
  result <= std_logic_vector(signed(a) * signed(b));
  multiplication_done<= '1';
 	ELSE
  result<=std_logic_vector(signed(a) * signed(b));
  multiplication_done <='0'; 
  end if;
 end process;
end rtl;

