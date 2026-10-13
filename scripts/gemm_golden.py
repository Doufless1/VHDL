#!/usr/bin/env python3
"""NumPy golden model and test-vector writer for the INT8 systolic array.

The hardware (designs/04_capstones/systolic_array) computes C = A @ B for
INT8 A (ROWS x K) and B (K x COLS) with INT32 accumulation. This module:

* defines the reference result (exact integer matmul, range-checked to INT32),
* builds a vector set: corner cases + random tiles + a larger "layer" that is
  split into ROWS x COLS output tiles, as an accelerator compiler would do,
* writes it in *beat order* - the exact stream the hardware consumes:

    # comment lines start with '#'
    <number of tiles>
    for every tile:
      <K>
      K lines     A(0,k) .. A(ROWS-1,k)   B(k,0) .. B(k,COLS-1)
      ROWS lines  C(i,0) .. C(i,COLS-1)

The VUnit run script calls write_vectors() before each simulation; it can
also be run by hand:  python scripts/gemm_golden.py --rows 4 --cols 4 -o v.txt
"""

from __future__ import annotations

import argparse
from pathlib import Path

import numpy as np

INT8_MIN, INT8_MAX = -128, 127
INT32_MIN, INT32_MAX = -(2**31), 2**31 - 1


def golden_gemm(a: np.ndarray, b: np.ndarray) -> np.ndarray:
    """Reference result: exact integer product, must fit the INT32 accumulator."""
    c = a.astype(np.int64) @ b.astype(np.int64)
    assert c.min() >= INT32_MIN and c.max() <= INT32_MAX, "result overflows INT32"
    return c.astype(np.int32)


def tile_layer(a: np.ndarray, b: np.ndarray, rows: int, cols: int) -> list[tuple[np.ndarray, np.ndarray]]:
    """Split C = A @ B into output tiles of rows x cols (each tile uses the full K).

    Reassembling the tile results must give the full product - checked here, so
    the tiling scheme itself is verified, not only the hardware.
    """
    m, _ = a.shape
    _, n = b.shape
    assert m % rows == 0 and n % cols == 0, "layer must be a multiple of the array size"
    tiles = []
    full = np.zeros((m, n), dtype=np.int64)
    for ti in range(0, m, rows):
        for tj in range(0, n, cols):
            a_t, b_t = a[ti:ti + rows, :], b[:, tj:tj + cols]
            tiles.append((a_t, b_t))
            full[ti:ti + rows, tj:tj + cols] = golden_gemm(a_t, b_t)
    assert np.array_equal(full, golden_gemm(a, b)), "tiling does not reproduce the full product"
    return tiles


def make_tiles(rows: int, cols: int, seed: int) -> list[tuple[np.ndarray, np.ndarray]]:
    rng = np.random.default_rng(seed)

    def rand(shape: tuple[int, int]) -> np.ndarray:
        return rng.integers(INT8_MIN, INT8_MAX + 1, size=shape, dtype=np.int64)

    def full(shape: tuple[int, int], value: int) -> np.ndarray:
        return np.full(shape, value, dtype=np.int64)

    tiles = [
        (rand((rows, 1)), rand((1, cols))),                    # K = 1: outer product
        (full((rows, 64), INT8_MIN), full((64, cols), INT8_MIN)),  # largest positive sum
        (full((rows, 64), INT8_MIN), full((64, cols), INT8_MAX)),  # most negative sum
        (rand((rows, cols)), np.eye(cols, dtype=np.int64)),    # B = I  ->  C = A
    ]
    for k in (2, 3, rows + cols, 16, 31, 100):                 # random depths
        tiles.append((rand((rows, k)), rand((k, cols))))
    # a small fully-connected layer (3*ROWS x 48) @ (48 x 2*COLS), tiled
    tiles += tile_layer(rand((3 * rows, 48)), rand((48, 2 * cols)), rows, cols)
    return tiles


def write_vectors(path: Path, rows: int, cols: int, seed: int) -> int:
    """Write the vector file for one array configuration; returns the tile count."""
    tiles = make_tiles(rows, cols, seed)
    lines = [
        f"# INT8 GEMM golden vectors for a {rows}x{cols} systolic array (seed {seed})",
        "# per tile: K, then K beats 'A(:,k) B(k,:)', then C = A @ B row by row",
        str(len(tiles)),
    ]
    for t, (a, b) in enumerate(tiles):
        k = a.shape[1]
        c = golden_gemm(a, b)
        lines.append(f"# tile {t}: K = {k}")
        lines.append(str(k))
        lines += [" ".join(str(v) for v in np.concatenate((a[:, kk], b[kk, :]))) for kk in range(k)]
        lines += [" ".join(str(v) for v in c[i, :]) for i in range(rows)]
    Path(path).write_text("\n".join(lines) + "\n")
    return len(tiles)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--rows", type=int, default=4)
    parser.add_argument("--cols", type=int, default=4)
    parser.add_argument("--seed", type=int, default=1)
    parser.add_argument("-o", "--output", type=Path, default=Path("gemm_vectors.txt"))
    args = parser.parse_args()
    n = write_vectors(args.output, args.rows, args.cols, args.seed)
    print(f"wrote {n} tiles to {args.output}")


if __name__ == "__main__":
    main()
