---
name: godot-monte-carlo-balancer
description: "Use when designing, auditing, or recalibrating game balance: build a source-driven, high-performance Monte Carlo balance simulator (Rust + rayon) for ANY game (lane defense, tower defense, roguelike, stealth, idle, RTS), simulate real human playstyles (AFK, casual, average, pro, stealth, grinder), tune level difficulty, economy, shops, currency flow, replay rewards, dopamine loops, and interest curves. Keywords: balance lab, Monte Carlo, win rate, difficulty curve, level design, economy tuning, playstyle simulation, GDScript parser, rayon, bruteforce tuning, career simulation."
---

# Monte Carlo Game Balancer

## Overview

This skill teaches you to **write a bespoke, source-driven Monte Carlo balance simulator for a specific game** — not to run a prebuilt tool. The reference architecture (Balance Lab) is a native Rust CLI that:

1. **Extracts** live game data by dynamically parsing the game's source (e.g. `.gd` profiles, constants, and embedded formulas) at every run — zero config files, zero manual sync.
2. **Simulates** thousands of full playthroughs at frame/tick resolution, as if a human is actually playing — with reaction delays, attention lapses, missed pickups, shopping decisions, trap placement, upgrades, and mode grinding.
3. **Analyzes** win rates, star distributions, downtime, leaks, economy flow, and grind timelines against explicit per-playstyle target bands, and emits verdicts (`TOO HARD` / `OK` / `TOO EASY`) plus machine-readable JSON.
4. **Tunes and generates**: bruteforces parameter candidates, generates new levels/weapons/content, and validates every candidate by simulation before accepting it.

The current reference targets a Godot 4.x lane-defense game, but the architecture is genre-agnostic. **Always start with the Game Audit (Phase 0)** to map the target game onto the abstract model before writing any code.

## The Iron Law: Source-Extracted, Zero Config

The simulator must never contain hand-copied game numbers. All profiles, constants, curves, prices, and formulas are parsed from the game's actual source at startup. If a designer changes one line of GDScript, the very next simulation reflects it. This is what makes recalibration seamless when content is added or changed.

## Workflow (execute phases in order)

> **MANDATORY**: Read the linked reference file before implementing each phase. Do not improvise the architecture.

### Phase 0 — Game Audit & Simulation Plan → [references/00-game-audit.md](references/00-game-audit.md)
Before writing a single line of the balancer: identify the genre and core loop, win/fail conditions, all game modes, the full content catalog (weapons, traps, enemies, items, upgrades), every currency and its sources/sinks, the shops, meta progression and unlocks, replay incentives, and which source files are the ground truth for each. Enumerate the playstyles the game actually affords (AFK, casual, average, pro — plus game-specific ones like stealth, rusher, grinder, pacifist). Produce a written plan and confirm it against the source tree before Phase 1.

### Phase 1 — Source Extraction Layer → [references/01-source-extraction.md](references/01-source-extraction.md)
Build the dynamic parser (`extract.rs`): regex-driven extraction of typed profiles, constants, and embedded formulas from game scripts, with project-root discovery and an `inspect` command that prints everything extracted so a human can verify the parser before trusting any simulation.

### Phase 2 — Simulation Engine → [references/02-simulation-engine.md](references/02-simulation-engine.md)
Build the typed model (`model.rs`) and the frame-level simulator (`sim.rs`): entity state machines, parameterized `PlayStyle` structs with human-imperfection modeling (log-normal reaction delays, lapses, miss chances, budget fractions), deterministic seeded RNG, and rayon parallelism across independent jobs.

### Phase 3 — Analysis, Verdicts & Reporting → [references/03-analysis-reporting.md](references/03-analysis-reporting.md)
Build `analysis.rs`: the level × style × loadout run matrix, aggregation into rich metrics, per-style target win-rate bands with verdicts, human-readable table reports, and `--json` output for agent pipelines and regression diffs.

### Phase 4 — Economy, Retention & Dopamine Loop → [references/04-economy-retention.md](references/04-economy-retention.md)
Model the full economic life of a player: currency earn rates per minute per mode, shop price ladders, career/grind timelines ("how many minutes to afford item X"), replay reward decay, farming-exploit detection, interest-curve shape, and dopamine-loop checkpoints.

### Phase 5 — Tuning, Bruteforce & Content Generation → [references/05-tuning-generation.md](references/05-tuning-generation.md)
Build `generate.rs` and the tuning commands: bruteforce search over parameter candidates scored against target bands, level/content generators whose output is validated by simulation before acceptance, and the recalibration workflow for when content changes.

### Phase 6 — Genre & Engine Adaptation → [references/06-genre-adaptation.md](references/06-genre-adaptation.md)
Map the abstract model (Threats, Defenses, Faults, Resources, Economy, Session) onto other genres — stealth, roguelike, idle, RTS, platformer — and onto non-Godot engines. Read this whenever the target game is not lane defense.

## Templates

### [templates/Cargo.toml](templates/Cargo.toml)
Proven dependency set and aggressive release profile (`lto = "fat"`, `codegen-units = 1`) for instantaneous simulation throughput.

### [templates/launcher.ps1](templates/launcher.ps1) / [templates/launcher.sh](templates/launcher.sh)
Self-rebuilding launchers: detect when any `.rs` source or the manifest is newer than the release binary, rebuild automatically, and forward all arguments. Designers and agents never think about compilation.

