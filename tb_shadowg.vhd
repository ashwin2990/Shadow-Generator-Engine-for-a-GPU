-- $Id: $
-- File name:   tb_temp_memory_controller.vhd
-- Created:     11/30/2011
-- Author:      Shantanu Shrikant Joshi
-- Lab Section: 337-04
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model
LIBRARY ECE337_IP;
use ECE337_IP.all ;

entity tb_shadowg is
end tb_shadowg;

architecture TEST of tb_shadowg is

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

component scalable_off_chip_sram is
    generic (
            -- Memory Model parameters
            ADDR_SIZE_BITS  : natural  := 12;    -- Address bus size in bits/pins with addresses corresponding to 
                                                -- the starting word of the accesss
            WORD_SIZE_BYTES  : natural  := 1;      -- Word size of the memory in bytes
            DATA_SIZE_WORDS  : natural  := 1;      -- Data bus size in "words"
            READ_DELAY      : time    := 10 ns;  -- Delay/latency per read access (total time between start of supplying address and when the data read from memory appears on the r_data port)
                                                -- Keep the 10 ns delay for on-chip SRAM
            WRITE_DELAY      : time    := 10 ns    -- Delay/latency per write access (total time between start of supplying address and when the w_data value is written into memory)
                                                -- Keep the 10 ns delay for on-chip SRAM
          );
port   (
          -- Test bench control signals
          mem_clr        : in  boolean;
          mem_init      : in  boolean;
          mem_dump      : in  boolean;
          verbose        : in  boolean;
          init_filename  : in   string;
          dump_filename  : in   string;
          start_address  : in  natural;
          last_address  : in  natural;
          
          -- Memory interface signals
          r_enable  : in    std_logic;
          w_enable  : in    std_logic;
          addr      : in    std_logic_vector((addr_size_bits - 1) downto 0);
          data      : inout  std_logic_vector(((data_size_words * word_size_bytes * 8) - 1) downto 0)
        );
  end component scalable_off_chip_sram ;

--declaring constants ---  


 component shadowg
    PORT(
 --     boundry_object_shadow    : IN     std_logic;
      clk                      : IN     std_logic;
      data_in                  : IN     std_logic_vector (15 DOWNTO 0 );
      external_trigger         : IN     std_logic;
      reset                    : IN     std_logic;
     -- start_overall_controller : IN     std_logic;
      z_l                      : IN     std_logic_vector (7 DOWNTO 0 );
      address                  : OUT    std_logic_vector (15 DOWNTO 0);
      data_out                 : OUT    std_logic_vector (15 DOWNTO 0);
      read_enable_sram         : OUT    std_logic;
      write_enable_sram        : OUT    std_logic
    );
  end component;

-- Insert signals Declarations here
--  signal boundry_object_shadow : std_logic;
  signal external_trigger : std_logic;
 -- signal start_overall_controller : std_logic;
  signal z_l : std_logic_vector (7 DOWNTO 0 );
  signal clk : std_logic;
  signal reset : std_logic;
  signal read_enable_sram : std_logic;
  signal write_enable_sram : std_logic;
  signal address : std_logic_vector(15 downto 0) ;
  signal data_in : std_logic_vector(15 downto 0)  ;
  signal data_out :std_logic_vector (15 DOWNTO 0);

--declaring constants --- 

constant TB_ADDR_SIZE_BITS :natural  := 16 ; 
constant TB_WORD_SIZE_BYTES :natural := 2 ;-- changed it for his highness simha 
constant TB_DATA_SIZE_WORDS :natural := 1 ; 
constant TB_CLK_PERIOD :time := 12 ns ; 
constant TB_MAX_ADDRESS :natural := 65535 ; 
constant TB_DATA_SIZE_BITS :natural := tb_word_size_bytes * tb_data_size_words * 8 ; 



--declaring signals to portmap to the SRAM 

signal tb_mem_clr :boolean ;
signal tb_mem_init : boolean ;
signal tb_mem_dump : boolean ;
signal tb_verbose : boolean ; 
signal tb_init_filename : string(24 downto 1 )  ; 
signal tb_dump_filename : string(24 downto 1 )  ; 
signal tb_start_address : natural ; 
signal tb_last_address : natural ; 
--signal tb_read_enable: std_logic ; 
--signal tb_write_enable : std_logic ; 
--signal tb_addr_bus :std_logic_vector((tb_addr_size_bits - 1) downto 0);
signal tb_data: std_logic_vector(((tb_data_size_words * tb_word_size_bytes * 8) - 1) downto 0) ; 
--signal tb_read_data : std_logic_vector(((tb_data_size_words * tb_word_size_bytes * 8) - 1) downto 0) ; 
--signal tb_write_data : std_logic_vector(((tb_data_size_words * tb_word_size_bytes * 8) - 1) downto 0) ;


