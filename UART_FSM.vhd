LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY UART_FSM IS
    PORT(
        i_LS:IN STD_LOGIC_VECTOR(1 downto 0);
        i_resetBar, i_clock:IN	STD_LOGIC;
        o_A:OUT STD_LOGIC_VECTOR(1 downto 0);
        o_R,o_TR:OUT STD_LOGIC;
        i_databus:IN STD_LOGIC_VECTOR(7 downto 0);
        o_databus:OUT STD_LOGIC_VECTOR(7 downto 0)
    );
END ENTITY;

ARCHITECTURE rtl of UART_FSM IS
    SIGNAL int_S,int_A,int_B: STD_LOGIC_VECTOR(48 downto 0);
    SIGNAL int_bk:STD_LOGIC;

    COMPONENT enARdFF_2
		PORT(
			i_resetBar	: IN	STD_LOGIC;
			i_d		: IN	STD_LOGIC;
			i_enable	: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			o_q, o_qBar	: OUT	STD_LOGIC);
	END COMPONENT;

    COMPONENT enARdFF_2_rr
		PORT(
			i_resetBar	: IN	STD_LOGIC;
			i_d		: IN	STD_LOGIC;
			i_enable	: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			o_q, o_qBar	: OUT	STD_LOGIC);
	END COMPONENT;

BEGIN

	int_A(2)<=int_S(1) and i_databus(7);
	int_A(4)<=int_S(3) and i_databus(7);
	int_A(6)<=int_S(5) and i_databus(7);
	int_A(8) <= int_S(7) and i_databus(7);
	int_A(10) <= int_S(9) and i_databus(7);
	int_A(12) <= int_S(11) and i_databus(7);
	int_A(14) <= int_S(13) and i_databus(7);
	int_A(16) <= int_S(15) and i_databus(7);
	int_A(18) <= int_S(17) and i_databus(7);
	int_A(20) <= int_S(19) and i_databus(7);
	int_A(22) <= int_S(21) and i_databus(7);
	int_A(24) <= int_S(23) and i_databus(7);
	int_A(26) <= int_S(25) and i_databus(7);
	int_A(28) <= int_S(27) and i_databus(7);
	int_A(30) <= int_S(29) and i_databus(7);
	int_A(32) <= int_S(31) and i_databus(7);
	int_A(34) <= int_S(33) and i_databus(7);
	int_A(36) <= int_S(35) and i_databus(7);
	int_A(38) <= int_S(37) and i_databus(7);
	int_A(40) <= int_S(39) and i_databus(7);
	int_A(42) <= int_S(41) and i_databus(7);
	int_A(44) <= int_S(43) and i_databus(7);
	int_A(46) <= int_S(45) and i_databus(7);
	int_A(48) <= int_S(47) and i_databus(7);
	
	int_A(3)<=int_S(2) or (int_S(3) and not i_databus(7));
	int_A(5)<=int_S(4) or (int_S(5) and not i_databus(7));
	int_A(7)<=int_S(6) or (int_S(7) and not i_databus(7));
	int_A(9) <= int_S(8) or (int_S(9) and not i_databus(7));
	int_A(11) <= int_S(10) or (int_S(11) and not i_databus(7));
	int_A(13) <= int_S(12) or (int_S(13) and not i_databus(7));
	int_A(15) <= int_S(14) or (int_S(15) and not i_databus(7));
	int_A(17) <= int_S(16) or (int_S(17) and not i_databus(7));
	int_A(19) <= int_S(18) or (int_S(19) and not i_databus(7));
	int_A(21) <= int_S(20) or (int_S(21) and not i_databus(7));
	int_A(23) <= int_S(22) or (int_S(23) and not i_databus(7));
	int_A(25) <= int_S(24) or (int_S(25) and not i_databus(7));
	int_A(27) <= int_S(26) or (int_S(27) and not i_databus(7));
	int_A(29) <= int_S(28) or (int_S(29) and not i_databus(7));
	int_A(31) <= int_S(30) or (int_S(31) and not i_databus(7));
	int_A(33) <= int_S(32) or (int_S(33) and not i_databus(7));
	int_A(35) <= int_S(34) or (int_S(35) and not i_databus(7));
	int_A(37) <= int_S(36) or (int_S(37) and not i_databus(7));
	int_A(39) <= int_S(38) or (int_S(39) and not i_databus(7));
	int_A(41) <= int_S(40) or (int_S(41) and not i_databus(7));
	int_A(43) <= int_S(42) or (int_S(43) and not i_databus(7));
	int_A(45) <= int_S(44) or (int_S(45) and not i_databus(7));
	int_A(47) <= int_S(46) or (int_S(47) and not i_databus(7));
	
	int_bk <= int_S(12) or int_S(24) or int_S(36) or int_S(48);

--special states
--state S0
regS0: enARdFF_2_rr
    PORT MAP(i_resetBar => i_resetBar,
             i_d => int_bk,
             i_enable => '1', 
			 i_clock => i_clock,
			 o_q => int_S(0));

--state S1
regS1: enARdFF_2
    PORT MAP(i_resetBar => i_resetBar,
             i_d => (int_S(0) and not i_LS(1) and not i_LS(0)) or (int_S(1) and not i_databus(7)),
             i_enable => '1', 
			 i_clock => i_clock,
			 o_q => int_S(1));
            
--state S13
regS13: enARdFF_2
    PORT MAP(i_resetBar => i_resetBar,
             i_d => (int_S(0) and not i_LS(1) and i_LS(0)) or (int_S(13) and not i_databus(7)),
             i_enable => '1', 
			 i_clock => i_clock,
			 o_q => int_S(13));

