-- $Id: $
-- File name:   tb_shader.vhd
-- Created:     11/22/2011
-- Author:      Aashish Raj Simha
-- Lab Section: 337-04
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_shader is
end tb_shader;

architecture TEST of tb_shader is

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

  component shader
    PORT(
         CLK : in std_logic;
         RST : in std_logic;
         ENABLE : in std_logic;
         PIXEL_X1 : in std_logic_vector (7 downto 0);
         PIXEL_X2 : in std_logic_vector (7 downto 0);
				 PIXEL_Y1 : in std_logic_vector (7 downto 0);
         PIXEL_Y2 : in std_logic_vector (7 downto 0);
         --PIXELADDRESS_Y : out std_logic_vector(7 downto 0);
         SHADEPIXEL_X : out std_logic_vector(7 downto 0);
         SHADEPIXEL_Y : out std_logic_vector(7 downto 0);
         DONE : out std_logic
    );
  end component;

-- Insert signals Declarations here
  signal CLK : std_logic;
  signal RST : std_logic;
  signal ENABLE : std_logic;
  signal PIXEL_X1 : std_logic_vector (7 downto 0);
  signal PIXEL_X2 : std_logic_vector (7 downto 0);
  --signal PIXELADDRESS_Y : std_logic_vector(7 downto 0);
  signal PIXEL_Y1 :  std_logic_vector (7 downto 0);
  signal PIXEL_Y2 :  std_logic_vector (7 downto 0);
	signal SHADEPIXEL_X : std_logic_vector(7 downto 0);
  signal SHADEPIXEL_Y : std_logic_vector(7 downto 0);
  signal DONE : std_logic;

-- signal <name> : <type>;

begin
  DUT: shader port map(
                CLK => CLK,
                RST => RST,
                ENABLE => ENABLE,
                PIXEL_X1 => PIXEL_X1,
                PIXEL_X2 => PIXEL_X2,
                PIXEL_Y1 => PIXEL_Y1,
                PIXEL_Y2 => PIXEL_Y2,
                --PIXELADDRESS_Y => PIXELADDRESS_Y,
                SHADEPIXEL_X => SHADEPIXEL_X,
                SHADEPIXEL_Y => SHADEPIXEL_Y,
                DONE => DONE
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

    CLK <= '1';
    wait for 5 ns;
    CLK <= '0';
    wait for 5 ns;
    
  end process;
  
  process
    begin

    RST <= '1';
    wait for 20 ns;
    RST <= '0';
    wait;
    
  end process;
  
  process
    begin 

    ENABLE <= '1';
    wait for 40 ns ;
    ENABLE <= '0' ; 
    wait ; 
    
  end process;
  
  process
    begin

    PIXEL_X1 <= std_logic_vector(to_unsigned(45, 8));--"00001000";

    PIXEL_X2 <= std_logic_vector(to_unsigned(109, 8));
		
		PIXEL_Y1 <= std_logic_vector(to_unsigned(45, 8));

		PIXEL_Y2 <= std_logic_vector(to_unsigned(109, 8));
    
    wait;

  end process;
end TEST;
