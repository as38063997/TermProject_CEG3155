LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fsm IS
	PORT(
		i_resetBar  	: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
        i_SSCS,i_MSC,i_MST,i_SSC,i_SST: IN STD_LOGIC;
		o_MSTL,o_SSTL			: OUT	STD_LOGIC_VECTOR(2 downto 0);
		o_set			: OUT	STD_LOGIC_VECTOR(3 downto 0);
		o_state			: OUT   STD_LOGIC_VECTOR(1 downto 0);
        o_reset,o_sw : OUT STD_LOGIC);
END ENTITY;

ARCHITECTURE rtl of fsm IS
    SIGNAL int_D,int_C,int_B,int_A: STD_LOGIC;
    SIGNAL int_Dn,int_Cn,int_Bn,int_An: STD_LOGIC;

    COMPONENT enARdFF_2 IS
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

BEGIN

    int_An<=(int_D and i_SST)or(int_A and i_SSCS and not i_MSC)or(int_A and not i_SSCS and i_MSC)or(int_A and not i_SSCS and not i_MSC);
    int_Bn<=(int_B and not i_MST)or(int_A and i_SSCS and i_MSC);
    int_Cn<=(int_B and i_MST)or(int_C and not i_SSC);
    int_Dn<=(int_C and i_SSC)or(int_D and not i_SST);

reg_A: enARdFF_2_rr
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => int_An, 
			  i_enable => '1',
			  i_clock => i_clock,
			  o_q => int_A);

reg_B: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => int_Bn, 
			  i_enable => '1',
			  i_clock => i_clock,
			  o_q => int_B);

reg_C: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => int_Cn, 
			  i_enable => '1',
			  i_clock => i_clock,
			  o_q => int_C);

reg_D: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => int_Dn, 
			  i_enable => '1',
			  i_clock => i_clock,
			  o_q => int_D);

    o_MSTL(2)<= int_C or int_D;
    o_MSTL(1)<= int_B;
    o_MSTL(0)<= int_A;

    o_SSTL(2)<= int_A or int_B;
    o_SSTL(1)<= int_D;
    o_SSTL(0)<= int_C;

    o_reset<= (int_A xor int_An) or (int_B xor int_Bn) or (int_C xor int_Cn) or (int_D xor int_Dn);
	 --o_reset<='1';
	 o_sw<= int_C or int_D;
	 
	 o_set(3)<='0';
	 o_set(2)<='0';
	 o_set(1)<=int_B xor int_Bn;
	 o_set(0)<=int_D xor int_Dn;

	o_state(1) <= int_C or int_D;
	o_state(0) <= int_B or int_D;

END ARCHITECTURE;
