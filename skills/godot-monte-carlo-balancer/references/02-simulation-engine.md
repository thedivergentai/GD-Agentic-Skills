# Phase 2 — Simulation Engine (`model.rs` + `sim.rs`)

**Goal:** A frame-level Monte Carlo simulator that plays the game the way a *human* plays it — imperfectly, with reaction time, lapses, shopping decisions, and style-specific habits — fast enough to run thousands of playthroughs per second via rayon.

Lane-defense field names: [example-lane-defense.md](example-lane-defense.md) only.

## `model.rs` — the typed world

Define plain serializable structs for every content class discovered in Phase 0:

```rust
pub struct EngineConstants { /* every extracted constant + formula coefficient */ }
pub struct Weapon { pub id: String, pub damage: i32, pub fire_interval: f64, /* ... */ }
pub struct Enemy  { /* hp, speed, reward, attack, kind, elite flag ... */ }
pub struct Trap   { /* cost, damage, duration/uses, slot rules ... */ }
pub struct Level  { pub id: i32, pub title: String, /* waves, pools, curves, barricade ... */ }
pub struct GameMode { pub key: String, /* rule deltas vs base game */ }

pub struct GameData {
    pub weapons: Vec<Weapon>, pub enemies: Vec<Enemy>, pub traps: Vec<Trap>,
    pub levels: Vec<Level>, pub modes: Vec<GameMode>, pub constants: EngineConstants,
}
// + lookup helpers: weapon(id), enemy_index(key), trap_index(id), level(id), mode(key)
// + inspect_json() for the inspect command
```

Everything is `Serialize` so `--json` output is free. Use `IndexMap` (with the `serde` feature) wherever iteration order should match source order (stable reports, stable diffs).

## `PlayStyle` & `InputModel` — the heart of human simulation

A simulated human player is defined by the composition of a **`PlayStyle`** (skill and behavioral habits) and an **`InputModel`** (hardware/platform interaction constraints): `PlayStyle × InputModel` (e.g. `casual@touch`, `pro@mouse`). Default input model is `mouse`.

```rust
pub struct PlayStyle {
    pub name: &'static str,
    // Reaction to faults/alarms (jams, overheats, detection, alerts)
    pub fault_reaction_mean: f64,   // seconds before the player starts responding
    pub fault_reaction_sigma: f64,
    pub taps_per_second: f64,       // interaction speed once responding
    pub tap_jitter: f64,
    pub lapse_chance: f64,          // probability the player is distracted
    pub lapse_extra: f64,           // extra seconds when lapsed
    // Pickup / opportunity handling (supplies, drops, objectives)
    pub supply_reaction_mean: f64,
    pub supply_reaction_sigma: f64,
    pub supply_miss_chance: f64,    // probability of ignoring it entirely
    pub collect_only_when_low: bool,
    // Economic behavior inside a run
    pub places_traps: bool,
    pub trap_budget_fraction: f64,  // share of cash willing to spend on traps
    pub buys_upgrades: bool,
    pub upgrade_cash_reserve: i32,  // never spend below this buffer
}
```

Canonical reference values (tune per game; keep the monotonic ordering afk → pro):

| param | afk | casual | average | pro |
|---|---|---|---|---|
| fault_reaction mean/sigma | 2.6 / 0.9 | 1.1 / 0.5 | 0.65 / 0.3 | 0.38 / 0.15 |
| taps_per_second / jitter | 3.0 / 0.35 | 5.0 / 0.3 | 7.0 / 0.22 | 9.5 / 0.15 |
| lapse chance / extra | 0.5 / 2.5 | 0.22 / 1.4 | 0.12 / 0.9 | 0.04 / 0.5 |
| supply reaction mean/sigma | 2.6 / 0.8 | 1.6 / 0.6 | 1.1 / 0.4 | 0.75 / 0.25 |
| supply_miss_chance | 0.55 | 0.22 | 0.10 | 0.03 |
| collect_only_when_low | yes | yes | no | no |
| places_traps / budget | no / 0.0 | yes / 0.5 | yes / 0.7 | yes / 0.85 |
| buys_upgrades / reserve | no / 0 | yes / 60 | yes / 45 | yes / 30 |

Parameters are **behavior**, never encoded win-rate — never encode "wins more" directly. Extend per game (`route_optimality`, idle check-in hours, …). Game-specific styles are extra rows.

