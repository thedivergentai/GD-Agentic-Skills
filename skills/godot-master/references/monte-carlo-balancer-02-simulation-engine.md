# Phase 2 — Simulation Engine

**Goal:** Frame/tick Monte Carlo that plays like a human — imperfect reaction, lapses, spend policy — fast enough for thousands of runs/sec via rayon.

Lane-defense field names: [example-lane-defense.md](monte-carlo-balancer-example-lane-defense.md) only.

## Typed world (`model.rs`)

One serializable struct per Phase 0 content class + `EngineConstants` (extracted coeffs). `Serialize` everything. `IndexMap` when report order must match source. Lookups by stable id.

**Must record in `RunResult` (adapt names):** outcome + grade, time, pressure/fail broken down by kind, resource income/waste/miss, economy spend/end/meta earned, feel proxies (peak pressure, time-to-first-fault). Win/lose alone is not enough.

## `PlayStyle` — behavior only

Parameters are **behavior**, never encoded win-rate: reaction mean/sigma, action rate + jitter, lapse chance/extra, opportunity miss, spend policy (`spends`, budget fraction, cash reserve). Extend per game (`route_optimality`, idle check-in hours, …). Keep afk→pro monotonic; game-specific styles are extra rows.

Delays: **log-normal** (always positive, heavy right tail) + optional lapse extra.

## Sim loop

Fixed timestep matching the game tick when possible. Pure update slices from the abstract model (spawn threat → agency → faults → resources → economy → finalize). No globals/I/O in updates.

## Determinism (non-negotiable)

```text
stable_hash(text)          # FNV/xxhash — NEVER HashMap default hasher
seed_for(base, parts)      # mix CLI seed + session + style + loadout + run_index
SmallRng::seed_from_u64(seed) per run
```

Identical CLI seed ⇒ bit-identical aggregates regardless of thread count. Unit-test two runs. Default CLI seed is a **constant**, not wall-clock.

**HashMap hasher landmine:** default hasher is process-randomized → `stable_hash` via `HashMap` keys differs across machines → CI “regressions” that are hash noise.

## Parallelism

Independent jobs only (session × style × loadout). Each job owns RNG. Never share `RunState`.

## Modes & careers

Mode = rule deltas on the same engine. `default_loadout` mirrors unlocks (no god-loadouts). Career chains sessions + shop + optional mode grind (Phase 4).

## Performance

Fat LTO release profile from the template. `SmallRng`, preallocated vecs, no formatting in the hot loop. Target: full matrix in seconds on a laptop.
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
