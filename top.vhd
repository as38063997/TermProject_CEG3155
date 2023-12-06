LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY top IS
	PORT(
		i_clk,i_resetbar,i_pbs: IN STD_LOGIC;
        i_sw1,i_sw2:IN STD_LOGIC_VECTOR(3 downto 0);
		o_MST,o_SST: OUT	STD_LOGIC_VECTOR(2 downto 0);
		o_timer_out: OUT	STD_LOGIC_VECTOR(3 downto 0);
		o_state			: OUT   STD_LOGIC_VECTOR(1 downto 0);
		o_clk			: OUT   STD_LOGIC
		);
END ENTITY;

ARCHITECTURE rtl OF top IS

    SIGNAL int_clk,int_MST,int_SST,int_Debouncer,int_SetCounter,int_CounterExpired,int_S: STD_LOGIC;
    SIGNAL int_timer_out, int_count_out,int_mux_out,int_set: STD_LOGIC_VECTOR(3 downto 0);

COMPONENT fsm IS
	PORT(
		i_resetBar  	: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
      i_SSCS,i_MSC,i_MST,i_SSC,i_SST: IN STD_LOGIC;
		o_MSTL,o_SSTL			: OUT	STD_LOGIC_VECTOR(2 downto 0);
        o_reset,o_sw : OUT STD_LOGIC;
		  o_state			: OUT   STD_LOGIC_VECTOR(1 downto 0)
		  );
END COMPONENT;

COMPONENT debouncer_2 IS
	PORT(
		i_resetBar		: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_raw			: IN	STD_LOGIC;
		o_clean			: OUT	STD_LOGIC);
END COMPONENT;

COMPONENT clk_div IS
	PORT
	(
		clock_25Mhz				: IN	STD_LOGIC;
		clock_1MHz				: OUT	STD_LOGIC;
		clock_100KHz				: OUT	STD_LOGIC;
		clock_10KHz				: OUT	STD_LOGIC;
		clock_1KHz				: OUT	STD_LOGIC;
		clock_100Hz				: OUT	STD_LOGIC;
		clock_10Hz				: OUT	STD_LOGIC;
		clock_1Hz				: OUT	STD_LOGIC);
END COMPONENT;

COMPONENT counter_4bit IS
    PORT(
        clk : IN std_logic;
        rst : IN std_logic;
        count : OUT std_logic_vector(3 DOWNTO 0)
    );
END COMPONENT;

COMPONENT fourBitComparator IS
    PORT(
        i_A, i_B          : IN    STD_LOGIC_VECTOR(3 DOWNTO 0);
        o_GT, o_LT, o_EQ  : OUT   STD_LOGIC
    );
END COMPONENT;

COMPONENT mux2to1_4 IS
    PORT(
        i_S:IN STD_LOGIC;
        i_a,i_b:IN STD_LOGIC_VECTOR(3 downto 0);
        o_O:OUT STD_LOGIC_VECTOR(3 downto 0));
END COMPONENT;

COMPONENT timer_o IS
	PORT(
		i_input: IN STD_LOGIC_VECTOR(3 downto 0);
		o_MST,o_SST	: OUT	STD_LOGIC);
END COMPONENT;

BEGIN

	--change clock speed here
	int_clk<=i_clk;

clock_divider: clk_div
    PORT MAP(
        clock_25Mhz=> i_clk
        --clock_1Hz=>int_clk
    );

Timer_m: counter_4bit
    PORT MAP(
        clk=> int_clk,
        rst=> i_resetBar,
        count=> int_timer_out
    );

Timer_out: timer_o
    PORT MAP(
		i_input=> int_timer_out,
		o_MST => int_MST,
        o_SST => int_SST
    );

debouncer: debouncer_2
    PORT MAP(
        i_resetBar=>i_resetBar,
		i_clock	=> int_clk,
		i_raw=> i_pbs,
		o_clean=> int_Debouncer
    );

fsm_controller: fsm
    PORT MAP(
        i_resetBar  => i_resetBar,	
		i_clock	 => int_clk,	
        i_SSCS  => int_Debouncer,
        i_MSC => int_CounterExpired,
        i_MST => int_MST,
        i_SSC => int_CounterExpired,
        i_SST => int_SST,
        o_sw => int_S,
		o_MSTL => o_MST,
        o_SSTL => o_SST,
        o_reset => int_SetCounter
    );

cmp: fourBitComparator
    PORT MAP(
        i_A => int_count_out,
        i_B => int_mux_out,
        o_EQ => int_CounterExpired
    );

counter: counter_4bit
    PORT MAP(
        clk =>int_clk,
        rst=> i_resetBar,
        count =>int_count_out
    );

mux: mux2to1_4
    PORT MAP(
        i_S=>int_S,
        i_a=>i_sw1,
        i_b=>i_sw2,
        o_O=>int_mux_out
    );
	 
	 o_clk <= int_clk;

END ARCHITECTURE;
