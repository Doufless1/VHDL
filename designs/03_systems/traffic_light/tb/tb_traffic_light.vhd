--------------------------------------------------------------------------------
-- tb_traffic_light : scenario tests + always-on safety and timing monitor
--
-- The monitor process runs during every test case and checks, every cycle:
--   * exactly one car lamp is on
--   * pedestrians see green exactly when cars see red (and red otherwise)
--   * phase order is GREEN -> ORANGE -> RED -> GREEN (never green -> red)
--   * ORANGE lasts exactly ORANGE_CYCLES, RED (walk) exactly WALK_CYCLES,
--     GREEN at least MIN_GREEN_CYCLES
-- The scenarios then only have to steer the controller into interesting
-- situations; any rule violation anywhere fails the test.
-- Phase durations are shortened (cycles instead of seconds) to keep the
-- simulation fast; the RTL logic is identical for the 50 MHz values.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity tb_traffic_light is
  generic (
    runner_cfg       : string;
    MIN_GREEN_CYCLES : positive := 20;
    ORANGE_CYCLES    : positive := 4;
    WALK_CYCLES      : positive := 10
  );
end entity tb_traffic_light;

architecture tb of tb_traffic_light is
  constant CLK_PERIOD  : time     := 20 ns;
  constant FULL_CYCLE  : positive := MIN_GREEN_CYCLES + ORANGE_CYCLES + WALK_CYCLES;

  signal clk            : std_logic := '0';
  signal arst           : std_logic := '1';
  signal pedestrian_btn : std_logic := '0';
  signal car_green, car_orange, car_red, ped_green, ped_red, ped_wait : std_logic;
  signal walk_phases    : natural := 0;     -- completed pedestrian phases
