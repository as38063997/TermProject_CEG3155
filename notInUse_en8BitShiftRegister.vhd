LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY en8BitShiftRegister IS
    PORT(
        i_resetBar   : IN  STD_LOGIC;
        i_data       : IN  STD_LOGIC;
        i_enable     : IN  STD_LOGIC;
        i_clock      : IN  STD_LOGIC;
        o_serial_out : OUT STD_LOGIC
    );
END en8BitShiftRegister;

ARCHITECTURE structural OF en8BitShiftRegister IS
    COMPONENT enARdFF_2
        PORT(
            i_resetBar : IN  STD_LOGIC;
            i_d        : IN  STD_LOGIC;
            i_enable   : IN  STD_LOGIC;
            i_clock    : IN  STD_LOGIC;
            o_q, o_qBar : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL int_ff : ARRAY(0 TO 7) OF STD_LOGIC;

BEGIN
    -- First flip-flop
    FF0: enARdFF_2 PORT MAP(
        i_resetBar => i_resetBar,
        i_d        => i_data,
        i_enable   => i_enable,
        i_clock    => i_clock,
        o_q        => int_ff(0),
        o_qBar     => OPEN
    );

    -- Remaining flip-flops
    FF_GEN: FOR i IN 1 TO 7 GENERATE
        FF: enARdFF_2 PORT MAP(
            i_resetBar => i_resetBar,
            i_d        => int_ff(i - 1),
            i_enable   => i_enable,
            i_clock    => i_clock,
            o_q        => int_ff(i),
            o_qBar     => OPEN
        );
    END GENERATE FF_GEN;

    -- Output of the shift register
    o_serial_out <= int_ff(7);

END structural;
