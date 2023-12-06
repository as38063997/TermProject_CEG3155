LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY UART IS
    PORT(
        i_resetBar, i_clk:IN	STD_LOGIC;
        i_A:IN STD_LOGIC_VECTOR(1 downto 0);
        i_R,i_TR,i_TS:IN STD_LOGIC;
        i_databus:IN STD_LOGIC_VECTOR(7 downto 0);
        o_databus:OUT STD_LOGIC_VECTOR(7 downto 0);
        o_TxD: OUT STD_LOGIC;
		  o_TSR:OUT STD_LOGIC_VECTOR(8 downto 0);
		  o_TDR:OUT STD_LOGIC_VECTOR(7 downto 0);
		  o_SCSR:OUT STD_LOGIC_VECTOR(7 downto 0);
		  d_s:OUT std_logic_vector(2 downto 0);
		  o_s1,o_s0:OUT STD_LOGIC;
		  di_SCSRLoad:IN STD_LOGIC;
		  d_cnta:OUT std_logic_vector(3 downto 0)
    );
END ENTITY;

ARCHITECTURE rtl of UART IS

    SIGNAL int_databus,int_SCSR,int_SCCR,int_mux4,int_TDR: STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL int_TS,int_s0,int_s1,int_loadSCCR,int_loadTDR,i_clock,int_SCSRLoad: STD_LOGIC;

COMPONENT mux4to1_8 IS
    PORT(
        i_S:IN STD_LOGIC_VECTOR(1 downto 0);
        i_I3,i_I2,i_I1,i_I0:IN STD_LOGIC_VECTOR(7 downto 0);
        o_O:OUT STD_LOGIC_VECTOR(7 downto 0));
END COMPONENT;

COMPONENT mux2to1_8 IS
    PORT(
        i_S:IN STD_LOGIC;
        i_a,i_b:IN STD_LOGIC_VECTOR(7 downto 0);
        o_O:OUT STD_LOGIC_VECTOR(7 downto 0));
END COMPONENT;

COMPONENT SCSR IS
    PORT(
        i_resetBar, i_load,i_TR,i_TS: IN STD_LOGIC;
        i_clock: IN STD_LOGIC;
        i_Value: IN STD_LOGIC_VECTOR(7 downto 0);
        o_Value: OUT STD_LOGIC_VECTOR(7 downto 0));
END COMPONENT;

COMPONENT SCCR IS
    PORT(
        i_resetBar, i_load: IN STD_LOGIC;
        i_clock: IN STD_LOGIC;
        i_Value: IN STD_LOGIC_VECTOR(7 downto 0);
        o_Sel:   OUT STD_LOGIC_VECTOR(2 downto 0);
        o_Value: OUT STD_LOGIC_VECTOR(7 downto 0));
END COMPONENT;

COMPONENT BaudRateGenerator is
    Port ( i_clk : in STD_LOGIC;
           i_reset : in STD_LOGIC;
           i_SEL : in STD_LOGIC_VECTOR (2 downto 0);
           o_BaudRate : out STD_LOGIC);
end COMPONENT;

COMPONENT TDR IS
    PORT(
        i_resetBar, i_load: IN STD_LOGIC;
        i_clock: IN STD_LOGIC;
        i_Value: IN STD_LOGIC_VECTOR(7 downto 0);
        o_Value: OUT STD_LOGIC_VECTOR(7 downto 0));
END COMPONENT;

COMPONENT TSR IS
    PORT(
        i_S0, i_S1 : IN STD_LOGIC;
        CLK : IN STD_LOGIC;
        RST : IN STD_LOGIC;
        i_I : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
        o_O : OUT STD_LOGIC;
		  o_PO: OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
    );
END COMPONENT;

COMPONENT tsrControl IS
    PORT(
        clk : IN std_logic;
        reset : IN std_logic;
        TDRE : IN std_logic;
        TDRE_set: OUT std_logic;
		  d_s:OUT std_logic_vector(2 downto 0);
        i_s0,i_s1: OUT std_logic
    );
END COMPONENT;

BEGIN

int_loadTDR<= not i_A(0) and not i_A(1)and not i_R;

int_SCSRLoad<=di_SCSRLoad;

--start of address decorder
mux_2: mux2to1_8
    PORT MAP(
        i_S => i_R,
        i_a => i_databus,
        i_b => int_mux4,
        o_O => int_databus);

mux_4: mux4to1_8
    PORT MAP(
        i_S => i_A,
        i_I3 => int_SCCR,
        i_I2 => int_SCCR,
        i_I1 => int_SCSR,
        i_I0 => "00000000",--no RDR, 0 as default
        o_O => int_mux4);
--end of address decorder

c_SCSR: SCSR
    PORT MAP(i_resetBar => i_resetBar,
            i_load => int_TS,
            i_TR => i_TR,
            i_TS => int_TS or i_TS,
            i_clock => i_clk,
            i_Value => int_databus,
            o_Value => int_SCSR);

c_SCCR: SCCR
    PORT MAP(i_resetBar => i_resetBar,
            i_load => int_loadSCCR,
            i_clock => i_clk,
            i_Value => int_databus,
            o_Value => int_SCCR);

c_TDR: TDR
    PORT MAP(i_resetBar => i_resetBar,
            i_load => int_loadTDR,
            i_clock => i_clock,
            i_Value => int_databus,
            o_Value => int_TDR);

c_TSR: TSR
    PORT MAP(
        i_S0 => int_s0,
        i_S1 => int_s1,
        CLK => i_clock,
        RST => i_resetBar,
        i_I => int_TDR & '0',
        o_O => o_TxD,
		  o_PO => o_TSR
    );

c_tsrControl: tsrControl
    PORT MAP(
        clk => i_clock,
        reset => i_resetBar,
        TDRE => int_SCSR(7),
        TDRE_set => int_TS,
		  d_s=>d_s,
        i_s0 => int_s0,
        i_s1 => int_s1
    );

c_BRG: BaudRateGenerator
    Port Map ( i_clk => i_clk,
               i_reset => not i_resetBar,
					o_BaudRate => i_clock,
               i_SEL => int_SCCR(2 downto 0)
					);

					
	--i_clock<=i_clk;
					
    o_databus <= int_databus;
	 o_TDR<= int_TDR;
	 o_SCSR<=int_SCSR;
	 o_s1<=int_s1;
	 o_s0<=int_s0;

END ARCHITECTURE;