#!/usr/bin/env python3
"""Regenerate the README figures from real simulation output.

Runs the few simulations it needs (moving-average CSVs, three waveform dumps),
then draws every figure twice - light and dark - into docs/images/. Nothing in
these figures is hand-drawn data: curves, waveforms and the animation are read
from the RTL simulation results.

    python scripts/make_figures.py
"""

from __future__ import annotations

import csv
import os
import subprocess
import sys
from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402
import numpy as np  # noqa: E402
from matplotlib import animation  # noqa: E402
from matplotlib.patches import FancyBboxPatch  # noqa: E402

ROOT = Path(__file__).resolve().parents[1]
IMAGES = ROOT / "docs" / "images"
WAVES = ROOT / "build" / "waves"
SIM_DATA = ROOT / "build" / "sim_data"
sys.path.insert(0, str(ROOT / "scripts"))
from gemm_golden import make_tiles  # noqa: E402
from vcd import Vcd  # noqa: E402

# Reference palette (validated light/dark steps); text never wears series color.
THEMES = {
    "light": dict(surface="#fcfcfb", ink="#0b0b0b", ink2="#52514e", muted="#898781",
                  grid="#e1e0d9", axis="#c3c2b7", idle="#ecebe6",
                  series=["#2a78d6", "#eb6834", "#1baf7a"],
                  lamp_green="#008300", lamp_amber="#eda100", lamp_red="#e34948"),
    "dark": dict(surface="#1a1a19", ink="#f0efec", ink2="#c3c2b7", muted="#898781",
                 grid="#2c2c2a", axis="#383835", idle="#2c2c2a",
                 series=["#3987e5", "#d95926", "#199e70"],
                 lamp_green="#008300", lamp_amber="#c98500", lamp_red="#e34948"),
}
DPI = 144


# ----------------------------------------------------------------------------
# simulation runs
# ----------------------------------------------------------------------------
def simulate() -> None:
    def run(tests: list[str], wave: Path | None = None) -> None:
        env = dict(os.environ)
        if wave:
            env["WAVE"] = str(wave)
        cmd = [sys.executable, str(ROOT / "run.py"), *tests, "-o", str(ROOT / "build" / "vunit_figures")]
        result = subprocess.run(cmd, cwd=ROOT, env=env, capture_output=True, text=True)
        if "All passed!" not in result.stdout:
            sys.exit(f"simulation failed: {' '.join(tests)}\n{result.stdout[-2000:]}")

    WAVES.mkdir(parents=True, exist_ok=True)
    run(["lib.tb_moving_average.taps_8.noisy_sine_wave", "lib.tb_moving_average.taps_32.noisy_sine_wave"])
    run(["lib.tb_uart_tx.fast.single_byte"], WAVES / "uart_tx.vcd")
    run(["lib.tb_traffic_light.short_press_is_served"], WAVES / "traffic.vcd")
    run(["lib.tb_systolic_array.4x4.golden_vectors_bit_exact"], WAVES / "systolic.vcd")


# ----------------------------------------------------------------------------
# shared styling
# ----------------------------------------------------------------------------
def new_figure(th: dict, width: float, height: float, title: str, subtitle: str):
    fig = plt.figure(figsize=(width, height), dpi=DPI, facecolor=th["surface"])
    fig.text(0.02, 0.965, title, ha="left", va="top", fontsize=13, weight="bold", color=th["ink"])
    fig.text(0.02, 0.965 - 0.32 / height, subtitle, ha="left", va="top", fontsize=9.5, color=th["ink2"])
    return fig


def style_axes(ax, th: dict, grid_axis: str = "y") -> None:
    ax.set_facecolor(th["surface"])
    for side in ("top", "right"):
        ax.spines[side].set_visible(False)
    for side in ("left", "bottom"):
        ax.spines[side].set_color(th["axis"])
        ax.spines[side].set_linewidth(0.8)
    ax.tick_params(colors=th["muted"], labelsize=8.5, length=0, pad=6)
    for label in ax.get_xticklabels() + ax.get_yticklabels():
        label.set_color(th["ink2"])
    if grid_axis:
        ax.grid(axis=grid_axis, color=th["grid"], linewidth=0.8, linestyle="-")
        ax.set_axisbelow(True)
    ax.xaxis.label.set_color(th["ink2"])
    ax.yaxis.label.set_color(th["ink2"])


