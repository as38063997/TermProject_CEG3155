LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY TSR IS
    PORT(
        i_S0, i_S1 : IN STD_LOGIC;
        CLK : IN STD_LOGIC;
        RST : IN STD_LOGIC;
        i_I : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
        o_O : OUT STD_LOGIC;
		  o_PO: OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
    );
END TSR;

ARCHITECTURE rtl OF TSR IS
    SIGNAL int_A,int_B,int_notB,int_notA,int_left,int_right : STD_LOGIC_VECTOR(8 DOWNTO 0);

    COMPONENT fourtoonemux
        PORT(
            i_S : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            i_I :IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            o_O : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT enARdFF_2
        PORT(
            i_D : IN STD_LOGIC;
            i_clock : IN STD_LOGIC;
            i_enable : IN STD_LOGIC;
            i_resetBar : IN STD_LOGIC;
            o_Q : OUT STD_LOGIC
        );
    END COMPONENT;

BEGIN

    int_right(7 downto 0) <= int_B(8 downto 1);
    int_right(8) <= '1';
    int_left(8 downto 1)<= int_B(7 downto 0);
    int_left(0)<='0';

loop1:FOR i IN 8 downto 0 GENERATE
    mux: fourtoonemux
    PORT MAP (i_S=> i_S1 & i_S0,
              i_I=> i_I(i) & int_right(i) &  int_left(i) & int_B(i),
              o_O=> int_A(i));
END GENERATE;

loop2:FOR i IN 8 downto 0 GENERATE
    reg: enARdFF_2
    PORT MAP(i_resetBar => RST,
             i_d => int_A(i),
             i_enable => '1', 
			 i_clock => CLK,
			 o_q => int_B(i));
END GENERATE;

    o_O<= int_B(0);


END ARCHITECTURE;