### `InputModel` struct

Platform interaction parameters separate platform constraints from player skill:

```rust
pub struct InputModel {
    pub name: &'static str,          // "mouse", "touch", "gamepad"
    pub taps_per_second_cap: f64,    // hard ceiling regardless of style
    pub tap_accuracy_sigma: f64,     // spatial error; drives fat-finger misses
    pub fat_finger_miss_chance: f64, // tap lands on wrong/no target
    pub occlusion_penalty: f64,      // extra reaction delay while finger covers the screen
    pub drag_speed_mult: f64,        // drag/placement actions slower on touch
    pub simultaneous_actions: u32,   // mouse=2 (mouse+kb), one-thumb touch=1
    pub reaction_mult: f64,          // multiplier on style reaction means
}
```

Canonical input model defaults:

| param | mouse | touch (two thumbs) | touch (one hand) |
|---|---|---|---|
| taps_per_second_cap | 12.0 | 7.0 | 4.5 |
| fat_finger_miss_chance | 0.01 | 0.06 | 0.10 |
| occlusion_penalty | 0.0 | 0.15 | 0.25 |
| drag_speed_mult | 1.0 | 0.75 | 0.6 |
| simultaneous_actions | 2 | 2 | 1 |
| reaction_mult | 1.0 | 1.1 | 1.25 |

**Effective behavior composition**:
- `effective_tps = min(style.taps_per_second, input.taps_per_second_cap)`
- `effective_reaction = style.fault_reaction_mean * input.reaction_mult + input.occlusion_penalty`
- Every tap rolls `fat_finger_miss_chance`; on miss, a retry delay is added.

**Canonical mobile rows**: ship default combos `afk@touch`, `casual@touch`, `average@touch`, `pro@touch(two-thumb)`, `commuter@touch(one-hand)`.

### `SessionModel` struct (mobile interruption modeling)

Mobile play is short and fragmented. The session model tracks session length caps and interruptions:

```rust
pub struct SessionModel {
    pub session_length_cap_mean: f64,     // e.g. 300.0s (5 min)
    pub interruption_rate_per_min: f64,   // e.g. 0.2 (one interruption per 5 min)
    pub interruption_duration_mean: f64, // e.g. 15.0s
    pub interruption_duration_sigma: f64,
    pub pauses_game_on_interruption: bool, // extracted from Phase 0 audit
}
```

During an interruption, the player performs zero actions. If `pauses_game_on_interruption` is `false`, this becomes a pure vulnerability window where enemies advance/attack freely.

Add game-specific styles from Phase 0 (stealth, rusher, grinder, commuter, thumb-pro…) as more rows, and extend the struct with new behavioral axes when the game affords them (e.g. `avoids_combat: bool`, `route_optimality: f64`).

Human delays are sampled log-normally so they are always positive and occasionally bad:

```rust
fn human_delay(rng: &mut SmallRng, mean: f64, sigma: f64) -> f64 // LogNormal-based
// On each fault: delay = human_delay(mean, sigma) + if rng.gen_bool(lapse_chance) { lapse_extra } else { 0.0 }
```

## `sim.rs` — the frame-level run