def legend(ax, th: dict, **kwargs):
    leg = ax.legend(frameon=False, fontsize=8.5, labelcolor=th["ink2"], handlelength=1.8, **kwargs)
    return leg


def save(fig, name: str, mode: str) -> None:
    IMAGES.mkdir(parents=True, exist_ok=True)
    fig.savefig(IMAGES / f"{name}_{mode}.png", facecolor=fig.get_facecolor(), dpi=DPI,
                pil_kwargs={"optimize": True})
    plt.close(fig)


def end_labels(ax, th: dict, items: list[tuple[float, float, str]], min_gap: float) -> None:
    """Direct labels at line ends; collisions get nudged apart with a leader line."""
    items = sorted(items, key=lambda it: it[1])
    placed: list[float] = []
    for _, y, _ in items:
        placed.append(y if not placed or y - placed[-1] >= min_gap else placed[-1] + min_gap)
    for (x, y, text), y_label in zip(items, placed):
        ax.annotate(text, xy=(x, y), xytext=(14, (y_label - y) / min_gap * 11), textcoords="offset points",
                    va="center", fontsize=8.5, color=th["ink2"], annotation_clip=False,
                    arrowprops=dict(arrowstyle="-", color=th["axis"], lw=0.8, shrinkA=0, shrinkB=2))


# ----------------------------------------------------------------------------
# 1. moving-average filter
# ----------------------------------------------------------------------------
def read_csv(path: Path) -> dict[str, np.ndarray]:
    with open(path) as f:
        rows = list(csv.DictReader(f))
    return {k: np.array([int(r[k]) for r in rows]) for k in rows[0]}


def fig_moving_average(mode: str) -> None:
    th = THEMES[mode]
    d8 = read_csv(SIM_DATA / "moving_average_taps_8.csv")
    d32 = read_csv(SIM_DATA / "moving_average_taps_32.csv")
    assert np.array_equal(d8["input"], d32["input"]), "both runs must see the same input"

    fig = new_figure(th, 10, 4.3, "Moving-average filter: RTL simulation output",
                     "Noisy 12-bit sine wave in; each output sample is checked bit-exact against a "
                     "reference model. Longer windows smooth more but lag (N - 1)/2 samples.")
    ax = fig.add_axes([0.07, 0.13, 0.82, 0.62])
    style_axes(ax, th)
    n = d8["n"]
    ax.plot(n, d8["input"], color=th["muted"], lw=1, alpha=0.55, label="Noisy input")
    ax.plot(n, d8["output"], color=th["series"][0], lw=2, solid_capstyle="round", label="Output, N = 8")
    ax.plot(n, d32["output"], color=th["series"][1], lw=2, solid_capstyle="round", label="Output, N = 32")
    ax.set_xlim(0, n[-1])
    ax.set_xlabel("Sample", fontsize=9)
    ax.set_ylabel("Amplitude (12-bit signed)", fontsize=9)
    legend(ax, th, loc="lower left", bbox_to_anchor=(0, 1.0), ncol=3)
    span = d8["input"].max() - d8["input"].min()
    end_labels(ax, th, [(n[-1], d8["output"][-1], "N = 8"), (n[-1], d32["output"][-1], "N = 32")],
               min_gap=span * 0.08)
    save(fig, "moving_average", mode)


