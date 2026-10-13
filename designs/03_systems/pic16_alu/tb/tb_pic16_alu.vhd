--------------------------------------------------------------------------------
-- tb_pic16_alu : exhaustive verification of the PIC16 execute stage
--
-- Reference model written independently of the RTL:
--   * decoding matches the instruction word against the datasheet bit
--     patterns ("000111--------" = ADDWF, ...) instead of nested case tables
--   * results and flags are computed with integer arithmetic
-- Only architecturally visible effects are compared: the result only when
-- it is written, a flag only when the instruction updates it.
--
-- Coverage: every byte-oriented and literal opcode for all 256 x 256 operand
-- pairs, every bit instruction for all 256 values x 8 bit positions, and all
-- control-flow encodings: ~2.2 million vectors.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity tb_pic16_alu is
  generic (
    runner_cfg : string
  );
end entity tb_pic16_alu;

architecture tb of tb_pic16_alu is

  type mnemonic_t is (
    I_ADDWF, I_ANDWF, I_CLRF,  I_CLRW,  I_COMF,   I_DECF,  I_DECFSZ, I_INCF,
    I_INCFSZ, I_IORWF, I_MOVF, I_MOVWF, I_NOP,    I_RLF,   I_RRF,    I_SUBWF,
    I_SWAPF, I_XORWF,  I_BCF,  I_BSF,   I_BTFSC,  I_BTFSS, I_ADDLW,  I_ANDLW,
    I_IORLW, I_MOVLW,  I_RETLW, I_SUBLW, I_XORLW, I_CALL,  I_GOTO,   I_CLRWDT,
    I_RETFIE, I_RETURN, I_SLEEP, I_RESERVED);

  type encoding_t is record
    mnemonic : mnemonic_t;
    pattern  : std_logic_vector(13 downto 0);
  end record;
  type encoding_table_t is array (natural range <>) of encoding_t;

  -- PIC16F690 datasheet, table 15-2 ('-' = don't care / operand field)
  constant ENCODINGS : encoding_table_t := (
    (I_ADDWF,  "000111--------"), (I_ANDWF,  "000101--------"),
    (I_CLRF,   "0000011-------"), (I_CLRW,   "0000010-------"),
    (I_COMF,   "001001--------"), (I_DECF,   "000011--------"),
    (I_DECFSZ, "001011--------"), (I_INCF,   "001010--------"),
    (I_INCFSZ, "001111--------"), (I_IORWF,  "000100--------"),
    (I_MOVF,   "001000--------"), (I_MOVWF,  "0000001-------"),
    (I_NOP,    "0000000--00000"), (I_RLF,    "001101--------"),
    (I_RRF,    "001100--------"), (I_SUBWF,  "000010--------"),
    (I_SWAPF,  "001110--------"), (I_XORWF,  "000110--------"),
    (I_BCF,    "0100----------"), (I_BSF,    "0101----------"),
    (I_BTFSC,  "0110----------"), (I_BTFSS,  "0111----------"),
    (I_ADDLW,  "11111---------"), (I_ANDLW,  "111001--------"),
    (I_IORLW,  "111000--------"), (I_MOVLW,  "1100----------"),
    (I_RETLW,  "1101----------"), (I_SUBLW,  "11110---------"),
    (I_XORLW,  "111010--------"), (I_CALL,   "100-----------"),
    (I_GOTO,   "101-----------"), (I_CLRWDT, "00000001100100"),
    (I_RETFIE, "00000000001001"), (I_RETURN, "00000000001000"),
    (I_SLEEP,  "00000001100011"));

  function decode (instr : std_logic_vector(13 downto 0)) return mnemonic_t is
  begin
    for i in ENCODINGS'range loop
      if std_match(instr, ENCODINGS(i).pattern) then
        return ENCODINGS(i).mnemonic;
      end if;
    end loop;
    return I_RESERVED;
  end function;

  ------------------------------------------------------------------------------
  -- Reference model: integer arithmetic, datasheet semantics
  ------------------------------------------------------------------------------
  type effect_t is record
    wr_en, wr_f, skip : std_logic;
    result            : natural range 0 to 255;
    z_we, dc_we, c_we : std_logic;
    z, dc, c          : std_logic;
  end record;

  function sl (b : boolean) return std_logic is
  begin
    if b then return '1'; else return '0'; end if;
  end function;

  function bits (x : natural) return unsigned is
  begin
    return to_unsigned(x, 8);
  end function;

  function model (m : mnemonic_t; instr : std_logic_vector(13 downto 0);
                  w, f : natural; c_in : std_logic) return effect_t is
    variable e   : effect_t := ('0', '0', '0', 0, '0', '0', '0', '0', '0', '0');
    variable d   : std_logic := instr(7);
    variable k   : natural   := to_integer(unsigned(instr(7 downto 0)));
    variable b   : natural   := to_integer(unsigned(instr(9 downto 7)));
    variable cin : natural   := 0;

    procedure to_f_or_w is begin e.wr_en := '1'; e.wr_f := d;   end procedure;
    procedure to_w      is begin e.wr_en := '1'; e.wr_f := '0'; end procedure;
    procedure to_f      is begin e.wr_en := '1'; e.wr_f := '1'; end procedure;
    procedure all_flags is begin e.z_we := '1'; e.dc_we := '1'; e.c_we := '1'; end procedure;
  begin
    if c_in = '1' then cin := 1; end if;

    case m is
      -- byte-oriented
      when I_ADDWF  => e.result := (w + f) mod 256;  e.c := sl(w + f > 255);
                       e.dc := sl(w mod 16 + f mod 16 > 15);       to_f_or_w; all_flags;
      when I_SUBWF  => e.result := (f - w + 256) mod 256;  e.c := sl(f >= w);
                       e.dc := sl(f mod 16 >= w mod 16);           to_f_or_w; all_flags;
      when I_ANDWF  => e.result := to_integer(bits(w) and bits(f)); to_f_or_w; e.z_we := '1';
      when I_IORWF  => e.result := to_integer(bits(w) or bits(f));  to_f_or_w; e.z_we := '1';
      when I_XORWF  => e.result := to_integer(bits(w) xor bits(f)); to_f_or_w; e.z_we := '1';
      when I_COMF   => e.result := 255 - f;               to_f_or_w; e.z_we := '1';
      when I_DECF   => e.result := (f + 255) mod 256;     to_f_or_w; e.z_we := '1';
      when I_INCF   => e.result := (f + 1) mod 256;       to_f_or_w; e.z_we := '1';
      when I_MOVF   => e.result := f;                     to_f_or_w; e.z_we := '1';
      when I_DECFSZ => e.result := (f + 255) mod 256;     to_f_or_w; e.skip := sl(f = 1);
      when I_INCFSZ => e.result := (f + 1) mod 256;       to_f_or_w; e.skip := sl(f = 255);
      when I_RLF    => e.result := (2 * f) mod 256 + cin; to_f_or_w;
                       e.c := sl(f >= 128);  e.c_we := '1';
      when I_RRF    => e.result := f / 2 + 128 * cin;     to_f_or_w;
                       e.c := sl(f mod 2 = 1);  e.c_we := '1';
      when I_SWAPF  => e.result := (f mod 16) * 16 + f / 16;  to_f_or_w;
      when I_CLRF   => e.result := 0;  to_f;  e.z_we := '1';
      when I_CLRW   => e.result := 0;  to_w;  e.z_we := '1';
      when I_MOVWF  => e.result := w;  to_f;
      -- bit-oriented
      when I_BCF    => e.result := to_integer(bits(f) and not bits(2**b));  to_f;
      when I_BSF    => e.result := to_integer(bits(f) or bits(2**b));       to_f;
      when I_BTFSC  => e.skip := sl((f / 2**b) mod 2 = 0);
      when I_BTFSS  => e.skip := sl((f / 2**b) mod 2 = 1);
      -- literal
      when I_ADDLW  => e.result := (k + w) mod 256;  e.c := sl(k + w > 255);
                       e.dc := sl(k mod 16 + w mod 16 > 15);       to_w; all_flags;
      when I_SUBLW  => e.result := (k - w + 256) mod 256;  e.c := sl(k >= w);
                       e.dc := sl(k mod 16 >= w mod 16);           to_w; all_flags;
      when I_ANDLW  => e.result := to_integer(bits(k) and bits(w)); to_w; e.z_we := '1';
      when I_IORLW  => e.result := to_integer(bits(k) or bits(w));  to_w; e.z_we := '1';
      when I_XORLW  => e.result := to_integer(bits(k) xor bits(w)); to_w; e.z_we := '1';
      when I_MOVLW | I_RETLW => e.result := k;  to_w;
      -- control flow / reserved: no data effect
      when others   => null;
    end case;

    e.z := sl(e.result = 0);
    return e;
  end function;

  -- visible effects as a vector; '-' where the DUT output does not matter
  function expected_vector (e : effect_t) return std_logic_vector is
    variable v : std_logic_vector(16 downto 0) := (others => '-');
  begin
    v(16) := e.wr_en;
    if e.wr_en = '1' then
      v(15)          := e.wr_f;
      v(14 downto 7) := std_logic_vector(to_unsigned(e.result, 8));
    end if;
    v(6) := e.skip;
    v(5) := e.z_we;  v(4) := e.dc_we;  v(3) := e.c_we;
    if e.z_we  = '1' then v(2) := e.z;  end if;
    if e.dc_we = '1' then v(1) := e.dc; end if;
    if e.c_we  = '1' then v(0) := e.c;  end if;
    return v;
  end function;

  ------------------------------------------------------------------------------
  signal instr  : std_logic_vector(13 downto 0) := (others => '0');
  signal w, f   : std_logic_vector(7 downto 0)  := (others => '0');
  signal c_in   : std_logic := '0';
  signal result : std_logic_vector(7 downto 0);
  signal wr_en, wr_f, skip, z, dc, c, z_we, dc_we, c_we : std_logic;

begin

  u_dut : entity work.pic16_alu
    port map (
      instr => instr, w => w, f => f, c_in => c_in,
      result => result, wr_en => wr_en, wr_f => wr_f, skip => skip,
      z => z, dc => dc, c => c, z_we => z_we, dc_we => dc_we, c_we => c_we
    );

  main : process
    variable n_vectors : natural;
    variable m         : mnemonic_t;

    procedure apply (instr_v : std_logic_vector(13 downto 0);
                     w_v, f_v : natural; c_v : std_logic) is
      variable actual, expected : std_logic_vector(16 downto 0);
    begin
      instr <= instr_v;
      w     <= std_logic_vector(to_unsigned(w_v, 8));
      f     <= std_logic_vector(to_unsigned(f_v, 8));
      c_in  <= c_v;
      wait for 1 ns;
      actual   := wr_en & wr_f & result & skip & z_we & dc_we & c_we & z & dc & c;
      expected := expected_vector(model(decode(instr_v), instr_v, w_v, f_v, c_v));
      if not std_match(actual, expected) then         -- build messages on failure only
        check_match(actual, expected,
                    mnemonic_t'image(decode(instr_v)) & " instr=" & to_string(instr_v) &
                    " W=" & to_string(w_v) & " f=" & to_string(f_v) &
                    " C=" & to_string(c_v) &
                    "  [wr_en wr_f result(8) skip z_we dc_we c_we z dc c]");
      end if;
      n_vectors := n_vectors + 1;
    end procedure;

    -- canonical encodings for the directed tests (f address 0x20)
    function byte_op (op : std_logic_vector(5 downto 0); d : std_logic) return std_logic_vector is
    begin
      return op & d & "0100000";
    end function;
    function bit_op (op : std_logic_vector(3 downto 0); b : natural) return std_logic_vector is
    begin
      return op & std_logic_vector(to_unsigned(b, 3)) & "0100000";
    end function;
    function lit_op (op : std_logic_vector(5 downto 0); k : natural) return std_logic_vector is
    begin
      return op & std_logic_vector(to_unsigned(k, 8));
    end function;

    variable d    : std_logic;
    variable addr : std_logic_vector(6 downto 0);
  begin
    test_runner_setup(runner, runner_cfg);

    while test_suite loop
      n_vectors := 0;

      if run("worked_examples") then
        -- readable spot checks; the exhaustive tests below compare everything
        apply(byte_op("000111", '0'), 16#17#, 16#C2#, '0');           -- ADDWF
        check_equal(result, std_logic_vector'(x"D9"), "ADDWF 0x17 + 0xC2");
        apply(byte_op("000111", '0'), 16#0F#, 16#01#, '0');           -- ADDWF, digit carry
        check_equal(result, std_logic_vector'(x"10"), "ADDWF 0x0F + 0x01");
        check_equal(dc, '1', "DC: carry out of bit 3");
        apply(byte_op("000111", '0'), 16#FF#, 16#01#, '0');           -- ADDWF, wrap
        check_equal(result, std_logic_vector'(x"00"), "ADDWF 0xFF + 0x01");
        check_equal(std_logic_vector'(c & z), std_logic_vector'("11"), "C and Z on wrap to zero");
        apply(byte_op("000010", '1'), 2, 3, '0');                     -- SUBWF 3 - 2
        check_equal(unsigned(result), 1, "SUBWF 3 - 2");
        check_equal(std_logic_vector'(c & z), std_logic_vector'("10"), "C=1 (no borrow), Z=0");
        apply(byte_op("000010", '1'), 2, 2, '0');                     -- SUBWF 2 - 2
        check_equal(std_logic_vector'(c & z), std_logic_vector'("11"), "C=1, Z=1");
        apply(byte_op("000010", '1'), 2, 1, '0');                     -- SUBWF 1 - 2
        check_equal(result, std_logic_vector'(x"FF"), "SUBWF 1 - 2");
        check_equal(std_logic_vector'(c & z), std_logic_vector'("00"), "C=0 (borrow), Z=0");
        apply(byte_op("001101", '0'), 0, 2#11100110#, '0');           -- RLF
        check_equal(result, std_logic_vector'("11001100"), "RLF");
        check_equal(c, '1', "RLF: old bit 7 goes to C");
        apply(byte_op("001110", '1'), 0, 16#A5#, '0');                -- SWAPF
        check_equal(result, std_logic_vector'(x"5A"), "SWAPF");
        apply(byte_op("001011", '1'), 0, 1, '0');                     -- DECFSZ 1 -> 0
        check_equal(skip, '1', "DECFSZ skips when the result is zero");
        apply(bit_op("0101", 7), 0, 16#00#, '0');                     -- BSF f,7
        check_equal(result, std_logic_vector'(x"80"), "BSF bit 7");
        apply(bit_op("0110", 3), 0, 16#00#, '0');                     -- BTFSC f,3
        check_equal(skip, '1', "BTFSC skips when the bit is clear");
        apply(lit_op("111110", 16#05#), 16#03#, 0, '0');              -- ADDLW
        check_equal(unsigned(result), 8, "ADDLW 5 + 3");

      elsif run("byte_oriented_exhaustive") then
        for op in 0 to 15 loop
          for wv in 0 to 255 loop
            for fv in 0 to 255 loop
              d    := '1' when (wv + fv) mod 2 = 1 else '0';   -- both destinations
              addr := std_logic_vector(to_unsigned((wv * 7 + fv) mod 128, 7));
              apply("00" & std_logic_vector(to_unsigned(op, 4)) & d & addr, wv, fv, '0');
              if op = 12 or op = 13 then                         -- RRF / RLF use C
                apply("00" & std_logic_vector(to_unsigned(op, 4)) & d & addr, wv, fv, '1');
              end if;
            end loop;
          end loop;
        end loop;

      elsif run("literal_exhaustive") then
        for op in 0 to 15 loop
          for wv in 0 to 255 loop
            for k in 0 to 255 loop
              apply("11" & std_logic_vector(to_unsigned(op, 4)) & std_logic_vector(to_unsigned(k, 8)),
                    wv, (wv + k) mod 256, '0');
            end loop;
          end loop;
        end loop;

      elsif run("bit_oriented_exhaustive") then
        for op in 0 to 3 loop
          for b in 0 to 7 loop
            for fv in 0 to 255 loop
              apply("01" & std_logic_vector(to_unsigned(op, 2)) & std_logic_vector(to_unsigned(b, 3)) &
                    std_logic_vector(to_unsigned(fv mod 128, 7)), (fv * 3) mod 256, fv, '1');
            end loop;
          end loop;
        end loop;

      elsif run("control_flow_has_no_side_effects") then
        for target in 0 to 4095 loop                             -- every CALL / GOTO
          apply("10" & std_logic_vector(to_unsigned(target, 12)), target mod 256, 255 - target mod 256, '1');
        end loop;
        for low in 0 to 127 loop                                  -- NOP/RETURN/... group
          apply("0000000" & std_logic_vector(to_unsigned(low, 7)), 16#AA#, 16#55#, '1');
          m := decode("0000000" & std_logic_vector(to_unsigned(low, 7)));
          check_equal(wr_en, '0', mnemonic_t'image(m) & " must not write");
        end loop;
      end if;

      info("checked " & to_string(n_vectors) & " vectors");
    end loop;

    test_runner_cleanup(runner);
  end process main;

end architecture tb;