begin

  clk <= not clk after CLK_PERIOD / 2;

  u_dut : entity work.traffic_light_controller
    generic map (
      MIN_GREEN_CYCLES => MIN_GREEN_CYCLES,
      ORANGE_CYCLES    => ORANGE_CYCLES,
      WALK_CYCLES      => WALK_CYCLES
    )
    port map (
      clk => clk, arst => arst, pedestrian_btn => pedestrian_btn,
      car_green => car_green, car_orange => car_orange, car_red => car_red,
      ped_green => ped_green, ped_red => ped_red, ped_wait => ped_wait
    );

  ------------------------------------------------------------------------------
  -- Safety + timing monitor: samples once per cycle (falling edge)
  ------------------------------------------------------------------------------
  monitor : process
    type phase_t is (NONE, GREEN, ORANGE, RED);
    variable phase, last : phase_t  := NONE;
    variable length      : natural  := 0;
  begin
    wait until falling_edge(clk);

    if arst = '1' then
      last   := NONE;
      length := 0;
    else
      -- exactly one car lamp
      check_true((car_green = '1') xor (car_orange = '1') xor (car_red = '1'),
                 "exactly one car lamp must be on");
      check_false(car_green = '1' and car_orange = '1', "green and orange together");
      check_equal(ped_green, car_red, "pedestrians walk only while cars see red");
      check_equal(ped_red, not ped_green, "pedestrian lamps are complementary");

      if car_green = '1' then phase := GREEN;
      elsif car_orange = '1' then phase := ORANGE;
      else phase := RED;
      end if;

      if phase = last then
        length := length + 1;
      else
        -- a phase just ended: check the transition and how long it lasted
        case last is
          when GREEN =>
            check(phase = ORANGE, "green must be followed by orange");
            check(length >= MIN_GREEN_CYCLES,
                  "green lasted " & to_string(length) & " cycles, minimum is " &
                  to_string(MIN_GREEN_CYCLES));
          when ORANGE =>
            check(phase = RED, "orange must be followed by red");
            check_equal(length, ORANGE_CYCLES, "orange duration");
          when RED =>
            check(phase = GREEN, "red must be followed by green");
            check_equal(length, WALK_CYCLES, "walk duration");
            walk_phases <= walk_phases + 1;
          when NONE =>
            null;                            -- first sample after reset
        end case;
        last   := phase;
        length := 1;
      end if;
    end if;
  end process monitor;

  ------------------------------------------------------------------------------
  -- Scenarios
  ------------------------------------------------------------------------------
  main : process
    -- reset released right after a rising edge, so phase lengths count exactly
    procedure reset_controller is
    begin
      arst           <= '1';
      pedestrian_btn <= '0';
      wait for 3 * CLK_PERIOD;
      wait until rising_edge(clk);
      arst <= '0';
    end procedure;

    procedure run_cycles (n : natural) is
    begin
      for i in 1 to n loop
        wait until rising_edge(clk);
      end loop;
    end procedure;

    -- one press covering exactly one rising edge (shortest press that counts)
    procedure press_button (cycles : positive := 1) is
    begin
      wait until falling_edge(clk);
      pedestrian_btn <= '1';
      run_cycles(cycles);
      wait until falling_edge(clk);
      pedestrian_btn <= '0';
    end procedure;

    procedure wait_until_high (signal s : std_logic; max_cycles : natural; what : string) is
    begin
      for i in 0 to max_cycles loop
        if s = '1' then
          return;
        end if;
        wait until rising_edge(clk);
        wait for 1 ns;
      end loop;
      check_failed(what & " did not happen within " & to_string(max_cycles) & " cycles");
    end procedure;

    variable phases_before : natural;
  begin
    test_runner_setup(runner, runner_cfg);

    while test_suite loop
      reset_controller;
      phases_before := walk_phases;

      if run("no_request_keeps_cars_green") then
        for i in 1 to 5 * FULL_CYCLE loop
          wait until falling_edge(clk);
          check_equal(car_green, '1', "cars must keep green without a request");
          check_equal(ped_wait, '0', "no request pending");
        end loop;

      elsif run("short_press_is_served") then
        press_button(1);
        wait_until_high(ped_wait, 4, "WAIT lamp");
        wait_until_high(car_orange, MIN_GREEN_CYCLES + 4, "orange phase");
        wait_until_high(ped_green, ORANGE_CYCLES + 1, "walk phase");
        wait_until_high(car_green, WALK_CYCLES + 1, "return to green");
        check_equal(ped_wait, '0', "request cleared once served");
        run_cycles(2);
        check_equal(walk_phases, phases_before + 1, "exactly one walk phase");

      elsif run("late_press_switches_after_sync_delay") then
        run_cycles(3 * MIN_GREEN_CYCLES);      -- minimum green long expired
        press_button(1);
        -- 2 synchronizer flops + request flop + state flop
        wait_until_high(car_orange, 4, "orange right after a late press");

      elsif run("press_during_walk_is_ignored") then
        press_button(1);
        wait_until_high(ped_green, MIN_GREEN_CYCLES + ORANGE_CYCLES + 5, "walk phase");
        press_button(3);                       -- pressed while already walking
        wait_until_high(car_green, WALK_CYCLES + 1, "return to green");
        for i in 1 to 3 * FULL_CYCLE loop
          wait until falling_edge(clk);
          check_equal(car_green, '1', "a press during walk must not queue another cycle");
        end loop;
        check_equal(walk_phases, phases_before + 1, "exactly one walk phase");

      elsif run("bouncing_button_gives_one_walk_phase") then
        for bounce in 1 to 8 loop              -- contact bounce: on/off chatter
          pedestrian_btn <= '1';
          run_cycles(1 + bounce mod 3);
          pedestrian_btn <= '0';
          run_cycles(1 + bounce mod 2);
        end loop;
        run_cycles(3 * FULL_CYCLE);
        check_equal(walk_phases, phases_before + 1, "bounces must give one walk phase");

      elsif run("reset_during_walk_returns_to_green") then
        press_button(1);
        wait_until_high(ped_green, MIN_GREEN_CYCLES + ORANGE_CYCLES + 5, "walk phase");
        wait until falling_edge(clk);
        arst <= '1';                           -- asynchronous: no clock needed
        wait for 1 ns;
        check_equal(car_green, '1', "reset forces cars green");
        check_equal(ped_green, '0', "reset forces pedestrians red");
      end if;
    end loop;

    test_runner_cleanup(runner);
  end process main;

end architecture tb;