-- signal <name> : <type>;

begin
 
  DUT: shadowg port map(
                 clk => clk,                     
                data_in => data_in,               
                external_trigger => external_trigger,       
                reset => reset,                  
           --     start_overall_controller => start_overall_controller,
                z_l => z_l,                    
                address => address,                 
                data_out => data_out,                
                read_enable_sram => read_enable_sram,      
                write_enable_sram => write_enable_sram      
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

RAM: scalable_off_chip_sram 
generic map (
                  -- Memory interface parameters
  																-- place to override the default constants in the SRAM 

                  ADDR_SIZE_BITS  => TB_ADDR_SIZE_BITS,
                  WORD_SIZE_BYTES  => TB_WORD_SIZE_BYTES,
                  DATA_SIZE_WORDS  => TB_DATA_SIZE_WORDS,
                  READ_DELAY      => (TB_CLK_PERIOD - 2 ns),  -- CLK is 2 ns longer than access delay for conservative padding for flipflop setup times and propagation delays from the external SRAM chip to the internal flipflops
                  WRITE_DELAY      => (TB_CLK_PERIOD - 2 ns)    -- CLK is 2 ns longer than access delay for conservative padding for Real SRAM hold times and propagation delays from the internal flipflops to the external SRAM chip
                )

port map  (
                -- Test bench control signals
                mem_clr        => tb_mem_clr,
                mem_init      => tb_mem_init,
                mem_dump      => tb_mem_dump,
                verbose        => tb_verbose,
                init_filename  => tb_init_filename,
                dump_filename  => tb_dump_filename,
                start_address  => tb_start_address,
                last_address  => tb_last_address,
                
                -- Memory interface signals
                r_enable  => read_enable_sram,
                w_enable  => write_enable_sram,
                addr      => address,
                data      => tb_data
              );



IO_DATA: process (read_enable_sram, write_enable_sram, tb_data, data_out)
  begin
    if (read_enable_sram = '1') then
      -- Read mode -> the data pins should connect to the r_data bus & the other bus should high impedence
      data_in  <= tb_data;
      tb_data        <= (others=>'Z');
    elsif(write_enable_sram = '1') then
      -- Write mode -> the data pins should connect to the w_data bus & the other bus should highimpedeance
      data_in <= (others=>'Z');
      tb_data  <= data_out;
    else
      -- Disconnect both busses
      data_in  <= (others=>'Z');
      tb_data        <= (others=>'Z');
    end if;
  end process IO_DATA;



process -- 10 ns clock cycles 
begin 
clk <= '1' ; 
wait for 5 ns ;
clk <= '0' ; 
wait for 5 ns ; 
end process ; 

process -- ensuring reset happens at the start 
begin 
reset <= '1' ; 
z_l<=X"40";
wait for 5 ns ; 
reset <= '0' ;
z_l<=X"40"; 
wait ; 
end process ; 


process

  begin
       external_trigger <= '0' ;
           
-- Example of how to init the memory contents from a file
  tb_mem_init        <= TRUE;
  tb_init_filename  <= "source/test_mem_init.txt";
  wait for 20 ns;  -- Can be as long or as short as you like, as long as it is longer than 1 simulation time-step
  tb_mem_init        <= FALSE;
  wait for 1 ns ; 
-- Insert TEST BENCH Code Here


    external_trigger <= '0' ; 
 
				wait for 7 ns ; 
--		boundry_object_shadow<= '1' ;      
        external_trigger <= '1' ;
    wait for 10 ns ; 
     			 

    		external_trigger <= '0' ; 
   wait for 900 ns;

				
     
       external_trigger <= '1' ;
    wait for 10 ns ; 
     			 

    		external_trigger <= '0' ; 
 wait for 900 ns;

     
       external_trigger <= '1' ;
    wait for 10 ns ; 
      			 

    		external_trigger <= '0' ; 
 wait for 870 ns;

				
    
             external_trigger <= '1' ;
    wait for 10 ns ; 
   			 

    		external_trigger <= '0' ; 
  wait for 500000 ns;

-- Example of how to dump the memory contents to a file
   tb_mem_dump        <= TRUE;
  tb_dump_filename  <=  "source/test_mem_dump.txt";
  tb_start_address  <= 0; -- Can be any address 
  tb_last_address    <= TB_MAX_ADDRESS; -- Can be any address larger than the start_address
  wait for 1 ns; -- Can be as long or as short as you like, as long as it is longer than 1 simulation time-step
  tb_mem_dump        <= FALSE;

 

wait ; 
  end process;
end TEST;
