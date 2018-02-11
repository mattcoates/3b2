LIBRARY IEEE;
USE ieee.std_logic_1164.all;

ENTITY tlc_timer IS
PORT ( CLOCK_50:    IN std_logic;
       KEY:         IN std_logic_vector(1 DOWNTO 0);
       LEDS:        OUT std_logic_vector(5 DOWNTO 0);
       HEX0, HEX1:  OUT STD_LOGIC_VECTOR(0 TO 6); 
       
       -- Use a 96 bit parallel bus for simplicity
       STATS        OUT STD_LOGIC_VECTOR(95 DOWNTO 0));
END ENTITY;

ARCHITECTURE behaviour OF tlc_timer IS

COMPONENT FSM
PORT (clock, reset: IN STD_LOGIC;
      request: IN STD_LOGIC;
      timer1, timer0: IN STD_LOGIC_VECTOR(3 DOWNTO 0) ;   
      req_status: OUT STD_LOGIC;
      state_event: OUT STD_LOGIC;
      state_time: OUT STD_LOGIC_VECTOR(7 DOWNTO 0); 
      state: OUT STD_LOGIC_VECTOR(1 DOWNTO 0) );
END COMPONENT;

COMPONENT counter IS
GENERIC ( n : NATURAL := 4; k : INTEGER := 16 );  
PORT (clock, reset: IN  STD_LOGIC;
      enable, load: IN  STD_LOGIC;
      start_time: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      count: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      rollover: OUT STD_LOGIC );
END COMPONENT;
 
COMPONENT bcd7seg
PORT ( BCD: IN STD_LOGIC_VECTOR(3 DOWNTO 0) ;
       state: IN STD_LOGIC_VECTOR(1 DOWNTO 0) ;
       HEX: OUT STD_LOGIC_VECTOR(0 TO 6) ) ;        
END COMPONENT ;

COMPONENT light
PORT (status: IN STD_LOGIC_VECTOR(1 DOWNTO 0) ;
      state: IN STD_LOGIC_VECTOR(1 DOWNTO 0) ;
      LED: OUT STD_LOGIC_VECTOR(5 DOWNTO 0) ) ;   
END COMPONENT 


-- Only the current state and the request signal are 
-- required to distinguish raw/stored/executed events
COMPONENT stats
PORT (request:  IN STD_LOGIC;
      state:    IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      num_req:  OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ex_req:   OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      std_req:  OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END COMPONENT

SIGNAL one_second: STD_LOGIC ;
SIGNAL state_event: STD_LOGIC ;
SIGNAL request_status: STD_LOGIC ;
SIGNAL state: STD_LOGIC_VECTOR(1 DOWNTO 0) ;
SIGNAL state_time: STD_LOGIC_VECTOR(7 DOWNTO 0) ;
SIGNAL BCD1, BCD0 : STD_LOGIC_VECTOR(3 DOWNTO 0) ;
SIGNAL roll: STD_LOGIC_VECTOR(1 DOWNTO 0) ; 


BEGIN

    stats:statistics
    PORT MAP(request => request, state => state, num_req => STATS(31 DOWNTO 0), 
             ex_req => STATS(63 DOWNTO 32), std_req => STATS(95 DOWNTO 64));

    ...

END behaviour;
