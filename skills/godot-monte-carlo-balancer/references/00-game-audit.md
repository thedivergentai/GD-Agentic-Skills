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

Also answer in writing:

- **Genre & core loop**: What does the player *do* second-to-second?
- **Session shape**: What is one "run"? (level/shift, wave set, endless survival, roguelike floor?)
- **Win condition**: What ends a run in victory?
- **Fail condition**: What ends it in defeat?
- **Score/grading**: Stars, ranks, percentages? What thresholds?

## Step 2 — Inventory modes

For each playable mode (story, endless, challenge, daily, …): entry/unlock rules, rule deltas vs base, rewards (first-clear vs repeat), source location (file + pattern, e.g. `rules.<field> = value` inside `match Kind.X:` blocks). Modes are grind organs — the sim must play them.

## Step 3 — Content catalog

Table every content class (weapons, enemies, items, upgrades, levels, …):

- **Source of truth**: prefer `.tres` / `Resource` class; note factory `.gd` only if no Resource exists.
- **Balance fields**: damage, rate, cost, HP, speed, reward, …
- **Acquisition**: free, shop, unlock, drop.

If the project still hardcodes numbers in scripts, **stop**: apply `godot-resource-data-patterns` (+ economy/combat Resources) before building a regex farm. Extraction should ride a data layer, not fossilize spaghetti.

## Step 4 — Influence graph

List every node that can change a run outcome (curves, loadout, RNG pools, engine constants). Examples: inline HP formulas (`1.0 + (a + b * level_id)`), trap slot unlocks, fault minigame constants. Each node is either extracted (Phase 1) or explicitly out-of-scope with justification.

## Step 5 — Economy map

Currencies (sources + sinks), shop price ladder, replay incentives (flat / decay / best-delta), grind-minute targets between meaningful purchases. Exploit smell: `coins = stars × N` every clear.

## Step 6 — Platform & Input Audit

**First question:** *"Does this game ship on mobile at all?"*
If **no** (desktop-only), mark mobile input/session machinery out-of-scope and proceed with `mouse` as the sole input model.

If **yes** (cross-platform or mobile-only):

- **Target platforms & primary inputs**: PC / mobile / both? Primary input model (`mouse`, `touch`, `gamepad`)?
- **Input-sensitive mechanics**: precise aiming, drag placement, fast tapping minigames, small hit targets, simultaneous multi-point interactions (impossible with one thumb).
- **UI geometry & occlusion**: interactive elements in thumb-reach zones? fingers occlude critical play area during faults or minigames?
- **Session expectations**: target session length per platform (e.g. mobile = 3–7 min)? Does a single level/run fit inside one session?
- **Interruption tolerance**: app backgrounding (notification, call, app switch) — auto-pause, continue running, or disconnect/penalize?

## Step 7 — Playstyles & primary metric

Start from afk / casual / average / pro; add game-specific styles (stealth, rusher, grinder, pacifist). Every playstyle must be crossed with each shipped input model (`PlayStyle × InputModel`).

Mobile-specific playstyle candidates:

- **commuter** — short sessions, frequent interruptions, plays one-handed
- **thumb-pro** — high skill within touch constraints (mobile skill ceiling)

For each style: `PlayStyle` behavioral params (see `02-simulation-engine.md`) + target band per input model (see SKILL.md table). A style with no defined band cannot produce a verdict.

**Primary metric** (Phase 0 decision):

| Game type | Typical primary metric |
|-----------|------------------------|
| PvE session (default) | Win rate per style × input model |
| Idle / incremental | Minutes-to-milestone bands |
| Educational | ~70% success / flow target (`godot-genre-educational`) |
| Fighting / PvP | Matchup matrix / MMR — **not** AFK→pro win% |
| Roguelike | Win rate vs meta-upgrade level; runs-to-first-win |

Default SKILL.md win-rate table applies only when Phase 0 keeps win% as primary.

## Step 8 — Extraction plan

One line per data source:

```text
<what> ← <path> ← <technique>
Weapon DPS        ← res://data/weapons/*.tres     ← serde/.tres section parse
HP wave scaling   ← gameplay/waves/spawner.gd     ← regex coefficients (inline only)
Mode rules        ← ui/main_menu/main_menu.gd     ← rules.(\w+) inside Kind\.(\w+): sections
Shop prices       ← res://data/shop/*.tres        ← Resource fields
Touch/input params ← ui/hud/hud.gd                ← button size constants, drag thresholds, pause behavior
```

This becomes the `extract.rs` spec. Prefer Resource paths; regex only where formulas are embedded in code.

## Step 9 — Confirm with designer

Present audit before coding. Lock:

- Target win-rate bands per style × input model cell (accept defaults only if unchallenged)
- Target session length and interruption policy per platform (e.g. 3–7 min session on mobile, pause behavior)
- Grind minutes/sessions between shop purchases
- In-scope modes/content
- Calibration tolerance for Phase 7 (±5–10pp default)

## Deliverable

`BALANCE_PLAN.md` in the tool directory containing all of the above. Phases 1–7 must not silently deviate from it.
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
