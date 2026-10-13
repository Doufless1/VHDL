-- 11. Traffic Light Controller for Pedestrian Crossing
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY traffic_light_controller IS
    PORT(
        clk, reset     : IN STD_LOGIC;
        pedestrian_btn : IN STD_LOGIC;
        car_green, car_orange, car_red : OUT STD_LOGIC;
        ped_red, ped_green : OUT STD_LOGIC
    );
END traffic_light_controller;

ARCHITECTURE behavior OF traffic_light_controller IS
    TYPE STATE_TYPE IS (cars_green, cars_orange, cars_red);
    SIGNAL state : STATE_TYPE;
BEGIN
    PROCESS(clk, reset)
    BEGIN
        IF reset = '1' THEN
            state <= cars_green;
        ELSIF rising_edge(clk) THEN
            CASE state IS
                WHEN cars_green =>
                    IF pedestrian_btn = '1' THEN
                        state <= cars_orange;
                    END IF;
                WHEN cars_orange =>
                    state <= cars_red;
                WHEN cars_red =>
                    state <= cars_green;
                WHEN OTHERS =>
                    state <= cars_green;
            END CASE;
        END IF;
    END PROCESS;

    -- Outputs
    WITH state SELECT
        car_green  <= '1' WHEN cars_green,
                      '0' WHEN OTHERS;

    WITH state SELECT
        car_orange <= '1' WHEN cars_orange,
                      '0' WHEN OTHERS;

    WITH state SELECT
        car_red    <= '1' WHEN cars_red,
                      '0' WHEN OTHERS;

    WITH state SELECT
        ped_green  <= '1' WHEN cars_red,
                      '0' WHEN OTHERS;

    WITH state SELECT
        ped_red    <= '0' WHEN cars_red,
                      '1' WHEN OTHERS;
END behavior;