## CLI Contract (adapt names to the game, keep the shape)

```text
balance-lab inspect                                  # print ALL extracted data — verify parser first
balance-lab simulate --level 3 --style average --runs 1000
balance-lab simulate --runs 300                      # full matrix: every level × default styles
balance-lab career --style casual --runs 200         # whole-progression grind timeline
balance-lab mode <key> --runs 500                    # secondary game modes
balance-lab bruteforce --level 4 ...                 # parameter search scored by target bands
balance-lab gen-level / gen-weapon / gen-trap ...    # generate + simulate-validate content
balance-lab mode-tune ...                            # tune mode progression curves
balance-lab --json <any command>                     # machine-readable output for agents
balance-lab --seed 42 <any command>                  # reproducible runs
```

## Target Difficulty Bands (default; tune per game in Phase 0)

| Style   | Win-rate target | Verdict below | Verdict above |
|---------|-----------------|---------------|---------------|
| afk     | 5% – 55%        | TOO HARD      | TOO EASY      |
| casual  | 55% – 90%       | TOO HARD      | TOO EASY      |
| average | 70% – 95%       | TOO HARD      | TOO EASY      |
| pro     | 90% – 100%      | TOO HARD      | —             |

A level is only `OK` when **every** simulated style lands inside its band. Difficulty must come from the level curve, not from punishing input speed alone.

## NEVER Do (Expert Balancer Rules)

### Data & Extraction
- **NEVER hardcode game numbers in the simulator** — HP, prices, cooldowns, curves, and formulas must be parsed from source at runtime. Hardcoded copies rot silently and every balance conclusion becomes a lie.
- **NEVER trust the parser without `inspect`** — Always implement and run an `inspect` command that dumps every extracted profile, constant, and formula. Verify against the source before the first simulation.
- **NEVER let extraction fall back to silent defaults** — If a regex misses, either fail loudly or flag the defaulted field in `inspect` output. A silently-defaulted enemy HP invalidates the whole matrix.
- **NEVER parse only data files and skip embedded formulas** — Difficulty curves often live inline in code (`1.0 + (a + b * level_id)`). Extract the coefficients with targeted regexes; do not re-derive the formula by hand.

### Simulation Fidelity
- **NEVER simulate only optimal play** — A game balanced solely against frame-perfect play is unplayable for humans. Every matrix must include the weakest realistic style (AFK/idle) and the strongest (pro).
- **NEVER model humans as instantaneous** — Every player action gets a reaction delay (log-normal: mean + sigma), a lapse chance with extra delay, and a miss chance. Tap/interaction rates get jitter.
- **NEVER skip the meta-game in simulation** — Real players shop, upgrade, place traps, grind secondary modes, and replay for rewards. If the sim never spends currency, the economy is unvalidated.
- **NEVER use unseeded or thread-order-dependent RNG** — Derive every run's seed as `seed_for(base, &[level_id, stable_hash(style), stable_hash(loadout), run_index])`. Results must be identical regardless of rayon scheduling. Keep a unit test asserting seed-determinism.
- **NEVER parallelize by mutating shared state** — Structure work as independent `(level, style, loadout)` jobs, `into_par_iter().map(...)` over them, aggregate afterwards. Each job owns its `SmallRng`.

### Judging Balance
- **NEVER judge a level by a single average** — Report win rate, star/score histograms, time distributions, downtime, leak counts by enemy kind, and resource ratios. A 50% win rate can hide a coin-flip or a skill cliff.
- **NEVER run fewer than ~300 runs per cell for decisions** — Use 1000+ for final sign-off. Monte Carlo noise at low run counts produces false verdicts.
- **NEVER declare a level mathematically winnable without checking resource flow** — Compute DPS vs HP-influx AND ammo/energy income vs consumption. A level can be theoretically beatable but starved (the classic unwinnable-level bug).
- **NEVER balance difficulty and economy separately** — Difficulty nerfs change clear times, which change currency/minute, which breaks shop pacing. Every difficulty change requires re-running the career simulation.
- **NEVER fix an exploit by over-nerfing without re-checking progression** — After nerfing a farm (e.g. replay coins), verify shop items are still reachable within acceptable grind minutes. Over-nerf is as fatal as the exploit.

### Tuning & Maintenance
- **NEVER tune one level in isolation** — After any change, re-run the full matrix and the career timeline. Local fixes create global spikes in the interest curve.
- **NEVER accept generated content without simulation validation** — `gen-level`/`gen-weapon` output must be simulated across all styles and land in target bands before it is written into the game.
- **NEVER compare results across code changes without re-extracting** — The extractor runs at startup, so never cache `GameData` across game-source edits.
- **NEVER make designers compile manually** — Ship the self-rebuilding launcher. Friction kills iteration, and stale binaries produce stale conclusions.
- **NEVER report only to stdout when agents consume results** — Always support `--json` with stable field names so AI agents and CI can diff regressions.

## Definition of Done (per balancing engagement)

1. `inspect` output verified line-by-line against game source.
2. Seed-determinism test passes; same seed ⇒ identical aggregates.
3. Full matrix (all levels × all styles, ≥1000 runs/cell) — every cell `OK`.
4. All modes simulated; currency/minute per mode within design targets; no dominant farm.
5. Career simulation: every shop item reachable within target grind time; interest curve has no dead plateau and no spike.
6. Regression JSON snapshot saved so the next content change can be diffed.