# ----------------------------------------------------------------------------
# 2. systolic-array utilization
# ----------------------------------------------------------------------------
def fig_utilization(mode: str) -> None:
    th = THEMES[mode]
    fig = new_figure(th, 10, 4.3, "Systolic array: utilization vs. reduction depth K",
                     "A tile takes K + R + C - 1 cycles - checked cycle-exact by the testbench for every "
                     "golden tile - so short dot products are dominated by pipeline fill and drain.")
    ax = fig.add_axes([0.07, 0.13, 0.84, 0.62])
    style_axes(ax, th)
    k = np.logspace(0, 10, 400, base=2)
    sizes = [(4, 4), (8, 8), (16, 16)]
    for (r, c), color in zip(sizes, th["series"]):
        u = 100 * k / (k + r + c - 1)
        ax.plot(k, u, color=color, lw=2, solid_capstyle="round", label=f"{r} x {c} array")
        # the curves converge at large K: labels sit in the right margin, spread
        # downward in curve order, each tied to its curve end by a leader line
        y_label = 97 - 8 * sizes.index((r, c))
        ax.annotate(f"{r} x {c}", (k[-1], u[-1]), xytext=(k[-1] * 1.35, y_label), textcoords="data",
                    fontsize=8.5, color=th["ink2"], va="center", annotation_clip=False,
                    arrowprops=dict(arrowstyle="-", color=th["axis"], lw=0.8, shrinkA=2, shrinkB=0))
    for (r, c), color in zip(sizes[:2], th["series"]):        # sizes simulated by run.py
        ks = sorted({a.shape[1] for a, _ in make_tiles(r, c, seed=100 * r + c)})
        ks = np.array(ks)
        ax.plot(ks, 100 * ks / (ks + r + c - 1), "o", color=color, markersize=6.5,
                markeredgecolor=th["surface"], markeredgewidth=1.5, zorder=3)
    ax.plot([], [], "o", color=th["ink2"], markersize=6.5, markeredgecolor=th["surface"],
            markeredgewidth=1.5, label="Tile depths in the regression")
    ax.set_xscale("log", base=2)
    ax.set_xticks([1, 4, 16, 64, 256, 1024], ["1", "4", "16", "64", "256", "1024"])
    ax.set_xlim(1, 1024)
    ax.set_ylim(0, 100)
    ax.set_yticks([0, 25, 50, 75, 100], ["0%", "25%", "50%", "75%", "100%"])
    ax.set_xlabel("Reduction depth K (log scale)", fontsize=9)
    ax.set_ylabel("PE utilization", fontsize=9)
    legend(ax, th, loc="lower left", bbox_to_anchor=(0, 1.0), ncol=4)
    save(fig, "systolic_utilization", mode)


# ----------------------------------------------------------------------------
# 3. UART frame
# ----------------------------------------------------------------------------
def step_trace(changes: list[tuple[int, str]], t0: int, t1: int, scale: float):
    """Digital waveform as polyline points between t0 and t1 (recorded data only)."""
    before = [v for t, v in changes if t <= t0]
    value = before[-1] if before else changes[0][1]      # init value holds from time 0
    xs, ys = [0.0], [value == "1"]
    for t, v in changes:
        if t0 < t <= t1:
            xs += [(t - t0) * scale] * 2
            ys += [value == "1", v == "1"]
            value = v
    xs.append((t1 - t0) * scale)
    ys.append(value == "1")
    return xs, [int(y) for y in ys]


def fig_uart(mode: str) -> None:
    th = THEMES[mode]
    w = Vcd(WAVES / "uart_tx.vcd")
    tx = w.changes("tb_uart_tx.tx")
    start = next(t for t, v in tx if v == "0")
    bit = 1_000_000_000                                  # 1 us per bit in the fast configuration (fs)
    t0 = start - bit
    t1 = min(start + 11 * bit, w.end_time)              # recorded data only
    us = 1e-9

    fig = new_figure(th, 10, 3.6, "UART transmitter: one frame of 'H' (0x48) from the RTL",
                     "8N1, LSB first. Start bit, data bits 0-0-0-1-0-0-1-0, stop bit. The testbench "
                     "measures every bit edge to the femtosecond and decodes the byte.")
    ax = fig.add_axes([0.1, 0.12, 0.87, 0.6])
    style_axes(ax, th, grid_axis="")
    rows = [("tx_valid", "tb_uart_tx.tx_valid", 2.8), ("tx_ready", "tb_uart_tx.tx_ready", 1.4),
            ("tx", "tb_uart_tx.tx", 0.0)]
    for name, sig, y0 in rows:
        xs, ys = step_trace(w.changes(sig), t0, t1, us)
        ax.plot(xs, [y0 + 0.9 * y for y in ys], color=th["series"][0] if sig.endswith(".tx") else th["ink2"],
                lw=2 if sig.endswith(".tx") else 1.4, solid_joinstyle="miter")
    ax.set_yticks([y0 + 0.45 for _, _, y0 in rows], [name for name, _, _ in rows], fontsize=9,
                  family="monospace")
    for i, label in enumerate(["start", "D0", "D1", "D2", "D3", "D4", "D5", "D6", "D7", "stop"]):
        left = (start - t0 + i * bit) * us
        ax.axvline(left, color=th["grid"], lw=0.8, zorder=0)
        ax.text(left + 0.5, 1.05, label, ha="center", va="bottom", fontsize=8, color=th["muted"])
    ax.axvline((start - t0 + 10 * bit) * us, color=th["grid"], lw=0.8, zorder=0)
    ax.set_xlim(0, (t1 - t0) * us)
    ax.set_ylim(-0.25, 3.9)
    ax.spines["left"].set_visible(False)
    ax.set_xlabel("Time (us)  -  1 us per bit in this test configuration", fontsize=9)
    save(fig, "uart_frame", mode)


