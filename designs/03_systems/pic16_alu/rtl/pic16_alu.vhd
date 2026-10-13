--------------------------------------------------------------------------------
-- pic16_alu : execute stage (ALU + STATUS flag logic) of a PIC16 mid-range core
--
-- Started as a 6-instruction lab ALU with home-made opcodes; extended to decode
-- the real 14-bit instruction word of the PIC16F690 (datasheet table 15-2)
-- for every instruction that produces data, flags or a skip:
--
--   byte-oriented  00 oooo dfff ffff  ADDWF ANDWF CLRF CLRW COMF DECF DECFSZ
--                                     INCF INCFSZ IORWF MOVF MOVWF RLF RRF
--                                     SUBWF SWAPF XORWF  (d: 0 -> W, 1 -> f)
--   bit-oriented   01 oobb bfff ffff  BCF BSF BTFSC BTFSS (bbb = bit number)
--   literal        11 oooo kkkk kkkk  ADDLW ANDLW IORLW MOVLW RETLW SUBLW XORLW
--
-- Control-flow instructions (GOTO, CALL, RETURN, RETFIE, SLEEP, CLRWDT, NOP)
-- produce no write and no flags here; PC, stack and the register file live
-- outside this block. Purely combinational.
--
-- Flag semantics (as in the datasheet):
--   Z  = result is zero
--   C  = carry out of bit 7; for subtraction C = 1 means "no borrow"
--   DC = carry out of bit 3 (digit carry, for BCD arithmetic)
--   RLF / RRF rotate through C.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pic16_alu is
  port (
    instr  : in  std_logic_vector(13 downto 0);  -- instruction word
    w      : in  std_logic_vector(7 downto 0);   -- W (working register)
    f      : in  std_logic_vector(7 downto 0);   -- value of file register f
    c_in   : in  std_logic;                      -- current STATUS.C
    result : out std_logic_vector(7 downto 0);
    wr_en  : out std_logic;   -- '1': write result back
    wr_f   : out std_logic;   -- destination: '1' = f, '0' = W
    skip   : out std_logic;   -- '1': skip next instruction (xxxFSZ, BTFSx)
    z      : out std_logic;   -- new flag values ...
    dc     : out std_logic;
    c      : out std_logic;
    z_we   : out std_logic;   -- ... and which flags this instruction updates
    dc_we  : out std_logic;
    c_we   : out std_logic
  );
end entity pic16_alu;

architecture rtl of pic16_alu is

  -- x + y + cin exactly like the PIC adder; returns (DC, C, sum(7:0)).
  -- Subtraction x - y is pic_add(x, not y, '1'), which makes C/DC read as
  -- "no borrow" - the datasheet convention.
  function pic_add (x, y : std_logic_vector(7 downto 0); cin : std_logic)
    return std_logic_vector is
    variable ci  : unsigned(0 downto 0);
    variable lo  : unsigned(4 downto 0);
    variable sum : unsigned(8 downto 0);
  begin
    ci(0) := cin;
    lo  := resize(unsigned(x(3 downto 0)), 5) + resize(unsigned(y(3 downto 0)), 5) + ci;
    sum := resize(unsigned(x), 9) + resize(unsigned(y), 9) + ci;
    return std_logic_vector(lo(4) & sum);       -- 10 bits: dc, c, sum
  end function pic_add;

