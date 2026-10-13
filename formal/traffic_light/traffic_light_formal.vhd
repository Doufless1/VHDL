--------------------------------------------------------------------------------
-- traffic_light_formal : formal-verification harness for the traffic light
--
-- Wraps the unmodified RTL (with short phase durations) and states its
-- requirements as PSL properties. yosys-smtbmc + Z3 then prove them for
-- every possible input sequence, not just the ones a testbench happens to
-- try:
--   base case  bounded model check from power-up for DEPTH cycles
--   induction  no state at all - reachable or not - can step from
--              "all properties held for DEPTH cycles" to a violation
-- Both passing means the properties hold forever. Run: make formal
--
-- The reset button (arst) and the pedestrian button are left completely free:
-- the solver may press them in any cycle.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity traffic_light_formal is
  port (
    clk            : in std_logic;
    arst           : in std_logic;
    pedestrian_btn : in std_logic
  );
end entity traffic_light_formal;

architecture formal of traffic_light_formal is
  constant MIN_GREEN : positive := 4;
  constant ORANGE    : positive := 2;
  constant WALK      : positive := 3;
  -- WAIT lamp -> walk: rest of the minimum green, then orange. The bound is
  -- tight: with RESPONSE_BOUND - 1 the solver finds a violating trace (a
  -- press latched one cycle into a fresh green phase).
  constant RESPONSE_BOUND : positive := MIN_GREEN + ORANGE - 1;

  signal car_green, car_orange, car_red, ped_green, ped_red, ped_wait : std_logic;

  -- auxiliary logic for the bounded-response property
  signal pending : std_logic := '0';                   -- WAIT lamp seen, not served yet
  signal waited  : natural range 0 to RESPONSE_BOUND + 1 := 0;
begin

  u_dut : entity work.traffic_light_controller
    generic map (
      MIN_GREEN_CYCLES => MIN_GREEN,
      ORANGE_CYCLES    => ORANGE,
      WALK_CYCLES      => WALK
    )
    port map (
      clk => clk, arst => arst, pedestrian_btn => pedestrian_btn,
      car_green => car_green, car_orange => car_orange, car_red => car_red,
      ped_green => ped_green, ped_red => ped_red, ped_wait => ped_wait
    );

  process (clk)
  begin
    if rising_edge(clk) then
      if arst = '1' or ped_green = '1' then
        pending <= '0';
        waited  <= 0;
      elsif ped_wait = '1' or pending = '1' then
        pending <= '1';
        -- restart the count at the start of every wait, so no stale value
        -- can survive (induction may start in any state, also of this logic)
        if pending = '0' then
          waited <= 1;
        elsif waited <= RESPONSE_BOUND then
          waited <= waited + 1;
        end if;
      end if;
    end if;
  end process;

  default clock is rising_edge(clk);

  ---------------------------------------------------------------- safety
  -- pedestrians only walk while every car lamp shows red
  walk_only_when_cars_stopped : assert always
    (ped_green -> (car_red and not car_green and not car_orange));

  -- exactly one car lamp is lit, in every cycle
  one_car_lamp : assert always
    ((car_green  and not car_orange and not car_red) or
     (car_orange and not car_green  and not car_red) or
     (car_red    and not car_green  and not car_orange));

  ped_lamps_complementary : assert always (ped_red = not ped_green);

  -- phase order: green -> orange -> red -> green (unless reset intervenes)
  no_green_to_red  : assert always ((car_green  and not arst) -> next (car_green  or car_orange or arst));
  orange_then_red  : assert always ((car_orange and not arst) -> next (car_orange or car_red    or arst));
  red_then_green   : assert always ((car_red    and not arst) -> next (car_red    or car_green  or arst));

  ---------------------------------------------------------------- timing
  -- orange lasts exactly ORANGE = 2 cycles, walk exactly WALK = 3 cycles
  orange_duration : assert always
    ({not car_orange; car_orange} |=> {car_orange; not car_orange}) abort arst;
  walk_duration : assert always
    ({not ped_green; ped_green} |=> {ped_green; ped_green; not ped_green}) abort arst;

  -------------------------------------------------------------- liveness
  -- every accepted request is served within RESPONSE_BOUND cycles
  request_served_in_time : assert always (waited <= RESPONSE_BOUND);

end architecture formal;