# ----------------------------------------------------------------------------
# 4. traffic light timeline
# ----------------------------------------------------------------------------
def fig_traffic(mode: str) -> None:
    th = THEMES[mode]
    w = Vcd(WAVES / "traffic.vcd")
    period = 20_000_000                                  # 20 ns clock in fs
    release = next(t for t, v in w.changes("tb_traffic_light.arst") if v == "0")
    end = w.changes("tb_traffic_light.car_green")[-1][0] + 4 * period
    rows = [
        ("Push button", "pedestrian_btn", th["ink2"]),
        ("WAIT lamp", "ped_wait", th["series"][0]),
        ("Cars: green", "car_green", th["lamp_green"]),
        ("Cars: orange", "car_orange", th["lamp_amber"]),
        ("Cars: red", "car_red", th["lamp_red"]),
        ("Pedestrians: walk", "ped_green", th["lamp_green"]),
    ]
    fig = new_figure(th, 10, 3.9, "Traffic-light controller: one button press, served",
                     "RTL simulation with phases shortened to clock cycles (minimum green 20, orange 4, "
                     "walk 10). A monitor checks the safety and timing rules on every cycle.")
    ax = fig.add_axes([0.15, 0.15, 0.82, 0.58])
    style_axes(ax, th, grid_axis="x")
    for row, (label, sig, color) in enumerate(rows):
        y = len(rows) - 1 - row
        spans, on_since = [], None
        for t, v in w.changes(f"tb_traffic_light.{sig}"):
            t = min(max(t, release), end)
            if v == "1" and on_since is None:
                on_since = t
            elif v != "1" and on_since is not None:
                spans.append((on_since, t))
                on_since = None
        if on_since is not None:
            spans.append((on_since, end))
        bars = [((a - release) / period, max((b - a) / period, 0.6)) for a, b in spans if b > a]
        ax.broken_barh(bars, (y - 0.3, 0.6), facecolor=color, edgecolor=th["surface"], linewidth=2)
        for x, width in bars:
            if label in ("Cars: orange", "Pedestrians: walk"):
                ax.text(x + width + 0.6, y, f"{width:.0f} cycles", va="center", fontsize=8, color=th["ink2"])
    ax.set_yticks(range(len(rows)), [r[0] for r in reversed(rows)], fontsize=9)
    ax.set_xlim(0, (end - release) / period)
    ax.set_ylim(-0.7, len(rows) - 0.3)
    ax.spines["left"].set_visible(False)
    ax.set_xlabel("Clock cycles after reset", fontsize=9)
    save(fig, "traffic_light", mode)


