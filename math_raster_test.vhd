-- VHDL Entity My_Lib.math_raster_test.symbol
--
-- Created:
--          by - mg60.bin (srge02.ecn.purdue.edu)
--          at - 22:10:11 11/27/11
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2010.2a (Build 7)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY math_raster_test IS
   PORT( 
      clk                               : IN     std_logic;
      control                           : IN     std_logic;
      data_in                           : IN     std_logic_vector (7 DOWNTO 0 );
      data_in_ram                       : IN     std_logic_vector (15 DOWNTO 0 );
      external_trigger                  : IN     std_logic;
      reset                             : IN     std_logic;
      z_l                               : IN     std_logic_vector (7 DOWNTO 0 );
      Addr                              : OUT    std_logic_vector (15 DOWNTO 0);
      finsihed_boundary_out             : OUT    std_logic;
      input_fifo_empty                  : OUT    std_logic;
      input_fifo_full                   : OUT    std_logic;
      write_to_memory_controller        : OUT    std_logic;
      write_to_memory_controller_shader : OUT    std_logic
   );

-- Declarations

END math_raster_test ;

--
-- VHDL Architecture My_Lib.math_raster_test.struct
--
-- Created:
--          by - mg60.bin (srge02.ecn.purdue.edu)
--          at - 22:10:11 11/27/11
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2010.2a (Build 7)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_UNSIGNED.all;

--LIBRARY My_Lib;

ARCHITECTURE struct OF math_raster_test IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL buffer_full               : std_logic;
   SIGNAL busy                      : std_logic;
   SIGNAL enable_line_raster_out    : std_logic;
   SIGNAL fifo_empty                : std_logic;
   SIGNAL output_buffer_empty       : std_logic;
   SIGNAL output_buffer_full        : std_logic;
   SIGNAL read_enable_input_shader  : std_logic;
   SIGNAL shadow_vertices           : std_logic_vector(15 DOWNTO 0);
   SIGNAL write_enable_input_shader : std_logic;
   SIGNAL x1_output                 : std_logic_vector(7 DOWNTO 0 );
   SIGNAL x2_output                 : std_logic_vector(7 DOWNTO 0 );
   SIGNAL y1_output                 : std_logic_vector(7 DOWNTO 0);
   SIGNAL y2_output                 : std_logic_vector(7 DOWNTO 0);


   -- Component Declarations
   COMPONENT Line_Raster
   PORT (
      Clk    : IN     std_logic;
      Rst    : IN     std_logic;
      X0     : IN     std_logic_vector (7 DOWNTO 0);
      X1     : IN     std_logic_vector (7 DOWNTO 0);
      Y0     : IN     std_logic_vector (7 DOWNTO 0);
      Y1     : IN     std_logic_vector (7 DOWNTO 0);
      enable : IN     std_logic;
      Addr   : OUT    std_logic_vector (15 DOWNTO 0);
      busy   : OUT    std_logic
   );
   END COMPONENT;
   COMPONENT line_buffer
   PORT (
      clk          : IN     std_logic;
      control      : IN     std_logic;
      data_in      : IN     std_logic_vector (15 DOWNTO 0 );
      data_in_ram  : IN     std_logic_vector (15 DOWNTO 0 );
      read_enable  : IN     std_logic;
      reset        : IN     std_logic;
      write_enable : IN     std_logic;
      buffer_full  : OUT    std_logic;
      fifo_empty   : OUT    std_logic;
      x1_output    : OUT    std_logic_vector (7 DOWNTO 0 );
      x2_output    : OUT    std_logic_vector (7 DOWNTO 0 );
      y1_output    : OUT    std_logic_vector (7 DOWNTO 0);
      y2_output    : OUT    std_logic_vector (7 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT matrix_math
   PORT (
      clk                        : IN     std_logic ;
      data_in                    : IN     std_logic_vector (7 DOWNTO 0 );
      external_trigger           : IN     std_logic ;
      reset                      : IN     std_logic ;
      z_l                        : IN     std_logic_vector (7 DOWNTO 0 );
      input_fifo_empty           : OUT    std_logic ;
      input_fifo_full            : OUT    std_logic ;
      output_buffer_empty        : OUT    std_logic ;
      output_buffer_full         : OUT    std_logic ;
      shadow_vertices            : OUT    std_logic_vector (15 DOWNTO 0);
      write_to_memory_controller : OUT    std_logic 
   );
   END COMPONENT;
   COMPONENT shader_controller
   PORT (
      clk                               : IN     std_logic;
      input_fifo_shader_empty           : IN     std_logic;
      input_fifo_shader_full            : IN     std_logic;
      line_raster_busy                  : IN     std_logic;
      output_buffer_math_empty          : IN     std_logic;
      output_buffer_math_full           : IN     std_logic;
      reset                             : IN     std_logic;
      enable_line_raster_out            : OUT    std_logic;
      finsihed_boundary_out             : OUT    std_logic;
      read_enable_input_shader          : OUT    std_logic;
      write_enable_input_shader         : OUT    std_logic;
      write_to_memory_controller_shader : OUT    std_logic
   );
   END COMPONENT;

   -- Optional embedded configurations
   -- pragma synthesis_off
 --  FOR ALL : Line_Raster USE ENTITY My_Lib.Line_Raster;
  -- FOR ALL : line_buffer USE ENTITY My_Lib.line_buffer;
  -- FOR ALL : matrix_math USE ENTITY My_Lib.matrix_math;
   --FOR ALL : shader_controller USE ENTITY My_Lib.shader_controller;
   -- pragma synthesis_on


BEGIN

   -- Instance port mappings.
   U_2 : Line_Raster
      PORT MAP (
         X0     => x1_output,
         X1     => x2_output,
         Y0     => y1_output,
         Y1     => y2_output,
         enable => enable_line_raster_out,
         Clk    => clk,
         Rst    => reset,
         busy   => busy,
         Addr   => Addr
      );
   U_1 : line_buffer
      PORT MAP (
         reset        => reset,
         clk          => clk,
         data_in      => shadow_vertices,
         data_in_ram  => data_in_ram,
         x1_output    => x1_output,
         y1_output    => y1_output,
         x2_output    => x2_output,
         y2_output    => y2_output,
         control      => control,
         write_enable => write_enable_input_shader,
         read_enable  => read_enable_input_shader,
         fifo_empty   => fifo_empty,
         buffer_full  => buffer_full
      );
   U_0 : matrix_math
      PORT MAP (
         clk                        => clk,
         data_in                    => data_in,
         external_trigger           => external_trigger,
         reset                      => reset,
         z_l                        => z_l,
         input_fifo_empty           => input_fifo_empty,
         input_fifo_full            => input_fifo_full,
         output_buffer_empty        => output_buffer_empty,
         output_buffer_full         => output_buffer_full,
         shadow_vertices            => shadow_vertices,
         write_to_memory_controller => write_to_memory_controller
      );
   U_3 : shader_controller
      PORT MAP (
         clk                               => clk,
         reset                             => reset,
         write_to_memory_controller_shader => write_to_memory_controller_shader,
         input_fifo_shader_full            => buffer_full,
         input_fifo_shader_empty           => fifo_empty,
         read_enable_input_shader          => read_enable_input_shader,
         write_enable_input_shader         => write_enable_input_shader,
         enable_line_raster_out            => enable_line_raster_out,
         line_raster_busy                  => busy,
         finsihed_boundary_out             => finsihed_boundary_out,
         output_buffer_math_empty          => output_buffer_empty,
         output_buffer_math_full           => output_buffer_full
      );

END struct;