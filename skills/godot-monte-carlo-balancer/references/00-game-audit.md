# Phase 0 — Game Audit & Simulation Plan

**Goal:** Before writing any balancer code, produce a written plan that maps the game onto the abstract simulation model. Balancer quality is capped by audit quality. Never skip it.

## Step 1 — Fill the abstract model

Copy into `BALANCE_PLAN.md` and fill every row (delete subsystems with no mapping):

| Abstraction | This game | Source of truth (file / Resource) |
|-------------|-----------|-----------------------------------|
| Session | | |
| Threat | | |
| Defense / agency | | |
| Faults | | |
| Resources | | |
| In-run economy | | |
| Meta economy | | |
| Grade | | |

Also answer: genre & second-to-second verb; win/fail conditions; score/grade thresholds.

## Step 2 — Inventory modes

For each playable mode (story, endless, challenge, daily, …): entry/unlock rules, rule deltas vs base, rewards (first-clear vs repeat), source location. Modes are grind organs — the sim must play them.

## Step 3 — Content catalog

Table every content class (weapons, enemies, items, upgrades, levels, …):

- **Source of truth**: prefer `.tres` / `Resource` class; note factory `.gd` only if no Resource exists.
- **Balance fields**: damage, rate, cost, HP, speed, reward, …
- **Acquisition**: free, shop, unlock, drop.

If the project still hardcodes numbers in scripts, **stop**: apply `godot-resource-data-patterns` (+ economy/combat Resources) before building a regex farm. Extraction should ride a data layer, not fossilize spaghetti.

## Step 4 — Influence graph

List every node that can change a run outcome (curves, loadout, RNG pools, engine constants). Each node is either extracted (Phase 1) or explicitly out-of-scope with justification.

## Step 5 — Economy map

Currencies (sources + sinks), shop price ladder, replay incentives (flat / decay / best-delta), grind-minute targets between meaningful purchases. Exploit smell: `coins = stars × N` every clear.

## Step 6 — Playstyles & primary metric

Start from afk / casual / average / pro; add game-specific styles (stealth, rusher, grinder, pacifist). For each: `PlayStyle` behavioral params (not outcome knobs) + target band.

**Primary metric** (Phase 0 decision):

| Game type | Typical primary metric |
|-----------|------------------------|
| PvE session (default) | Win rate per style |
| Idle / incremental | Minutes-to-milestone bands |
| Educational | ~70% success / flow target (`godot-genre-educational`) |
| Fighting / PvP | Matchup matrix / MMR — **not** AFK→pro win% |
| Roguelike | Win rate vs meta-upgrade level; runs-to-first-win |

Default SKILL.md win-rate table applies only when Phase 0 keeps win% as primary.

## Step 7 — Extraction plan

One line per data source:

```text
<what> ← <path> ← <technique>
Weapon DPS        ← res://data/weapons/*.tres     ← serde/.tres section parse
HP wave scaling   ← gameplay/waves/spawner.gd     ← regex coefficients (inline only)
Shop prices       ← res://data/shop/*.tres        ← Resource fields
```

This becomes the `extract.rs` spec. Prefer Resource paths; regex only where formulas are embedded in code.

## Step 8 — Confirm with designer

Present audit before coding. Lock: bands/metrics, grind minutes, in-scope modes/content, calibration tolerance for Phase 7 (±5–10pp default).

## Deliverable

`BALANCE_PLAN.md` in the tool directory. Phases 1–7 must not silently deviate from it.
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
