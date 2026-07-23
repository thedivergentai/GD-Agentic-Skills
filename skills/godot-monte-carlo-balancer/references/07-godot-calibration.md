# Phase 7 — Godot Headless Calibration

**Goal:** The Rust abstract sim is a high-throughput lab, not ground truth for complex physics/AI. Calibrate a few golden cells against headless Godot before full-matrix sign-off.

**Skill Chain:** `godot-testing-patterns` (seeded RNG, N-frame gameplay sim) → `godot-builder` (`GODOT_PATH`, headless CLI).

## When required

- Any Godot project where threat/agency resolution depends on physics, navigation, AnimationTree, or non-trivial AI.
- After large extract/sim refactors.
- Optional skip only if Phase 0 declared the game **fully formulaic** (pure Resource math, no physics) — document the waiver in `BALANCE_PLAN.md`.

## Procedure

1. Pick **3–5 golden cells** (session × style × loadout) spanning easy/mid/hard and weak/strong styles.
2. Implement a headless Godot runner (GUT test or `--script`) that:
   - Seeds RNG the same way the game does in shipping builds.
   - Drives a bot approximating the cell's `PlayStyle` (reaction delay / miss rates as best-effort).
   - Emits win/grade/time JSON compatible with [json-schema.md](json-schema.md) cell fields.
3. Run the abstract sim on the same cells with the same `--seed` and ≥300 runs (1000 preferred).
4. Compare win rates (and key texture metrics if available).

## Pass criteria

| Check | Default tolerance |
|-------|-------------------|
| \|p̂_sim − p̂_godot\| | ≤ 5–10 percentage points (lock in Phase 0) |
| Grade mean / fail-kind ranking | Same ordinal story (not bit-identical) |
| Systematic bias all cells same direction | FAIL — model bug, not noise |

If outside tolerance: fix extract (missed coeff) or sim fidelity before trusting matrix-wide verdicts.

## CLI shape

```text
balance-lab calibrate --cells tools/balance_lab/golden_cells.json --runs 500
# Internally: rust matrix subset + invokes Godot headless; prints delta table + PASS/FAIL
```

## NEVER

- **NEVER** claim “mathematically balanced” from an uncalibrated abstract model of physics-heavy combat.
- **NEVER** require bit-identical Godot vs Rust — require decision-same (bands/tolerance).
- **NEVER** calibrate only the pro style — include a weak style cell.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
- https://docs.godotengine.org/en/stable/classes/class_json.html
- https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — Resource-first extract
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md — Phase 7 headless calibration
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md
-->
