LIBRARY IEEE;
USE ieee.std_logic_161164.all;

---------------------------------
-- TOP LEVEL MODULE
---------------------------------
ENTITY 7seg_counter IS
    PORT(clock_50       :IN std_logic;
         seg_disp       :OUT std_logic_vector(6 DOWNTO 0));
END ENTITY;

ARCHITECTURE behaviour OF 7seg_counter IS

COMPONENT down_counter
    PORT(clock_50       :IN std_logic;
         trigger        :OUT std_logic);
END COMPONENT;

COMPONENT slow_counter IS
    PORT(clock_50       :IN std_logic;
         enable         :IN std_logic;  
         7seg           :OUT std_logic_vector(6 DOWNTO 0));
END COMPONENT;

SIGNAL trg_evt std_logic;

BEGIN

    down:down_counter
    PORT MAP (clock_50 => clock_50, trigger => trg_evt);
    
    slow:slow_counter
    PORT MAP (clock_50 => clock_50, trg_evt => enable, 7seg => seg_disp);
    
END behaviour;


---------------------------------
-- DOWN COUNTER
---------------------------------
ENTITY down_counter IS
    PORT(clock_50       :IN std_logic;
         trigger        :OUT std_logic);
END ENTITY;

ARCHITECTURE behaviour OF down_counter IS
    SIGNAL count:std_logic_vector(31 DOWNTO 0):="0x02FAF080";
    
BEGIN
    PROCESS(clock_50)
    BEGIN    
        
    -- Reload at 0
    IF (count = "0x00000000") THEN
        count <= "0x02FAF080";
    END IF;
    
    -- Decrement on Rising Edges
    IF (clock_50='1') THEN
        count <= count - "0x00000001";
    END IF;
    END PROCESS;
    
    -- Trigger on 0
    trigger <= nor count;
    
END behaviour;


---------------------------------
-- SLOW COUNTER & DISPLAY DRIVER
---------------------------------
ENTITY slow_counter IS
    PORT(clock_50       :IN std_logic;
         enable         :IN std_logic;  
         7seg           :OUT std_logic_vector(6 DOWNTO 0));
END ENTITY;


ARCHITECTURE behaviour OF slow_counter IS
    SIGNAL disp_val :std_logic_vector(3 DOWNTO 0):="0000";
    SIGNAL inc      :std_logic;
    
BEGIN

    PROCESS(clock_50)
    BEGIN
    -- Gate Clock & Increment
    IF((clock_50 and enable) = '1') THEN
        disp_val <= disp_val + "0001";
        
        -- Handle Overflow
        IF(disp_val = "1010") THEN
            disp_val <= "0000"
        END IF;
    END IF;
    END PROCESS;
    
    7seg <= "0000001" WHEN (disp_val = "0000") ELSE
            "1001111" WHEN (disp_val = "0001") ELSE
            "0010010" WHEN (disp_val = "0010") ELSE
            "0000110" WHEN (disp_val = "0011") ELSE
            "1001100" WHEN (disp_val = "0100") ELSE
            "0100100" WHEN (disp_val = "0101") ELSE
            "1100000" WHEN (disp_val = "0110") ELSE
            "0001111" WHEN (disp_val = "0111") ELSE
            "0000000" WHEN (disp_val = "1000") ELSE
            "0001100" WHEN (disp_val = "1001") ELSE
            "1111111";

END behaviour;

