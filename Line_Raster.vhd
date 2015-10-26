library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity Line_Raster is
   port (
	 X0 : in std_logic_vector (7 downto 0);
	 X1 : in std_logic_vector (7 downto 0);
	 Y0 : in std_logic_vector (7 downto 0);
	 Y1 : in std_logic_vector (7 downto 0);
	 enable : in std_logic;
	 Clk : in std_logic;
	 Rst : in std_logic;
	 busy : out std_logic;
	 Addr_x : out std_logic_vector (7 downto 0);
	 Addr_y : out std_logic_vector (7 downto 0);
   boundry_out:out std_logic
);
end Line_Raster;

architecture Boundary of Line_Raster is
signal address_x : std_logic_vector(7 downto 0);
signal address_y : std_logic_vector(7 downto 0);
signal busy_sig : std_logic;
signal steep : std_logic;
signal ystep : std_logic;
signal borrow_bit : std_logic;
signal temp_x, temp_y, x0_1, y0_1, x0_2, y0_2,x1_1, y1_1, x1_2, y1_2, abs_y1y0, abs_x1x0,deltax, deltay, error_val :std_logic_vector (7 downto 0);
signal current_state : std_logic_vector(3 downto 0):= "0000";

begin
StateReg: process (Clk,Rst)
  begin
   if Rst = '1' then
       address_x <= (others => '0');
       address_y <= (others => '0');
       borrow_bit <= '0';
	     busy_sig <= '0';
       boundry_out<='0';
			 current_state <= "0000";
   elsif(rising_edge(Clk)) then
    if(enable = '1') then
      if(current_state <= "0000") then--here changed
            if(X0>X1) then 
               abs_x1x0 <= X0 - X1;
            else
               abs_x1x0 <= X1 - X0;
            end if;
            if Y0 > Y1 then
               abs_y1y0 <= Y0 - Y1;
            else
               abs_y1y0 <= Y1 - Y0;
            end if;     
            boundry_out<='0';
            current_state <= "0010";
     
       elsif(current_state <= "0010") then
            if abs_y1y0 > abs_x1x0 then --swap
              steep <= '1';
              x0_1 <= Y0;
              y0_1 <= X0;
              x1_1 <= Y1;
	            y1_1 <= X1;
              x0_2 <= abs_y1y0;
              abs_y1y0 <= abs_x1x0;
              abs_x1x0 <= x0_2;
           else
              steep <= '0';
              x0_1 <= X0;
              y0_1 <= Y0;
              x1_1 <= X1;
              y1_1 <= Y1;
           end if;       
            boundry_out<='0';   
            current_state <= "0011";
           
       elsif(current_state <= "0011") then
           if x0_1 > x1_1 then
              x0_2 <= x1_1;
              y0_2 <= y1_1;
              x1_2 <= x0_1;
              y1_2 <= y0_1;
           else
              x0_2 <= x0_1;
              y0_2 <= y0_1;
              x1_2 <= x1_1;
              y1_2 <= y1_1;
           end if;
           boundry_out<='0';
           current_state <= "0100";
       
       elsif(current_state <= "0100") then
           deltax <= x1_2 - x0_2;
           deltay <= abs_y1y0;
           error_val <= ( others => '0' );
           temp_y <= y0_2;--why do you do this?
           boundry_out<='0';
           current_state <= "0101";
      
       elsif(current_state <= "0101") then
           if y1_2 > y0_2 then
             ystep <= '1';
           else
             ystep <= '0';
           end if;
           temp_x <= x0_2;--why do you do this?
           boundry_out<='0';
           current_state <= "0110";
       
       elsif(current_state <= "0110") then
           busy_sig <= '1';
           boundry_out<='1';
           if steep = '1' then -- (tempy, tempx)
               address_x <= temp_y(7 downto 0);
               address_y <= temp_x(7 downto 0);   
           else -- (tempx, tempy)
               address_x <= temp_x(7 downto 0); 
               address_y <= temp_y(7 downto 0);
           end if;
           if temp_x = x1_2 then
             current_state <= "1111";
           else
             if borrow_bit = '1' then
               y0_1 <= error_val + deltay -deltax;
             end if;
             error_val <= error_val + deltay;
             current_state <= "0111";
           end if;
      
       elsif(current_state <= "0111") then
           boundry_out<='0';
           if borrow_bit = '1' then
             if error_val > deltax then -- return borrow
               x0_1 <= y0_1(6 downto 0) & '0';
               error_val <= error_val - deltax;
               borrow_bit <= '0';
             end if;
          else
             x0_1 <= error_val(6 downto 0) & '0';
          end if;
          current_state <= "1000";

       
       
       elsif(current_state <= "1000") then
          boundry_out<='0';
          if x0_1 > deltax and borrow_bit = '0' then
            if ystep = '1' then
              temp_y <= temp_y + 1;
            else
              temp_y <= temp_y - 1;
            end if;
            if deltax > error_val then
              borrow_bit <= '1';
            else
              borrow_bit <= '0';
              error_val <= error_val - deltax;
            end if;
          end if;
          temp_x <= temp_x +1;
          current_state <= "0110";
          
       elsif(current_state <= "1111") then
          boundry_out<='0';
          busy_sig<='0';
          current_state <= "0000";
     end if; 
     
   else        
          boundry_out<='0';
          busy_sig <= '1';
          current_state <= "0000";
      
   end if;

Addr_x<=address_x;
Addr_y<=address_y;

end if;
end process;

busy <= busy_sig;

end Boundary;