begin

  process (instr, w, f, c_in)
    variable d      : std_logic;                     -- destination bit
    variable k      : std_logic_vector(7 downto 0);  -- literal
    variable bitn   : natural range 0 to 7;          -- bit number
    variable add    : std_logic_vector(9 downto 0);  -- (dc, c, sum)
    variable res    : std_logic_vector(7 downto 0);
    variable v_wren, v_wrf, v_skip, v_dc, v_c : std_logic;
    variable v_zwe, v_dcwe, v_cwe             : std_logic;
  begin
    d    := instr(7);
    k    := instr(7 downto 0);
    bitn := to_integer(unsigned(instr(9 downto 7)));

    -- defaults: no write, no flag update, no skip
    res    := (others => '0');
    v_wren := '0';  v_wrf := '0';  v_skip := '0';
    v_dc   := '0';  v_c   := '0';
    v_zwe  := '0';  v_dcwe := '0'; v_cwe := '0';

    case instr(13 downto 12) is

      ------------------------------------------------------------------ byte
      when "00" =>
        v_wren := '1';
        v_wrf  := d;
        case instr(11 downto 8) is
          when "0000" =>                                  -- MOVWF / NOP group
            res    := w;
            v_wren := d;                                  -- only MOVWF writes
            v_wrf  := '1';
          when "0001" =>                                  -- CLRF (d=1), CLRW (d=0)
            res   := (others => '0');
            v_zwe := '1';
          when "0010" =>                                  -- SUBWF  f - W
            add := pic_add(f, not w, '1');
            res := add(7 downto 0);  v_c := add(8);  v_dc := add(9);
            v_zwe := '1';  v_cwe := '1';  v_dcwe := '1';
          when "0011" =>                                  -- DECF
            res   := std_logic_vector(unsigned(f) - 1);
            v_zwe := '1';
          when "0100" =>                                  -- IORWF
            res   := w or f;
            v_zwe := '1';
          when "0101" =>                                  -- ANDWF
            res   := w and f;
            v_zwe := '1';
          when "0110" =>                                  -- XORWF
            res   := w xor f;
            v_zwe := '1';
          when "0111" =>                                  -- ADDWF  W + f
            add := pic_add(w, f, '0');
            res := add(7 downto 0);  v_c := add(8);  v_dc := add(9);
            v_zwe := '1';  v_cwe := '1';  v_dcwe := '1';
          when "1000" =>                                  -- MOVF
            res   := f;
            v_zwe := '1';
          when "1001" =>                                  -- COMF
            res   := not f;
            v_zwe := '1';
          when "1010" =>                                  -- INCF
            res   := std_logic_vector(unsigned(f) + 1);
            v_zwe := '1';
          when "1011" =>                                  -- DECFSZ
            res := std_logic_vector(unsigned(f) - 1);
            if res = x"00" then v_skip := '1'; end if;
          when "1100" =>                                  -- RRF (through carry)
            res   := c_in & f(7 downto 1);
            v_c   := f(0);
            v_cwe := '1';
          when "1101" =>                                  -- RLF (through carry)
            res   := f(6 downto 0) & c_in;
            v_c   := f(7);
            v_cwe := '1';
          when "1110" =>                                  -- SWAPF
            res := f(3 downto 0) & f(7 downto 4);
          when others =>                                  -- "1111" INCFSZ
            res := std_logic_vector(unsigned(f) + 1);
            if res = x"00" then v_skip := '1'; end if;
        end case;

      ------------------------------------------------------------------- bit
      when "01" =>
        res := f;
        case instr(11 downto 10) is
          when "00" =>                                    -- BCF
            res(bitn) := '0';
            v_wren := '1';  v_wrf := '1';
          when "01" =>                                    -- BSF
            res(bitn) := '1';
            v_wren := '1';  v_wrf := '1';
          when "10" =>                                    -- BTFSC
            v_skip := not f(bitn);
          when others =>                                  -- "11" BTFSS
            v_skip := f(bitn);
        end case;

      --------------------------------------------------------------- literal
      when "11" =>
        v_wren := '1';                                    -- destination is W
        case instr(11 downto 8) is
          when "0000" | "0001" | "0010" | "0011" |        -- MOVLW
               "0100" | "0101" | "0110" | "0111" =>       -- RETLW
            res := k;
          when "1000" =>                                  -- IORLW
            res   := k or w;
            v_zwe := '1';
          when "1001" =>                                  -- ANDLW
            res   := k and w;
            v_zwe := '1';
          when "1010" =>                                  -- XORLW
            res   := k xor w;
            v_zwe := '1';
          when "1100" | "1101" =>                         -- SUBLW  k - W
            add := pic_add(k, not w, '1');
            res := add(7 downto 0);  v_c := add(8);  v_dc := add(9);
            v_zwe := '1';  v_cwe := '1';  v_dcwe := '1';
          when "1110" | "1111" =>                         -- ADDLW  k + W
            add := pic_add(k, w, '0');
            res := add(7 downto 0);  v_c := add(8);  v_dc := add(9);
            v_zwe := '1';  v_cwe := '1';  v_dcwe := '1';
          when others =>                                  -- "1011" unused
            v_wren := '0';
        end case;

      --------------------------------------------------------- CALL / GOTO
      when others =>
        null;

    end case;

    result <= res;
    wr_en  <= v_wren;
    wr_f   <= v_wrf;
    skip   <= v_skip;
    if res = x"00" then z <= '1'; else z <= '0'; end if;
    dc     <= v_dc;
    c      <= v_c;
    z_we   <= v_zwe;
    dc_we  <= v_dcwe;
    c_we   <= v_cwe;
  end process;

end architecture rtl;
