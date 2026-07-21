# Phase 3 — Analysis, Verdicts & Reporting (`analysis.rs`)

**Goal:** Turn thousands of `RunResult`s into decisions a designer (or an AI agent) can act on immediately: per-cell verdicts against explicit target bands, rich human-readable tables, and stable JSON for pipelines.

## The run matrix

```rust
pub fn run_matrix(data, level_ids, weapon_ids, styles, runs, seed, slots) -> Vec<Aggregate>
```

- Build the cartesian product of requested levels × styles × loadouts as a flat `jobs` vec; empty filters mean "all levels" / "default loadout for that level".
- Loadout defaults must mirror real progression (`default_loadout`), including slot caps derived from unlock constants (`1 + unlock_levels.iter().filter(|&&x| x < level.id).count()`).
- `into_par_iter()` over jobs; aggregate each cell.

## Aggregation

`aggregate(&results, ...) -> Aggregate` computes, per cell: win rate, star average **and star histogram**, time avg, jams/overheats avg, fault + empty downtime, `fault_every_seconds`, shots/ammo/supplies-missed averages, HP-left avg, hits avg, leaked avg **and leaks_by_kind**, defeated avg, coins (new-best vs replay) averages, upgrades/traps-placed averages, cash-end avg, avg heat, time-to-first-fault. `ModeAggregate` adds `coins_per_minute` and `loss_time_avg`.

Distributions matter: a star histogram of `{3: 500, 0: 500}` and `{2: 1000}` have the same average and opposite meanings (coin-flip vs consistent mediocrity).

## Target bands and verdicts

```rust
fn target_win(style: &str) -> (f64, f64) {
    match style {
        "afk"     => (0.05, 0.55),
        "casual"  => (0.55, 0.90),
        "average" => (0.70, 0.95),
        "pro"     => (0.90, 1.01),
        _         => (0.60, 0.95),
    }
}
fn verdict(win_rate, style) -> "TOO HARD" | "TOO EASY" | "OK"
```

- Bands come from Phase 0; codify them in one function so bruteforce scoring and reports agree.
- A level passes only when **all** styles are `OK` simultaneously.
- Optionally add secondary verdict inputs: pro star-avg (pro should usually 3★), afk-vs-pro spread (if afk ≈ pro, player agency is dead; if the spread is huge, the game is twitch-gated).

## Human-readable report

`print_simulation_report(aggs)`: one banner + a fixed-width table, one row per cell:

```text
LVL WEAPON              STYLE    WIN% STARS  TIME  JAM  OVH  FDOWN  EDOWN  LEAK  HITS  COINS  CASH  VERDICT
```

Follow the table with anomaly callouts, not just raw numbers, e.g.:
- `WARN L3/average: 41% of losses occur before wave 2 (front-loaded spike)`
- `WARN L4: empty_downtime 18s avg — ammo starvation, not difficulty`
- `WARN L2 leaks dominated by 'charging' (73%) — single-enemy failure mode`

`print_inspect(data)` and `print_mode_report(...)` follow the same philosophy: everything a human needs to *see* the state, nothing they must compute themselves.

## JSON output (agent integration)

Global `--json` flag switches every command's output to `serde_json` pretty-printed aggregates (`json_pretty(&aggs)`).

- Keep field names stable across versions; agents and CI diff them.
- Include the seed, run count, and a `game_data_hash` (stable hash of the extracted `GameData` JSON) so any diff can distinguish "balance changed" from "you changed the sim".

## Regression workflow

1. After every accepted balance state, save `balance-lab --json simulate --runs 1000` output as a snapshot (e.g. `tools/balance_snapshots/<date>.json`).
2. After any content/code change: re-run with the same seed and diff. Win-rate deltas > ~3pp in untouched levels are regressions to investigate — usually a shared constant or curve changed.
3. Keep snapshots in version control next to the game so balance history travels with code history.

## Interpreting common signatures

| Signature | Likely cause | Check |
|---|---|---|
| afk win% ≈ pro win% | Player actions don't matter | fault downtime impact, trap/upgrade effect sizes |
| High win% but low stars everywhere | Chip damage unavoidable | leak sources, early-wave pressure |
| Losses cluster at one wave | Curve discontinuity (elite unlock, speed step) | per-wave loss histogram |
| `empty_downtime` dominates losses | Economy/ammo starvation, not combat difficulty | supply cadence vs consumption |
| `time_to_first_fault` < warmup time | Fault pacing punishes before player is settled | jam counter constants |
| Pro 100% + 3★ always | No mastery ceiling left | tighten star thresholds or add pressure |
