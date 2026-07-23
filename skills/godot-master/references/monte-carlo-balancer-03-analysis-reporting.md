# Phase 3 — Analysis, Verdicts & Reporting (`analysis.rs`)

**Goal:** Turn `RunResult`s into designer/agent decisions: CI-aware band verdicts, rich tables, stable JSON.

## Run matrix

```rust
pub fn run_matrix(data, session_ids, loadout_ids, styles, runs, seed) -> Vec<Aggregate>
```

Cartesian product of filters (empty = all sessions / default loadout). `into_par_iter` over jobs; aggregate per cell.

## Aggregation

Per cell: win rate **+ Wilson (or bootstrap) CI**, grade histogram (not just mean), time avg, pressure/fail breakdowns by kind, resource miss/waste, economy averages, feel proxies. Distributions matter: `{3★:500, 0★:500}` vs `{2★:1000}` share a mean and opposite meanings.

## Statistical rigor

### Confidence intervals

For win rate `p̂ = wins/n`, report Wilson score interval at 95% (or bootstrap percentile CI). Apply the CI verdict law below — never point estimates alone.

### Run counts

| Use | Runs / cell | Why |
|-----|-------------|-----|
| Bruteforce search | 100–300 | Noise OK while ranking candidates |
| Working matrix | ≥300 | Overlap-band decisions |
| Sign-off / snapshot | ≥1000 | ⊆-band DoD; false PASS from noise is expensive |

### Worked verdict example

`n=1000`, `wins=820` → `p̂=0.82`. Approximate 95% Wilson CI ≈ `(0.795, 0.843)`. Band for `average` = `(0.70, 0.95)`:

- **Search (overlap):** CI overlaps band → `OK`
- **SignOff (⊆):** CI fully inside band → `OK`
- If instead CI were `(0.68, 0.72)` vs band `(0.70, 0.95)`: Search → `OK` (overlap); SignOff → `TOO_HARD` (not ⊆) — this is why sign-off needs more runs and the stricter rule.

### Regression diffs

Flag when **CIs no longer overlap**, or when `|Δp̂|` exceeds the two-proportion noise gate at the shared seed/`n`. Always include `seed`, `runs`, `game_data_hash` so diffs separate balance changes from extract/sim changes.

Use [../scripts/compare_balance_snapshots.py](../scripts/monte_carlo_balancer_compare_balance_snapshots.py) in CI.

## Bands & verdicts

```rust
fn target_win(style: &str) -> (f64, f64) { /* from Phase 0; single source of truth */ }
fn verdict(ci: (f64, f64), band: (f64, f64), mode: VerdictMode) -> Verdict
```

### CI verdict law (must match SKILL.md)

| Mode | Runs/cell | `OK` when |
|------|-----------|-----------|
| `Search` / working matrix | 100–300 | CI **overlaps** band |
| `SignOff` / DoD / snapshot | ≥1000 | CI **fully ⊆** band |

Otherwise:

- `TOO_HARD` if CI upper < band.low
- `TOO_EASY` if CI lower > band.high
- `INCONCLUSIVE` if n too low for the band width (prefer more runs over guessing)

Level / session passes SignOff only when **all** styles are `OK` under ⊆ simultaneously (under the Phase 0 primary metric).

### Secondary checks (first-class)

| Check | Fail meaning |
|-------|----------------|
| afk win% ≈ pro win% (CIs overlap tightly) | Player actions don't matter — dead agency |
| Pro always max grade | No mastery ceiling |
| Losses cluster on one wave/kind | Curve discontinuity / single-enemy failure mode |
| Resource-empty downtime dominates losses | Starvation disguised as difficulty |

## Human-readable report

Fixed-width table per cell + anomaly callouts (front-loaded loss spike, starvation, single-kind failure). Same philosophy for `inspect` and mode reports.

## JSON (agent / CI)

Global `--json` → serde pretty aggregates. Stable field names per [json-schema.md](monte-carlo-balancer-json-schema.md). Always include `seed`, `runs`, `game_data_hash`.

## Regression workflow

1. After accepted balance: save `balance-lab --json simulate --runs 1000` under `tools/balance_snapshots/`.
2. After content/code change: same seed, diff with `compare_balance_snapshots.py`.
3. Keep snapshots in VCS beside the game.

## Signature → cause (activation)

| Signature | Likely cause |
|-----------|--------------|
| afk ≈ pro | Agency dead |
| High win%, low grades | Unavoidable chip / pressure |
| Losses at one wave | Curve step / elite unlock |
| Empty-resource downtime dominates | Economy starvation |
| Pro 100% + max grade always | No ceiling left |
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
