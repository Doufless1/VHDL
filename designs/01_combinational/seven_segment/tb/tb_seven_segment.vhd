--------------------------------------------------------------------------------
-- tb_seven_segment : self-checking tests for seven_segment_decoder,
-- even_parity and parity_display_top
--
-- The expected segment patterns are written as an independent, readable spec
-- (the segments that are lit, e.g. "-bc----" for 1) instead of copying the
-- RTL's bit table. The decoder output is also rendered as ASCII art in the
-- simulation log, so a wrong segment is visible at a glance.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity tb_seven_segment is
  generic (
    runner_cfg : string
  );
end entity tb_seven_segment;

architecture tb of tb_seven_segment is

  -- lit segments per digit, in the order a b c d e f g ('-' = off)
  type spec_t is array (0 to 15) of string(1 to 7);
  constant SPEC : spec_t := (
    "abcdef-", "-bc----", "ab-de-g", "abcd--g",    -- 0 1 2 3
    "-bc--fg", "a-cd-fg", "a-cdefg", "abc----",    -- 4 5 6 7
    "abcdefg", "abcd-fg", "abc-efg", "--cdefg",    -- 8 9 A b
    "a--def-", "-bcde-g", "a--defg", "a---efg");   -- C d E F

  -- spec string -> active-high pattern, bit 6 = a ... bit 0 = g
  function pattern (digit : natural) return std_logic_vector is
    variable p : std_logic_vector(6 downto 0);
  begin
    for i in 1 to 7 loop
      if SPEC(digit)(i) = '-' then p(7 - i) := '0'; else p(7 - i) := '1'; end if;
    end loop;
    return p;
  end function;

  function ones (v : std_logic_vector) return natural is
    variable n : natural := 0;
  begin
    for i in v'range loop
      if v(i) = '1' then n := n + 1; end if;
    end loop;
    return n;
  end function;

  signal hex                : std_logic_vector(3 downto 0) := (others => '0');
  signal seg_high, seg_low  : std_logic_vector(6 downto 0);
  signal parity             : std_logic;
  signal show_parity        : std_logic := '0';
  signal top_seg_n          : std_logic_vector(6 downto 0);

begin

  u_dec_high : entity work.seven_segment_decoder
    generic map (ACTIVE_LOW => false)
    port map (hex => hex, seg => seg_high);

  u_dec_low : entity work.seven_segment_decoder
    generic map (ACTIVE_LOW => true)
    port map (hex => hex, seg => seg_low);

  u_parity : entity work.even_parity
    generic map (WIDTH => 4)
    port map (data => hex, parity => parity);

  u_top : entity work.parity_display_top
    port map (a => hex, show_parity => show_parity, seg_n => top_seg_n);

  main : process
    variable row1, row2, row3 : line;
    variable lit              : std_logic_vector(6 downto 0);
    variable shown            : natural;

    -- append one 3x3 character cell for the pattern p (bit 6 = a)
    procedure draw (p : std_logic_vector(6 downto 0)) is
      function ch (seg_on : std_logic; c : character) return character is
      begin
        if seg_on = '1' then return c; else return ' '; end if;
      end function;
    begin
      write(row1, ' ' & ch(p(6), '_') & "  ");
      write(row2, ch(p(1), '|') & ch(p(0), '_') & ch(p(5), '|') & ' ');
      write(row3, ch(p(2), '|') & ch(p(3), '_') & ch(p(4), '|') & ' ');
    end procedure;
  begin
    test_runner_setup(runner, runner_cfg);

    while test_suite loop

      if run("decoder_matches_segment_spec") then
        for digit in 0 to 15 loop
          hex <= std_logic_vector(to_unsigned(digit, 4));
          wait for 1 ns;
          check_equal(seg_high, pattern(digit), "active-high pattern, digit " & to_string(digit));
          check_equal(seg_low, not pattern(digit), "active-low pattern, digit " & to_string(digit));
          draw(seg_high);
        end loop;
        writeline(output, row1);
        writeline(output, row2);
        writeline(output, row3);

      elsif run("even_parity_all_inputs") then
        for value in 0 to 15 loop
          hex <= std_logic_vector(to_unsigned(value, 4));
          wait for 1 ns;
          -- data plus parity bit must always contain an even number of ones
          check_equal(ones(hex & parity) mod 2, 0, "parity of " & to_string(hex));
        end loop;

      elsif run("top_shows_value_or_parity") then
        for value in 0 to 15 loop
          for mode in 0 to 1 loop
            hex         <= std_logic_vector(to_unsigned(value, 4));
            show_parity <= '1' when mode = 1 else '0';
            wait for 1 ns;
            if mode = 0 then
              shown := value;                    -- the hex digit itself
            else
              shown := ones(hex) mod 2;          -- 0 or 1
            end if;
            check_equal(top_seg_n, not pattern(shown),
                        "top a=" & to_string(value) & " show_parity=" & to_string(mode));
          end loop;
        end loop;
      end if;

    end loop;

    test_runner_cleanup(runner);
  end process main;

end architecture tb;