# ----------------------------------------------------------------------------
# 5. systolic wavefront animation
# ----------------------------------------------------------------------------
def fig_wavefront(mode: str, rows: int = 4, cols: int = 4, tile_index: int = 6) -> None:
    th = THEMES[mode]
    w = Vcd(WAVES / "systolic.vcd")
    pe = "tb_systolic_array.u_dut.gen_row({i}).gen_col({j}).u_pe.{sig}"
    edges = w.edges("tb_systolic_array.clk")
    k_depth = make_tiles(rows, cols, seed=100 * rows + cols)[tile_index][0].shape[1]

    def sampled(sig: str, i: int, j: int) -> list[int]:       # value consumed at each rising edge
        name = pe.format(i=i, j=j, sig=sig)
        return [1 if w.at(name, t - 1) == "1" else 0 for t in edges]

    active = {(i, j): sampled("valid_in", i, j) for i in range(rows) for j in range(cols)}
    firsts = [n for n, f in enumerate(sampled("first_in", 0, 0)) if f and active[(0, 0)][n]]
    c0 = firsts[tile_index]                                    # edge where PE(0,0) starts the tile
    # one tile period (K + R + C - 1 cycles); the next tile may enter right after
    cycles = range(c0 - 1, c0 + k_depth + rows + cols - 1)
    # the animation shows what the RTL did; check it against the systolic schedule
    for (i, j), trace in active.items():
        for n in cycles:
            expected = 0 <= n - c0 - i - j < k_depth
            assert trace[n] == expected, f"PE({i},{j}) cycle {n}: RTL activity differs from schedule"

    fig = plt.figure(figsize=(5.6, 6.0), dpi=100, facecolor=th["surface"])
    fig.text(0.04, 0.97, f"4 x 4 systolic array, one tile (K = {k_depth})", fontsize=12.5, weight="bold",
             color=th["ink"], va="top")
    fig.text(0.04, 0.925, "Each PE does a*b+acc when A (from the left) and B (from the top)\n"
             "meet; colours are read from the RTL simulation.", fontsize=9, color=th["ink2"], va="top")
    ax = fig.add_axes([0.08, 0.1, 0.84, 0.72])
    ax.set_xlim(-0.9, cols + 0.05)
    ax.set_ylim(rows + 0.65, -1.05)
    ax.axis("off")
    cells, texts = {}, {}
    for i in range(rows):
        for j in range(cols):
            box = FancyBboxPatch((j + 0.06, i + 0.06), 0.88, 0.88, boxstyle="round,pad=0,rounding_size=0.08",
                                 facecolor=th["idle"], edgecolor="none")
            ax.add_patch(box)
            cells[(i, j)] = box
            texts[(i, j)] = ax.text(j + 0.5, i + 0.5, "", ha="center", va="center", fontsize=10,
                                    color="#ffffff", weight="bold")
        ax.text(-0.45, i + 0.5, f"A row {i}", ha="center", va="center", fontsize=8, color=th["muted"], rotation=90)
    for j in range(cols):
        ax.text(j + 0.5, -0.25, f"B col {j}", ha="center", va="center", fontsize=8, color=th["muted"])
    status = ax.text(0, -0.75, "", fontsize=10, color=th["ink"], va="center")
    keys = [("idle", th["idle"]), ("multiply-accumulate", th["series"][0]), ("result C(i,j) ready", th["series"][2])]
    for x, (name, color) in zip((0.0, 0.85, 2.65), keys):
        ax.add_patch(FancyBboxPatch((x, rows + 0.25), 0.22, 0.22, boxstyle="round,pad=0,rounding_size=0.04",
                                    facecolor=color, edgecolor="none"))
        ax.text(x + 0.32, rows + 0.36, name, fontsize=8, color=th["ink2"], va="center")

    frames = list(cycles) + [cycles[-1]] * 3                   # hold the final frame
    def draw(n: int):
        for (i, j), box in cells.items():
            k = n - c0 - i - j
            if active[(i, j)][n]:
                box.set_facecolor(th["series"][0])
                texts[(i, j)].set_text(f"k={k}")
            elif k >= k_depth:
                box.set_facecolor(th["series"][2])
                texts[(i, j)].set_text("C")
            else:
                box.set_facecolor(th["idle"])
                texts[(i, j)].set_text("")
        status.set_text(f"cycle {n - c0 + 1:>2} of {k_depth + rows + cols - 1}")
        return [*cells.values(), *texts.values(), status]

    anim = animation.FuncAnimation(fig, draw, frames=frames, blit=False)
    anim.save(IMAGES / f"systolic_wavefront_{mode}.gif", writer=animation.PillowWriter(fps=2))
    plt.close(fig)


def main() -> None:
    simulate()
    for mode in THEMES:
        fig_moving_average(mode)
        fig_utilization(mode)
        fig_uart(mode)
        fig_traffic(mode)
        fig_wavefront(mode)
    for path in sorted(IMAGES.glob("*")):
        print(f"{path.relative_to(ROOT)}  ({path.stat().st_size // 1024} KB)")


if __name__ == "__main__":
    main()
