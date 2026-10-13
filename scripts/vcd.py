"""Minimal reader for the VCD files GHDL writes (used by make_figures.py).

    wave = Vcd("build/waves/uart_tx.vcd")
    wave.at("tb_uart_tx.tx", t)        # value at time t (fs) -> '0' / '1' / bits
    wave.changes("tb_uart_tx.tx")      # [(time, value), ...]
    wave.edges("tb_uart_tx.clk")       # rising-edge times
"""

from __future__ import annotations

import bisect
from pathlib import Path


class Vcd:
    def __init__(self, path: str | Path):
        self.timescale_fs = 1
        self.end_time = 0                          # last timestamp in the file (fs)
        self._names: dict[str, str] = {}          # full name -> id code
        self._changes: dict[str, list[tuple[int, str]]] = {}
        self._parse(Path(path).read_text().split("\n"))

    def _parse(self, lines: list[str]) -> None:
        scope: list[str] = []
        units = {"fs": 1, "ps": 10**3, "ns": 10**6, "us": 10**9, "ms": 10**12, "s": 10**15}
        it = iter(lines)
        for line in it:                              # header
            tok = line.split()
            if not tok:
                continue
            if tok[0] == "$timescale":                 # "1 fs", "1fs", or on the next line
                spec = tok[1:]
                while "$end" not in spec:
                    spec += next(it).split()
                spec = "".join(spec[:spec.index("$end")])
                number = "".join(c for c in spec if c.isdigit()) or "1"
                self.timescale_fs = int(number) * units[spec.lstrip("0123456789")]
            elif tok[0] == "$scope":
                scope.append(tok[2])
            elif tok[0] == "$upscope":
                scope.pop()
            elif tok[0] == "$var":
                code, name = tok[3], tok[4]
                self._names[".".join(scope + [name])] = code
                self._changes.setdefault(code, [])
            elif tok[0] == "$enddefinitions":
                break
        time = 0
        for line in it:                              # value changes
            if not line:
                continue
            if line[0] == "#":
                time = int(line[1:]) * self.timescale_fs
                self.end_time = time
            elif line[0] in "01xzXZUuWwLlHh-":
                self._changes[line[1:]].append((time, line[0].upper()))
            elif line[0] in "bBrR":
                value, code = line[1:].split()
                self._changes[code].append((time, value))

    def find(self, suffix: str) -> str:
        """Full name of the unique signal whose name ends with `suffix`."""
        hits = [n for n in self._names if n == suffix or n.endswith("." + suffix)]
        if len(hits) != 1:
            raise KeyError(f"{suffix!r} matches {len(hits)} signals: {hits[:5]}")
        return hits[0]

    def changes(self, name: str) -> list[tuple[int, str]]:
        return self._changes[self._names[self.find(name)]]

    def at(self, name: str, time: int) -> str:
        changes = self.changes(name)
        i = bisect.bisect_right(changes, (time, "￿")) - 1
        return changes[i][1] if i >= 0 else "U"

    def edges(self, name: str, rising: bool = True) -> list[int]:
        target = "1" if rising else "0"
        out, previous = [], None
        for t, v in self.changes(name):
            if v == target and previous is not None and previous != target:
                out.append(t)
            previous = v
        return out
