library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BaudRateGenerator is
    Port ( i_clk : in STD_LOGIC;
           i_reset : in STD_LOGIC;
           i_SEL : in STD_LOGIC_VECTOR (2 downto 0);
           o_BaudRate : out STD_LOGIC);
end BaudRateGenerator;

architecture Behavioral of BaudRateGenerator is
    signal int_divClock : STD_LOGIC := '0';
    signal int_counter : integer range 0 to 40 := 0;
    signal int_flipFlops : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
begin

    -- Clock Divider
    process(i_clk, i_reset)
    begin
        if i_reset = '1' then
            int_counter <= 0;
            int_divClock <= '0';
        elsif rising_edge(i_clk) then
            if int_counter = 40 then
                int_counter <= 0;
                int_divClock <= not int_divClock;
            else
                int_counter <= int_counter + 1;
            end if;
        end if;
    end process;

    -- 8-bit Binary Counter
    process(int_divClock, i_reset)
    begin
        if i_reset = '1' then
            int_flipFlops <= (others => '0');
        elsif rising_edge(int_divClock) then
            int_flipFlops <= std_logic_vector(unsigned(int_flipFlops) + 1);
        end if;
    end process;

    -- Multiplexer
    o_BaudRate <= int_flipFlops(to_integer(unsigned(i_SEL)));

end Behavioral;
