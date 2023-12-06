LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY timer_o IS
	PORT(
		i_input: IN STD_LOGIC_VECTOR(3 downto 0);
		o_MST,o_SST	: OUT	STD_LOGIC);
END ENTITY;

ARCHITECTURE rtl OF timer_o IS

BEGIN

	o_MST<=i_input(1) and i_input(0);
	o_SST<=i_input(1) and i_input(0);

END ARCHITECTURE;
