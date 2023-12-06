LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY tsrControl IS
    PORT(
        clk : IN std_logic;
        reset : IN std_logic;
        TDRE : IN std_logic;
        TDRE_set: OUT std_logic;
		  d_s:OUT std_logic_vector(2 downto 0);
		  d_cnta:OUT std_logic_vector(3 downto 0);
        i_s0,i_s1: OUT std_logic
    );
END tsrControl;

ARCHITECTURE rtl of tsrControl IS
    SIGNAL cnt_reg : std_logic_vector(3 downto 0);
    SIGNAL cnt,S3,S2,S1,S0: std_logic;
    
    COMPONENT enARdFF_2
        PORT(
			i_resetBar	: IN	STD_LOGIC;
			i_d		: IN	STD_LOGIC;
			i_enable	: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			o_q, o_qBar	: OUT	STD_LOGIC);
    END COMPONENT;

    COMPONENT enARdFF_2_rr IS
		PORT(
			i_resetBar	: IN	STD_LOGIC;
			i_d		: IN	STD_LOGIC;
			i_enable	: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			o_q, o_qBar	: OUT	STD_LOGIC);
    END COMPONENT;

    COMPONENT counter_4bit IS
    PORT(
        clk : IN std_logic;
        rst : IN std_logic;
        count : OUT std_logic_vector(3 DOWNTO 0)
    );
	END COMPONENT;

    BEGIN

    cnt <= cnt_reg(3) and cnt_reg(1);
	 	  
	 c_S3: enARdFF_2 PORT MAP(
        i_clock => clk,
        i_resetBar => reset,
        i_d => (S2 and cnt and TDRE),
        o_q => S3,
		  i_enable => '1'
    );

    c_S2: enARdFF_2 PORT MAP(
        i_clock => clk,
        i_resetBar => reset,
        i_d => S1 or (S2 and not cnt),
        o_q => S2,
		  i_enable => '1'
    );

    c_S1: enARdFF_2 PORT MAP(
        i_clock => clk,
        i_resetBar => reset,
        i_d => (S0 and not TDRE) or (S2 and cnt and not TDRE) or (S3 and TDRE),
        o_q => S1,
		  i_enable => '1'
    );

    c_S0: enARdFF_2_rr PORT MAP(
        i_clock => clk,
        i_resetBar => reset,
        i_d => (S0 and TDRE),
        o_q => S0,
		  i_enable => '1'
    );
    
    c_CNT: counter_4bit PORT MAP(
        clk => clk,
        rst => reset and (S0 or S2),
        count => cnt_reg
    );
	 
	 i_s0<=S1;
	 i_s1<=S1 or S2;
	 TDRE_set<=S1;
	 d_s<=(2=>s2,1=>s1,0=>s0);
	 d_cnta<=cnt_reg;
END ARCHITECTURE;
