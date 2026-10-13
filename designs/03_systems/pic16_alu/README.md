# PIC16 execute stage — ALU + STATUS flags, verified exhaustively

> Course week 5 (ALU) · extended from a 6-instruction lab subset to the PIC16F690 instruction set

The course's final assignment referred to the PIC16F690 datasheet. The lab ALU used
six home-made opcodes; this version decodes the **real 14-bit PIC16 instruction
word** and implements every instruction that produces data, flags or a skip — the
execute stage of a PIC16 core. Program counter, stack and register file live
outside this block.

| File | Contents |
|---|---|
| [`rtl/pic16_alu.vhd`](rtl/pic16_alu.vhd) | Combinational execute stage |
| [`tb/tb_pic16_alu.vhd`](tb/tb_pic16_alu.vhd) | Independent reference model + exhaustive test |

## Supported instructions

| Class | Encoding | Instructions | Flags |
|---|---|---|---|
| Byte-oriented | `00 oooo dfff ffff` | ADDWF, SUBWF | C, DC, Z |
| | | ANDWF, IORWF, XORWF, COMF, DECF, INCF, MOVF, CLRF, CLRW | Z |
| | | RLF, RRF (rotate through carry) | C |
| | | DECFSZ, INCFSZ (skip if zero), SWAPF, MOVWF | — |
| Bit-oriented | `01 oobb bfff ffff` | BCF, BSF, BTFSC, BTFSS | — |
| Literal | `11 oooo kkkk kkkk` | ADDLW, SUBLW | C, DC, Z |
| | | ANDLW, IORLW, XORLW | Z |
| | | MOVLW, RETLW | — |
| Control | | GOTO, CALL, RETURN, RETFIE, SLEEP, CLRWDT, NOP | no ALU effect |

Outputs: `result`, `wr_en` / `wr_f` (write back to W or f — the `d` bit),
`skip`, the new `z`, `dc`, `c` values and a write-enable per flag.

Subtraction follows the datasheet: `C = 1` means **no borrow**. The ALU computes
`x − y` as `x + not(y) + 1`, which yields exactly that carry — the way the real
PIC adder does it.

## Verification: 2,240,652 vectors against an independent model

The reference model in the testbench is written differently from the RTL on
purpose, so the two cannot share a mistake:

- **Decoding** matches the instruction word against the datasheet bit patterns
  (`"000111--------"` = ADDWF) with `std_match`, instead of nested `case` tables.
- **Semantics** use integer arithmetic (`C = f >= W` for SUBWF, `DC` from nibble
  sums), not the hardware adder trick.
- Only **architecturally visible** effects are compared: the result only when it
  is written, a flag only when the instruction updates it.

| Test case | Vectors |
|---|---|
| `byte_oriented_exhaustive` | Every opcode × all 256 W × all 256 f (RLF/RRF also with both carry-in values): 1,179,648 |
| `literal_exhaustive` | Every literal opcode × all 256 W × all 256 k: 1,048,576 |
| `bit_oriented_exhaustive` | BCF/BSF/BTFSC/BTFSS × 8 bit positions × 256 values: 8,192 |
| `control_flow_has_no_side_effects` | All 4096 CALL/GOTO encodings + the whole NOP/RETURN/SLEEP group: 4,224 |
| `worked_examples` | Readable spot checks (e.g. SUBWF 1 − 2 = 0xFF with C = 0) |

Runs in about 9 seconds: `python run.py "*tb_pic16_alu*"`. Mutation testing checks
that an inverted SUBWF carry and an RLF that ignores the carry are both caught.

## Implementation

| Design | Quartus Prime 20.1, MAX 10 | Yosys estimate, current RTL |
|---|---|---|
| Lab version (6 instructions, no flags) | 44 LEs | — |
| Current (all 35 instructions decoded, 28 with data, flag or skip effects) | — | 252 LUT4 + 60 carry |
