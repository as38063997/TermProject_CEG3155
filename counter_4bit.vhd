LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY counter_4bit IS
    PORT(
        clk : IN std_logic;
        rst : IN std_logic;
        count : OUT std_logic_vector(3 DOWNTO 0)
    );
END counter_4bit;

ARCHITECTURE rtl OF counter_4bit IS
    SIGNAL int_d,int_i:std_logic_vector(3 downto 0);

    COMPONENT enARdFF_2 IS
    PORT(
        i_resetBar	: IN	STD_LOGIC;
		i_d		: IN	STD_LOGIC;
		i_enable	: IN	STD_LOGIC;
		i_clock		: IN	STD_LOGIC;
		o_q, o_qBar	: OUT	STD_LOGIC
    );
    END COMPONENT;

BEGIN


    int_i(3) <= (int_d(3) and not int_d(2)) or (int_d(3) and not int_d(0)) or (int_d(3) and not int_d(1)) or (not int_d(3) and int_d(2) and int_d(1) and int_d(0));
    int_i(2) <= (int_d(2) and not int_d(0)) or (int_d(2) and not int_d(1)) or (not int_d(2) and int_d(1) and int_d(0));
    int_i(1) <= (int_d(0) and not int_d(1)) or (int_d(1) and not int_d(0));
    int_i(0) <= not int_d(0);

r3 : enARdFF_2
    PORT MAP(
        i_clock => clk,
        i_resetBar => rst,
        i_enable => '1',
        i_d => int_i(3),
		  o_q => int_d(3)
    );

r2 : enARdFF_2
    PORT MAP(
        i_clock => clk,
        i_resetBar => rst,
        i_enable => '1',
        i_d => int_i(2),
		  o_q => int_d(2)
    );

r1 : enARdFF_2
    PORT MAP(
        i_clock => clk,
        i_resetBar => rst,
        i_enable => '1',
        i_d => int_i(1),
		  o_q => int_d(1)
    );

r0 : enARdFF_2
    PORT MAP(
        i_clock => clk,
        i_resetBar => rst,
        i_enable => '1',
        i_d => int_i(0),
		  o_q => int_d(0)
    );

    count <= int_d;

END rtl;