--state S25
regS25: enARdFF_2
    PORT MAP(i_resetBar => i_resetBar,
             i_d => (int_S(0) and i_LS(1) and not i_LS(0)) or (int_S(25) and not i_databus(7)),
             i_enable => '1', 
			 i_clock => i_clock,
			 o_q => int_S(25));

--state S37
regS37: enARdFF_2
    PORT MAP(i_resetBar => i_resetBar,
             i_d => (int_S(0) and i_LS(1) and i_LS(0)) or (int_S(37) and not i_databus(7)),
             i_enable => '1', 
			 i_clock => i_clock,
			 o_q => int_S(37));
			 
	

--common states
loop1: FOR i IN 12 downto 2 GENERATE
        reg: enARdFF_2
        PORT MAP(i_resetBar => i_resetBar,
                 i_d => int_A(i),
                 i_enable => '1', 
                 i_clock => i_clock,
                 o_q => int_S(i));
END GENERATE;

loop2: FOR i IN 24 downto 14 GENERATE

        reg: enARdFF_2
        PORT MAP(i_resetBar => i_resetBar,
                 i_d => int_A(i),
                 i_enable => '1', 
                 i_clock => i_clock,
                 o_q => int_S(i));

END GENERATE;

loop3: FOR i IN 36 downto 26 GENERATE
        reg: enARdFF_2
        PORT MAP(i_resetBar => i_resetBar,
                 i_d => int_A(i),
                 i_enable => '1', 
                 i_clock => i_clock,
                 o_q => int_S(i) );

END GENERATE;

loop4: FOR i IN 48 downto 38 GENERATE

        reg: enARdFF_2
        PORT MAP(i_resetBar => i_resetBar,
                 i_d => int_A(i),
                 i_enable => '1', 
                 i_clock => i_clock,
                 o_q => int_S(i));

END GENERATE;

    --common state control
    o_A(0) <= int_S(1) or int_S(3) or int_S(5) or int_S(7) or int_S(9) or
          int_S(11) or int_S(13) or int_S(15) or int_S(17) or int_S(19) or
          int_S(21) or int_S(23) or int_S(25) or int_S(27) or int_S(29) or
          int_S(31) or int_S(33) or int_S(35) or int_S(37) or int_S(39) or
          int_S(41) or int_S(43) or int_S(45) or int_S(47);
    o_A(1) <= '0';
    o_R <= int_S(1) or int_S(3) or int_S(5) or int_S(7) or int_S(9) or
          int_S(11) or int_S(13) or int_S(15) or int_S(17) or int_S(19) or
          int_S(21) or int_S(23) or int_S(25) or int_S(27) or int_S(29) or
          int_S(31) or int_S(33) or int_S(35) or int_S(37) or int_S(39) or
          int_S(41) or int_S(43) or int_S(45) or int_S(47);
    o_TR <= int_S(1) or int_S(3) or int_S(5) or int_S(7) or int_S(9) or
          int_S(11) or int_S(13) or int_S(15) or int_S(17) or int_S(19) or
          int_S(21) or int_S(23) or int_S(25) or int_S(27) or int_S(29) or
          int_S(31) or int_S(33) or int_S(35) or int_S(37) or int_S(39) or
          int_S(41) or int_S(43) or int_S(45) or int_S(47);

    o_databus(7) <= int_S(4) or int_S(16) or int_S(34) or int_S(46);
    o_databus(6) <= int_S(2) or int_S(4) or int_S(6) or int_S(8) or int_S(10) or
                    int_S(14) or int_S(16) or int_S(18) or int_S(20) or int_S(22) or 
                    int_S(26) or int_S(28) or int_S(30) or int_S(32) or int_S(34) or 
                    int_S(38) or int_S(40) or int_S(42) or int_S(44) or int_S(46);
    o_databus(5) <= int_S(4) or int_S(10) or int_S(16) or int_S(22) or int_S(28) or 
                    int_S(34) or int_S(40) or int_S(46);
    o_databus(4) <= int_S(6) or int_S(8) or int_S(10) or int_S(16) or int_S(18) or 
                    int_S(20) or int_S(22) or int_S(28) or int_S(30) or int_S(32) or 
                    int_S(40) or int_S(42) or int_S(44) or int_S(46);
    o_databus(3) <= int_S(2) or int_S(6) or int_S(12) or int_S(14) or int_S(16) or 
                    int_S(18) or int_S(24) or int_S(26) or int_S(30) or int_S(36) or 
                    int_S(38) or int_S(42) or int_S(46) or int_S(48);
    o_databus(2) <= int_S(2) or int_S(4) or int_S(6) or int_S(14) or int_S(18) or 
                    int_S(26) or int_S(30) or int_S(34) or int_S(38) or int_S(42);
    o_databus(1) <= int_S(4) or int_S(6) or int_S(8) or int_S(10) or int_S(12) or 
                    int_S(18) or int_S(20) or int_S(22) or int_S(24) or int_S(28) or 
                    int_S(30) or int_S(32) or int_S(34) or int_S(36) or int_S(40) or 
                    int_S(42) or int_S(44) or int_S(48);
    o_databus(0) <= int_S(2) or int_S(4) or int_S(6) or int_S(8) or
          int_S(14) or int_S(16) or int_S(18) or
          int_S(20) or int_S(26)or
          int_S(30) or int_S(32) or int_S(34) or int_S(38) or
          int_S(42) or int_S(44) or int_S(46);


END ARCHITECTURE;