--------------------------------------------------------------------------------
-- tb_adders : exhaustive, self-checking test of the three adder designs
--
-- Every input combination is applied and the outputs are compared against
-- integer addition (the reference model):
--   full_adder          2**3              =       8 vectors
--   two_bit_adder       2**4              =      16 vectors
--   ripple_carry_adder  2**(2*WIDTH + 1)  = 131 072 vectors for WIDTH = 8
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity tb_adders is
  generic (
    runner_cfg : string;
    WIDTH      : positive := 3
  );
end entity tb_adders;

architecture tb of tb_adders is

  function to_sl (b : boolean) return std_logic is
  begin
    if b then return '1'; else return '0'; end if;
  end function;

  -- full adder
  signal fa_a, fa_b, fa_cin, fa_sum, fa_cout : std_logic := '0';
  -- two-bit adder (week-1 lab)
  signal a0, a1, b0, b1, sum0, sum1, carry   : std_logic := '0';
  -- WIDTH-bit ripple-carry adder
  signal a, b, sum : std_logic_vector(WIDTH - 1 downto 0) := (others => '0');
  signal cin, cout : std_logic := '0';

begin

  u_full_adder : entity work.full_adder
    port map (a => fa_a, b => fa_b, cin => fa_cin, sum => fa_sum, cout => fa_cout);

  u_two_bit_adder : entity work.two_bit_adder
    port map (a0 => a0, a1 => a1, b0 => b0, b1 => b1,
              sum0 => sum0, sum1 => sum1, carry => carry);

  u_ripple_carry_adder : entity work.ripple_carry_adder
    generic map (WIDTH => WIDTH)
    port map (a => a, b => b, cin => cin, sum => sum, cout => cout);

  main : process
    variable n_vectors : natural;
  begin
    test_runner_setup(runner, runner_cfg);

    while test_suite loop
      n_vectors := 0;

      if run("full_adder_exhaustive") then
        for ia in 0 to 1 loop
          for ib in 0 to 1 loop
            for ic in 0 to 1 loop
              fa_a <= to_sl(ia = 1);  fa_b <= to_sl(ib = 1);  fa_cin <= to_sl(ic = 1);
              wait for 1 ns;
              check_equal(unsigned'(fa_cout & fa_sum), ia + ib + ic,
                          "full_adder a=" & to_string(ia) & " b=" & to_string(ib) &
                          " cin=" & to_string(ic));
              n_vectors := n_vectors + 1;
            end loop;
          end loop;
        end loop;

      elsif run("two_bit_adder_exhaustive") then
        for ia in 0 to 3 loop
          for ib in 0 to 3 loop
            (a1, a0) <= to_unsigned(ia, 2);
            (b1, b0) <= to_unsigned(ib, 2);
            wait for 1 ns;
            check_equal(unsigned'(carry & sum1 & sum0), ia + ib,
                        "two_bit_adder " & to_string(ia) & " + " & to_string(ib));
            n_vectors := n_vectors + 1;
          end loop;
        end loop;

      elsif run("ripple_carry_adder_exhaustive") then
        for ia in 0 to 2**WIDTH - 1 loop
          for ib in 0 to 2**WIDTH - 1 loop
            for ic in 0 to 1 loop
              a   <= std_logic_vector(to_unsigned(ia, WIDTH));
              b   <= std_logic_vector(to_unsigned(ib, WIDTH));
              cin <= to_sl(ic = 1);
              wait for 1 ns;
              -- report only failing vectors: building the message string for
              -- every one of the 131k passing vectors would dominate run time
              if unsigned'(cout & unsigned(sum)) /= ia + ib + ic then
                check_equal(unsigned'(cout & unsigned(sum)), ia + ib + ic,
                            "ripple_carry_adder " & to_string(ia) & " + " &
                            to_string(ib) & " + " & to_string(ic));
              end if;
              n_vectors := n_vectors + 1;
            end loop;
          end loop;
        end loop;
      end if;

      info("checked " & to_string(n_vectors) & " input vectors");
    end loop;

    test_runner_cleanup(runner);
  end process main;

end architecture tb;
