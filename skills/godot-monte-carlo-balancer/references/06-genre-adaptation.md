# Phase 6 — Genre & Engine Adaptation

**Goal:** Reuse the same architecture for any game. The reference implementation is lane defense, but every piece — extraction, playstyles, seeded Monte Carlo, bands, economy careers, bruteforce — is genre-agnostic once you map the abstractions.

## The abstract model

| Abstraction | Lane defense reference | Generalization |
|---|---|---|
| **Session** | One shift (wave sequence) | Any bounded attempt: a floor, a heist, a race, a hand, an idle prestige cycle |
| **Threat pressure** | Enemy waves vs barricade HP | Anything that pushes toward the fail state: guard suspicion, timer, hunger, incoming damage |
| **Defense/agency** | Weapon + traps + upgrades | The player's counter-pressure levers: abilities, positioning, deck, build |
| **Faults** | Jams/overheat minigames | Attention taxes: reloads, stamina, cooldowns, alarms, QTEs |
| **Resources** | Ammo/supplies/heat | Any consumable flow: mana, fuel, oxygen, time, inventory |
| **In-run economy** | Cash → traps/upgrades | Gold → items, XP → level-ups, scrap → crafting |
| **Meta economy** | Stars → store | Unlocks, permanent upgrades, cosmetics, prestige currency |
| **Grade** | Stars by HP remaining | Rank, time, score, style points |

In Phase 0, fill this table for the target game. If a row has no mapping, that subsystem is simply absent — delete it from the model rather than simulating a vestigial mechanic.

## Genre notes

### Stealth
- Fail-state pressure = detection/suspicion meter; simulate patrol schedules and the player's route as a graph traversal with per-style `route_optimality`, `patience` (wait vs risk), and `panic_reaction` parameters.
- The `stealth` playstyle vs `rusher` vs `ghost` (zero detections) replaces afk→pro as the primary style axis; keep afk-like "sloppy" style as the floor.
- Grade = detections + time + collectibles; economy often = gadget shop between missions — career sim unchanged.

### Roguelike / run-based
- The career simulation IS the main loop: run → meta currency → permanent upgrades → next run. Model per-run RNG (item pools, floor layouts) inside `simulate_run`; model build synergies as multiplicative modifiers extracted from item definitions.
- Key outputs: win rate vs meta-upgrade level (the "power creep schedule"), runs-to-first-win distribution per style, and dead-item detection (items whose pick never moves win rate).

### Idle / incremental
- Simulation is almost pure economy: income curves, wall-time to milestones, prestige-loop return-on-reset. Timestep can be coarse (seconds→minutes). Playstyles differ in check-in frequency (`afk` is literally the core audience) and spend policy.
- Verdicts are pacing-based: minutes-to-next-meaningful-purchase bands instead of win-rate bands.

### RTS / lane battler (PvE)
- Threat = scripted AI build orders (extract them!); agency = player build order policies per style. Simulate at coarse ticks with Lanchester-style combat resolution, calibrated once against a few scripted engine battles.

### Action / platformer
- Hardest to simulate at input level; simulate at *encounter granularity*: per-encounter success probability as a function of style skill parameters and encounter stats, calibrated from playtest data if available. Monte Carlo over encounter chains still yields level-level win rates, grind, and economy — which is what balancing needs.

## Engine adaptation (extraction layer only)

Only `extract.rs` and the launcher are engine-specific; `model/sim/analysis/generate` never touch the engine.

| Engine | Data location | Technique |
|---|---|---|
| Godot | `.gd` scripts, `.tres` resources, `project.godot` | Regex factory-blocks + constants (see 01); `.tres` are INI-like — parse sections |
| Unity | `ScriptableObject` .asset YAML, C# constants | YAML parse (serde_yaml) + regex for C# `const` |
| Unreal | DataTables (CSV/JSON exports), Blueprints | Prefer exported CSV/JSON via serde; Blueprint-only data ⇒ ask for a data-export step |
| Custom/JSON-driven | JSON/TOML/CSV data files | Direct serde deserialization — the ideal case |
| Web/JS | TS/JS config objects | Regex or a quick `node -e "console.log(JSON.stringify(...))"` dump step |

Root discovery marker changes per engine (`project.godot`, `*.uproject`, `Assets/`, `package.json`); keep the env-var override.

## What never changes

- Source-extraction as the single source of truth, verified via `inspect`.
- Parameterized `PlayStyle` structs with human-imperfection modeling.
- Seeded determinism (`seed_for` + `stable_hash`) and rayon job-level parallelism.
- Target bands per style, full-matrix verdicts, JSON snapshots, regression diffs.
- Economy careers, replay-income vs frontier-income analysis, interest-curve checks.
- Bruteforce tuning scored against bands; generation validated by simulation.
