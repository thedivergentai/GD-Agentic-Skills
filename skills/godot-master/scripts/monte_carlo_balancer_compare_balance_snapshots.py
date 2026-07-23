#!/usr/bin/env python3
"""Diff two balance-lab --json simulate snapshots (CI-friendly).

Usage:
  python compare_balance_snapshots.py baseline.json current.json
  python compare_balance_snapshots.py baseline.json current.json --threshold 0.03
  python compare_balance_snapshots.py baseline.json current.json --require-ci-overlap

Exit 0 if no regressions; 1 if deltas exceed threshold / CI non-overlap; 2 on usage error.
"""
from __future__ import annotations

import argparse
import json
import math
import sys
from pathlib import Path
from typing import Any


def load(path: Path) -> dict[str, Any]:
    data = json.loads(path.read_text(encoding="utf-8-sig"))
    if "cells" not in data:
        raise ValueError(f"{path}: missing 'cells'")
    return data


def cell_key(cell: dict[str, Any]) -> tuple[Any, Any, Any]:
    return (cell.get("session_id"), cell.get("style"), cell.get("loadout_id"))


def two_prop_se(p1: float, n1: int, p2: float, n2: int) -> float:
    if n1 <= 0 or n2 <= 0:
        return float("inf")
    return math.sqrt(p1 * (1.0 - p1) / n1 + p2 * (1.0 - p2) / n2)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("baseline", type=Path)
    parser.add_argument("current", type=Path)
    parser.add_argument(
        "--threshold",
        type=float,
        default=0.03,
        help="Absolute win_rate delta that flags a regression (default 0.03)",
    )
    parser.add_argument(
        "--z",
        type=float,
        default=1.96,
        help="Z for two-proportion noise gate (default 1.96)",
    )
    parser.add_argument(
        "--require-ci-overlap",
        action="store_true",
        help="Also fail when win_rate CIs no longer overlap",
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="Allow mismatched seed/runs/schema_version",
    )
    args = parser.parse_args()

    try:
        base = load(args.baseline)
        cur = load(args.current)
    except (OSError, ValueError, json.JSONDecodeError) as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 2

    for field in ("schema_version", "seed", "runs"):
        if base.get(field) != cur.get(field) and not args.force:
            print(
                f"error: {field} mismatch baseline={base.get(field)!r} "
                f"current={cur.get(field)!r} (pass --force to override)",
                file=sys.stderr,
            )
            return 2

    base_map = {cell_key(c): c for c in base["cells"]}
    cur_map = {cell_key(c): c for c in cur["cells"]}

    regressions: list[str] = []
    for key, b in sorted(base_map.items(), key=lambda kv: str(kv[0])):
        c = cur_map.get(key)
        if c is None:
            regressions.append(f"MISSING {key}")
            continue
        p1 = float(b["win_rate"])
        p2 = float(c["win_rate"])
        n1 = int(b.get("n") or base.get("runs") or 0)
        n2 = int(c.get("n") or cur.get("runs") or 0)
        delta = p2 - p1
        se = two_prop_se(p1, n1, p2, n2)
        noise_gate = args.z * se
        meaningful = abs(delta) >= args.threshold and abs(delta) > noise_gate

        ci_fail = False
        if args.require_ci_overlap:
            b_lo, b_hi = b.get("win_rate_ci_low"), b.get("win_rate_ci_high")
            c_lo, c_hi = c.get("win_rate_ci_low"), c.get("win_rate_ci_high")
            if None not in (b_lo, b_hi, c_lo, c_hi):
                ci_fail = float(c_hi) < float(b_lo) or float(b_hi) < float(c_lo)

        verdict_changed = b.get("verdict") != c.get("verdict")
        if meaningful or ci_fail or verdict_changed:
            regressions.append(
                f"{key}: Δwin={delta:+.4f} "
                f"({p1:.4f}->{p2:.4f}) noise_gate={noise_gate:.4f} "
                f"verdict {b.get('verdict')}->{c.get('verdict')}"
            )

    for key in cur_map:
        if key not in base_map:
            regressions.append(f"NEW {key}")

    if base.get("game_data_hash") != cur.get("game_data_hash"):
        print(
            f"note: game_data_hash changed "
            f"{base.get('game_data_hash')!r} -> {cur.get('game_data_hash')!r}"
        )

    if not regressions:
        print("OK: no balance regressions above threshold")
        return 0

    print("REGRESSIONS:")
    for line in regressions:
        print(f"  {line}")
    return 1


if __name__ == "__main__":
    sys.exit(main())
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/classes/class_json.html
# - https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — Resource-first extract
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md — Phase 7 headless calibration
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md
# =============================================================================
