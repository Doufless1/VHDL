--------------------------------------------------------------------------------
-- ripple_carry_adder : WIDTH-bit adder built structurally from full adders
--
-- Week-2 lab ("three_bit_adder") generalised with a generic and a
-- for-generate loop; WIDTH = 3 reproduces the original board design.
--
--   {cout, sum} = a + b + cin        (unsigned, WIDTH bits)
--
-- The carry ripples through WIDTH full adders, so the critical path grows
-- linearly with WIDTH. Fine for small widths; wide adders use the FPGA's
-- dedicated carry chain (write `a + b` with numeric_std) or a carry-lookahead
-- structure instead.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity ripple_carry_adder is
  generic (
    WIDTH : positive := 3
  );
  port (
    a, b : in  std_logic_vector(WIDTH - 1 downto 0);
    cin  : in  std_logic;
    sum  : out std_logic_vector(WIDTH - 1 downto 0);
    cout : out std_logic
  );
end entity ripple_carry_adder;

architecture structural of ripple_carry_adder is
  -- carry(i) is the carry into bit i; carry(WIDTH) is the final carry-out
  signal carry : std_logic_vector(WIDTH downto 0);
begin

  carry(0) <= cin;

  gen_bit : for i in 0 to WIDTH - 1 generate
    u_fa : entity work.full_adder
      port map (
        a    => a(i),
        b    => b(i),
        cin  => carry(i),
        sum  => sum(i),
        cout => carry(i + 1)
      );
  end generate gen_bit;

  cout <= carry(WIDTH);

end architecture structural;
