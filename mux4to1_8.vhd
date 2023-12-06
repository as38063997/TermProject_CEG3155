LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux4to1_8 IS
    PORT(
        i_S:IN STD_LOGIC_VECTOR(1 downto 0);
        i_I3,i_I2,i_I1,i_I0:IN STD_LOGIC_VECTOR(7 downto 0);
        o_O:OUT STD_LOGIC_VECTOR(7 downto 0));
END ENTITY;

ARCHITECTURE rtl OF mux4to1_8 IS
    SIGNAL int_I3,int_I2,int_I1,int_I0,int_S0,int_S1:STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL A0,A1,A2,A3:STD_LOGIC_VECTOR(7 downto 0);
BEGIN 
	 int_I3<=i_I3;
     int_I2<=i_I2;
     int_I1<=i_I1;
     int_I0<=i_I0;
	  int_S0<=(others=>i_S(0));
	  int_S1<=(others=>i_S(1));
    A3<= int_I3 and int_S0 and int_S1;
    A2<= int_I2 and not int_S0 and int_S1;
    A1<= int_I1 and int_S0 and not int_S1;
    A0<= int_I0 and not int_S0 and not int_S1;
    o_O<=A3 or A2 or A1 or A0;
END ARCHITECTURE;