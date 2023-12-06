LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fourBitComparator IS
    PORT(
        i_A, i_B          : IN    STD_LOGIC_VECTOR(3 DOWNTO 0);
        o_GT, o_LT, o_EQ  : OUT   STD_LOGIC
    );
END fourBitComparator;

ARCHITECTURE structural OF fourBitComparator IS
    SIGNAL GT_Previous, LT_Previous, EQ_Previous : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL GT, LT, EQ : STD_LOGIC;

    COMPONENT oneBitComparator
        PORT(
            i_GTPrevious, i_LTPrevious : IN  STD_LOGIC;
            i_Ai, i_Bi                 : IN  STD_LOGIC;
            o_GT, o_LT                 : OUT STD_LOGIC
        );
    END COMPONENT;

BEGIN
    -- Initialize the first comparison as if there were no previous bits
    GT_Previous(0) <= '0';
    LT_Previous(0) <= '0';
    EQ_Previous(0) <= '1';

    -- Compare bit 3
    b3: oneBitComparator PORT MAP(
        i_GTPrevious => GT_Previous(0),
        i_LTPrevious => LT_Previous(0),
        i_Ai => i_A(3),
        i_Bi => i_B(3),
        o_GT => GT_Previous(1),
        o_LT => LT_Previous(1)
    );

    -- Compare bit 2
    b2: oneBitComparator PORT MAP(
        i_GTPrevious => GT_Previous(1),
        i_LTPrevious => LT_Previous(1),
        i_Ai => i_A(2),
        i_Bi => i_B(2),
        o_GT => GT_Previous(2),
        o_LT => LT_Previous(2)
    );

    -- Compare bit 1
    b1: oneBitComparator PORT MAP(
        i_GTPrevious => GT_Previous(2),
        i_LTPrevious => LT_Previous(2),
        i_Ai => i_A(1),
        i_Bi => i_B(1),
        o_GT => GT_Previous(3),
        o_LT => LT_Previous(3)
    );

    -- Compare bit 0
    b0: oneBitComparator PORT MAP(
        i_GTPrevious => GT_Previous(3),
        i_LTPrevious => LT_Previous(3),
        i_Ai => i_A(0),
        i_Bi => i_B(0),
        o_GT => GT,
        o_LT => LT
    );

    -- Equality logic, which can be deduced by the absence of both greater and lesser indications
    EQ <= NOT GT AND NOT LT;

    -- Final outputs
    o_GT <= GT;
    o_LT <= LT;
    o_EQ <= EQ;

END structural;
