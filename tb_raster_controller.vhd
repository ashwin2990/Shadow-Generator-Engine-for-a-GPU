-- $Id: $
-- File name:   tb_raster_controller.vhd
-- Created:     12/2/2011
-- Author:      Aashish Raj Simha
-- Lab Section: 337-04
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_raster_controller is
end tb_raster_controller;

architecture TEST of tb_raster_controller is

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

  component raster_controller
    PORT(
         clk : in std_logic;
         reset : in std_logic;
         input_fifo_shader_full : in std_logic;
         input_fifo_shader_empty : in std_logic;
         line_done : in std_logic;
         read_enable_input_shader : out std_logic;
         write_enable_input_shader : out std_logic;
         enable_line_raster_out : out std_logic;
         line_raster_busy : in std_logic;
         finsihed_boundary_out : out std_logic;
         output_buffer_math_empty : in std_logic;
         output_buffer_math_full : in std_logic;
         shadow_object : out std_logic;
         shader_enable : out std_logic;
         buffer_control_signal : out std_logic;
         shader_done : in std_logic
    );
  end component;

-- Insert signals Declarations here
  signal clk : std_logic;
  signal reset : std_logic;
  signal input_fifo_shader_full : std_logic;
  signal input_fifo_shader_empty : std_logic;
  signal line_done : std_logic;
  signal read_enable_input_shader : std_logic;
  signal write_enable_input_shader : std_logic;
  signal enable_line_raster_out : std_logic;
  signal line_raster_busy : std_logic;
  signal finsihed_boundary_out : std_logic;
  signal output_buffer_math_empty : std_logic;
  signal output_buffer_math_full : std_logic;
  signal shadow_object : std_logic;
  signal shader_enable : std_logic;
  signal shader_done : std_logic;
  signal buffer_control_signal : std_logic;

-- signal <name> : <type>;

begin
  DUT: raster_controller port map(
                clk => clk,
                reset => reset,
                input_fifo_shader_full => input_fifo_shader_full,
                input_fifo_shader_empty => input_fifo_shader_empty,
                line_done => line_done,
                read_enable_input_shader => read_enable_input_shader,
                write_enable_input_shader => write_enable_input_shader,
                enable_line_raster_out => enable_line_raster_out,
                line_raster_busy => line_raster_busy,
                finsihed_boundary_out => finsihed_boundary_out,
                output_buffer_math_empty => output_buffer_math_empty,
                output_buffer_math_full => output_buffer_math_full,
                shadow_object => shadow_object,
                shader_enable => shader_enable,
                shader_done => shader_done,
                buffer_control_signal => buffer_control_signal 
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

    clk <= '1';
    wait for 5 ns;
    clk <= '0';
    wait for 5 ns;
  end process;
  
process
  begin
    reset <= '1';
    wait for 20 ns;
    reset <= '0';
    wait;
  end process;
  
process
  begin
    output_buffer_math_full <= '1';
    input_fifo_shader_full <= '0';
    line_raster_busy <='0';
    input_fifo_shader_empty <= '0';
    line_done <= '0';
    shader_done <= '0';
    output_buffer_math_empty <= '0';
    wait for 20 ns;

    output_buffer_math_full <= '0';
    input_fifo_shader_full <= '1';
    line_raster_busy <='1';
    input_fifo_shader_empty <= '0';
    line_done <= '0';
    shader_done <= '0';
    output_buffer_math_empty <= '0';
    wait for 40 ns;
    
    output_buffer_math_full <= '0';
    input_fifo_shader_full <= '0';
    line_raster_busy <='0';
    input_fifo_shader_empty <= '1';
    line_done <= '0';
    shader_done <= '0';
    output_buffer_math_empty <= '0';
    wait for 40 ns;
    
     
    output_buffer_math_full <= '0';
    input_fifo_shader_full <= '0';
    line_raster_busy <='0';
    input_fifo_shader_empty <= '0';
    line_done <= '0';
    shader_done <= '1';
    output_buffer_math_empty <= '0';
    wait ;

  end process;
end TEST;