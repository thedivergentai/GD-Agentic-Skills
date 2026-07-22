# Phase 0 — Game Audit & Simulation Plan

**Goal:** Before writing any balancer code, produce a written plan that maps the specific game onto the abstract simulation model. The quality of the balancer is capped by the quality of this audit. Never skip it, even for games you think you understand.

## Step 1 — Identify the game

Read the project README, main scene, and entry-point scripts. Answer in writing:

- **Genre & core loop**: What does the player *do* second-to-second? (place towers, aim, dodge, sneak, click, wait?)
- **Session shape**: What is one "run"? (a level/shift, a wave set, an endless survival, a roguelike floor?)
- **Win condition**: What ends a run in victory? (survive N waves, reach exit, boss kill, timer?)
- **Fail condition**: What ends it in defeat? (base HP = 0, player death, detection, timeout?)
- **Score/grading**: Stars, ranks, percentages? What thresholds? (e.g. 3★ above 80% HP, 2★ above 40%, 1★ for surviving.)

## Step 2 — Inventory the modes

List every playable mode (story, endless, challenge, deadline, strike, daily, etc.). For each:

- Entry requirements / unlock conditions
- Rule deltas vs. the base mode (spawn multipliers, timers, restrictions)
- Rewards (currency type, amounts, first-clear vs. repeat)
- Where its rules live in source (file + pattern, e.g. `rules.<field> = value` inside `match Kind.X:` blocks)

Modes matter because real players rotate between them to grind — the simulator must be able to play them too.

## Step 3 — Inventory the content catalog

Build a table of every content class and instance: weapons, traps, towers, enemies, items, upgrades, consumables, barricades/bases, levels.

For each class record:
- **Source of truth**: exact file(s) and the code pattern that defines instances (factory functions, resource files, `profile.field = value` blocks, exported vars).
- **Fields that affect balance**: damage, fire rate, ammo, heat, cost, HP, speed, reward, duration, radius, etc.
- **Unlock/acquisition path**: free, shop purchase, level-clear unlock, drop.

## Step 4 — Map the influence graph

List everything that can influence a run's outcome, and where each is defined:

- Difficulty curves (per-wave enemy count, speed, HP scaling — often inline formulas like `1.0 + (a + b * level_id)`)
- Player-controlled inputs (loadout choice, upgrades, trap placement, active abilities, fault-clearing minigames)
- Random elements (spawn pools + weights, drop timing, crit rolls)
- Engine constants (projectile speeds, lane geometry, slot positions, cooldowns)

Every node in this graph must be either extracted (Phase 1) or explicitly declared out-of-scope with justification.

## Step 5 — Map the economy

- **Currencies**: list each (soft cash within a run, meta coins/stars, premium). For each: all sources (kill rewards, wave bonuses, clear rewards, replay rewards, mode payouts) and all sinks (in-run upgrades, traps, shop purchases, unlocks).
- **Shops**: every purchasable item, price, and prerequisite. Build the full price ladder sorted by intended acquisition order.
- **Replay incentives**: What does replaying a cleared level pay? Is it flat, decayed, or best-score-delta? (Exploit check: `coins = stars × 100` per repeat clear is a farm.)
- **Grind expectations**: How many minutes should a casual player need between shop purchases? Get or set a design target now — you will validate it in Phase 4.

## Step 6 — Platform & Input Audit

**First Question:** *"Does this game ship on mobile at all?"*
If the answer is **no** (desktop-only game), mark mobile input/session machinery out-of-scope for this game and proceed with `mouse` as the sole input model.

If the answer is **yes** (cross-platform or mobile-only):
- **Target platforms & primary inputs**: Which platforms does the game ship on (PC / mobile / both)? What is the primary input model (`mouse`, `touch`, `gamepad`)?
- **Input-sensitive mechanics**: Identify mechanics requiring precise aiming, drag placement, fast tapping minigames, small hit targets, or simultaneous multi-point interactions (impossible with one thumb).
- **UI geometry & occlusion**: Are interactive elements in thumb-reach zones? Do fingers occlude critical play area elements during faults or minigames?
- **Session expectations**: What is the target session length per platform (e.g. mobile target session = 3–7 min)? Does a single level/run fit inside one session?
- **Interruption tolerance**: What happens on app backgrounding (notification, incoming call, app switch) — does the game auto-pause, continue running in the background, or disconnect/penalize?

## Step 7 — Enumerate playstyles

Start from the four canonical styles (afk, casual, average, pro) and add **game-specific** styles the mechanics afford. Every playstyle must be crossed with each shipped input model (e.g., `PlayStyle × InputModel`).

Canonical/generic playstyles:
- **afk** (minimal input, idle/baseline)
- **casual** (relaxed play, slower reaction, higher miss rate)
- **average** (typical player, standard reactions and strategy)
- **pro** (near-optimal play, fast reactions, strong strategy)

Mobile-specific playstyle candidates:
- **commuter** (short sessions, frequent interruptions, plays one-handed)
- **thumb-pro** (high skill within touch constraints — the mobile skill ceiling)

Other genre/mechanic specific playstyles:
- **stealth** (avoids combat, slower, fewer kills, different reward profile)
- **rusher** (speed over safety, skips pickups)
- **grinder** (replays old content for currency before advancing)
- **hoarder** (never spends until forced)
- **pacifist / no-upgrade** (challenge styles worth validating for feasibility)

For each style, decide the parameter values for the `PlayStyle` struct (reaction mean/sigma, taps per second, lapse chance, miss chance, spend behavior — see `02-simulation-engine.md`) and the target win-rate band (see SKILL.md table). A style with no defined band cannot produce a verdict.

## Step 8 — Write the extraction plan

For every data source found in Steps 2–5, write one line:

```text
<what> ← <file> ← <pattern>  e.g.
Weapon profiles      ← gameplay/combat/weapon_profile.gd   ← factory blocks `profile.<field> = <value>`
HP wave scaling      ← gameplay/waves/wave_spawner.gd      ← regex `1\.0 \+ \(([\d.]+) \+ ([\d.]+) \* _definition\.id\)`
Mode rules           ← ui/main_menu/main_menu.gd           ← `rules.(\w+) = (.+)` inside `Kind\.(\w+):` sections
Shop prices          ← ui/store/store.gd                   ← catalog entries / constants
Trap slot unlocks    ← core/progression/level_progress.gd  ← `TRAP_SLOT_UNLOCK_LEVELS: Array[int] = [...]`
Touch/input params   ← ui/hud/hud.gd                       ← button size constants, drag thresholds, pause behavior
```

This table becomes the spec for `extract.rs`.

## Step 9 — Confirm the plan

Present the audit (genre, modes, content tables, influence graph, economy map, platform input & session model, playstyle list with bands, extraction plan) to the user/designer before coding. Ask specifically about:
- Target win-rate bands per style × input model cell (accept defaults only if unchallenged)
- Target session length and interruption policy per platform (e.g. 3–7 min session on mobile, pause behavior)
- Target grind minutes/sessions between shop purchases
- Which modes/content are in scope for this pass

## Deliverable

A `BALANCE_PLAN.md` in the tool directory containing all of the above. The simulator implementation in Phases 1–5 must not silently deviate from it.

