--------------------------------------------------------------------------------
-- traffic_light_controller : pedestrian-crossing controller (timed Moore FSM)
--
--              request & min. green elapsed           ORANGE_CYCLES
--   CARS_GREEN ------------------------------> CARS_ORANGE ----------> CARS_RED
--       ^                                                                 |
--       +------------------------- WALK_CYCLES ---------------------------+
--
--   CARS_GREEN  cars drive, pedestrians wait. Left only when a pedestrian
--               request is pending AND cars have had MIN_GREEN_CYCLES.
--   CARS_ORANGE fixed amber time.
--   CARS_RED    cars stop, pedestrians walk for WALK_CYCLES.
--
-- The push button is asynchronous to clk: it goes through a synchronizer and
-- sets a request latch, so a press shorter than a clock period is never lost
-- and contact bounce only re-sets an already-set latch (no debouncer needed).
-- Presses during ORANGE/RED are ignored: pedestrians are already being served.
--
-- Safety properties (testbench monitor + formal proof in formal/):
--   * ped_green = '1' only while car_red = '1'
--   * cars never go from green to red without the orange phase
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity traffic_light_controller is
  generic (
    -- phase durations in clock cycles (defaults: 50 MHz board clock)
    MIN_GREEN_CYCLES : positive := 250_000_000;   -- 5 s
    ORANGE_CYCLES    : positive := 150_000_000;   -- 3 s
    WALK_CYCLES      : positive := 400_000_000    -- 8 s
  );
  port (
    clk            : in  std_logic;
    arst           : in  std_logic;   -- async reset, active high
    pedestrian_btn : in  std_logic;   -- asynchronous push button, active high
    car_green      : out std_logic;
    car_orange     : out std_logic;
    car_red        : out std_logic;
    ped_green      : out std_logic;
    ped_red        : out std_logic;
    ped_wait       : out std_logic    -- "WAIT" lamp: request registered
  );
end entity traffic_light_controller;

architecture rtl of traffic_light_controller is

  function max3(a, b, c : positive) return positive is
    variable m : positive := a;
  begin
    if b > m then m := b; end if;
    if c > m then m := c; end if;
    return m;
  end function max3;

  constant TIMER_MAX : natural := max3(MIN_GREEN_CYCLES, ORANGE_CYCLES, WALK_CYCLES) - 1;

  type state_t is (CARS_GREEN, CARS_ORANGE, CARS_RED);
  signal state : state_t;

  -- one down-counter times every phase: loaded with (duration - 1) on entry,
  -- the phase ends on the clock edge where it reads zero
  signal timer    : natural range 0 to TIMER_MAX;
  signal btn_sync : std_logic;
  signal request  : std_logic;

begin

  u_btn_sync : entity work.sync_2ff
    port map (
      clk      => clk,
      async_in => pedestrian_btn,
      sync_out => btn_sync
    );

  fsm : process (clk, arst)
  begin
    if arst = '1' then
      state   <= CARS_GREEN;
      timer   <= MIN_GREEN_CYCLES - 1;
      request <= '0';
    elsif rising_edge(clk) then
      if timer /= 0 then
        timer <= timer - 1;
      end if;

      case state is
        when CARS_GREEN =>
          if btn_sync = '1' then
            request <= '1';
          end if;
          if request = '1' and timer = 0 then
            state   <= CARS_ORANGE;
            timer   <= ORANGE_CYCLES - 1;
            request <= '0';
          end if;

        when CARS_ORANGE =>
          if timer = 0 then
            state <= CARS_RED;
            timer <= WALK_CYCLES - 1;
          end if;

        when CARS_RED =>
          if timer = 0 then
            state <= CARS_GREEN;
            timer <= MIN_GREEN_CYCLES - 1;
          end if;
      end case;
    end if;
  end process fsm;

  -- Moore outputs: decoded from the state register only
  car_green  <= '1' when state = CARS_GREEN  else '0';
  car_orange <= '1' when state = CARS_ORANGE else '0';
  car_red    <= '1' when state = CARS_RED    else '0';
  ped_green  <= '1' when state = CARS_RED    else '0';
  ped_red    <= '0' when state = CARS_RED    else '1';
  ped_wait   <= request;

end architecture rtl;