Simulate with a fixed timestep (match the game's tick where possible, e.g. `1.0 / 60.0`, or a coarser `0.05 s` if profiling shows it does not change outcomes). One run = one `RunState` mutated by small, testable update functions:

```rust
fn update_spawning(...)              // wave curves, weighted enemy pools
fn update_supplies(..., style, input_model, ...)  // pickup spawns + human reaction/miss/touch model
fn update_cooling_and_clearing(...)  // fault minigames: jam clearing, heat venting
fn update_firing(...)                // targeting, ammo, heat, jam counters
fn update_projectiles_and_traps(...) // travel, hits, trap triggers/expiry
fn update_enemies(...)               // movement, attacks, leaks, barricade damage
fn update_interruptions(..., session_model, ...) // mobile notifications / backgrounding
fn maybe_buy_upgrade(..., style, ..) // style-gated economic decisions
fn place_story_traps / refill_mode_traps(..., style, ..) // slot & budget logic
fn kill_enemy(...) / finalize(...)   // rewards, bookkeeping
```

Keep every function a pure mutation of `RunState` + `RunResult` given `GameData` — no globals, no I/O. This makes the sim trivially parallel and unit-testable.

### RunResult — record everything

Collect far more than win/lose; analysis needs texture:

```rust
pub struct RunResult {
    pub win: bool, pub stars: i32, pub time: f64,
    pub barricade_hp: i32, pub barricade_max: i32, pub barricade_hits: i32,
    pub waves_cleared: i32, pub enemies_defeated: i32, pub enemies_leaked: i32,
    pub leaks_by_kind: IndexMap<String, i32>,
    pub jams: i32, pub overheats: i32, pub fault_downtime: f64, pub empty_downtime: f64,
    pub shots_fired: i32, pub ammo_collected: i32, pub ammo_wasted: i32,
    pub supplies_spawned: i32, pub supplies_collected: i32, pub supplies_missed: i32,
    pub cash_end: i32, pub upgrades_bought: i32, pub traps_placed: i32,
    pub coins_new_best: i32, pub coins_replay: i32, pub challenge_coins: i32,
    pub peak_heat_ratio: f64, pub avg_heat_ratio: f64, pub time_to_first_fault: f64,
    pub fat_finger_misses: i32, pub interruptions: i32, pub interruption_downtime: f64,
    pub actions_dropped_by_occlusion: i32,
}
```

Adapt field names to the game, but always cover: outcome + grade, time, damage taken/dealt, failure-pressure metrics (downtime, leaks by kind), resource flow (income, waste, misses), economy (spend, end balance, meta-currency earned), "feel" proxies (peak/avg pressure, time to first fault), and mobile metrics (fat-finger misses, interruptions, occlusion drops).

## Determinism (non-negotiable)

```rust
pub fn stable_hash(text: &str) -> u64            // FNV/xxhash-style, no HashMap default hasher
pub fn seed_for(base: u64, parts: &[u64]) -> u64 // mix base + parts (splitmix64-style)

// per job:  base = seed_for(cli_seed, &[level.id, stable_hash(style.name), stable_hash(input_model.name), stable_hash(weapon.id)])
// per run:  seed = seed_for(base, &[run_index])
// each run: SmallRng::seed_from_u64(seed)
```

- Identical CLI seed ⇒ bit-identical aggregates, regardless of thread count or scheduling.
- Keep a unit test: run the same simulation twice with the same seed and `assert_eq!` the results (`story_simulation_is_seed_deterministic`).
- Default the CLI seed to a constant (not time!) so ad-hoc runs are comparable; let `--seed` override.

**HashMap hasher landmine:** default hasher is process-randomized → `stable_hash` via `HashMap` keys differs across machines → CI "regressions" that are hash noise.

## Parallelism with rayon

Parallelize across **independent jobs** (level × style × input model × loadout cells), each of which runs its N seeded runs sequentially:

```rust
jobs.into_par_iter().map(|(li, wi, style, input_model)| {
    let results: Vec<RunResult> = (0..runs).map(|i| simulate_run(..., seed_for(base, &[i as u64]))).collect();
    aggregate(&results, ...)
}).collect::<Vec<Aggregate>>()
```

If a single cell is requested with a huge run count, parallelize the inner loop instead (`(0..runs).into_par_iter()`) — safe because each run derives its own seed. Never share `RunState` or RNG across runs.

## Mode runs and careers

- `simulate_mode_run(...)`: same engine, mode rule deltas applied (timers, spawn multipliers, restricted loadouts, different reward function).
- `default_loadout(data, level_id)`: reproduce the game's own "what would a player own here" logic (purchases unlocked so far) so matrix runs use realistic gear, not god-loadouts.
- Career simulation (see `04-economy-retention.md`) chains runs: play level → earn → shop → maybe grind modes → next level, all driven by the same `PlayStyle` and `InputModel` within the player's `SessionModel`.

## Performance checklist

- Release profile from `scripts/balance-lab-template/Cargo.toml` (`opt-level = 3`, `lto = "fat"`, `codegen-units = 1`).
- `SmallRng`, preallocated `Vec`s in `RunState`, swap-remove for dead entities, no per-frame allocation.
- No string formatting inside the hot loop; aggregate first, print once.
- Target: a full matrix (5 levels × 4 styles × 2 input models × 1000 runs) in seconds on a laptop. If slower, profile before adding approximations.
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
