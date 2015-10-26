-- $Id: $
-- File name:   tb_Line_Raster.vhd
-- Created:     11/12/2011
-- Author:      Yang Yang
-- Lab Section: 337-04
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_Line_Raster is
end tb_Line_Raster;

architecture TEST of tb_Line_Raster is

  function UINT_TO_STD_LOGIC( X: INTEGER; NumBits: INTEGER )
     return STD_LOGIC_VECTOR is
  begin
    return std_logic_vector(to_unsigned(X, NumBits));
  end;

  function STD_LOGIC_TO_UINT( X: std_logic_vector)
     return integer is
  begin
    return to_integer(unsigned(x));
  end;

  component Line_Raster
    PORT(
         X0 : in std_logic_vector (7 downto 0);
         X1 : in std_logic_vector (7 downto 0);
         Y0 : in std_logic_vector (7 downto 0);
         Y1 : in std_logic_vector (7 downto 0);
         enable : in std_logic;
         Clk : in std_logic;
         Rst : in std_logic;
         busy : out std_logic;
         Addr : out std_logic_vector (15 downto 0)
    );
  end component;

-- Insert signals Declarations here
  signal X0 : std_logic_vector (7 downto 0);
  signal X1 : std_logic_vector (7 downto 0);
  signal Y0 : std_logic_vector (7 downto 0);
  signal Y1 : std_logic_vector (7 downto 0);
  signal enable : std_logic;
  signal Clk : std_logic;
  signal Rst : std_logic;
  signal busy : std_logic;
  signal Addr : std_logic_vector (15 downto 0);

-- signal <name> : <type>;

begin
  DUT: Line_Raster port map(
                X0 => X0,
                X1 => X1,
                Y0 => Y0,
                Y1 => Y1,
                enable => enable,
                Clk => Clk,
                Rst => Rst,
                busy => busy,
                Addr => Addr
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);


-- Insert TEST BENCH Code Here

    X0 <= "00010000";
    X1 <= "00001000";
    Y0 <= "00001000";
    Y1 <= "00000100";
    enable <= '1';
  
process
    begin
    Clk <= '0';
    wait for 5 ns;
    Clk <='1';
    wait for 5 ns;
  end process;

process
  begin
    Rst <= '1';
    wait for 10 ns;
    Rst <='0';
    wait;
  end process;

end TEST;
