# Phase 5 — Tuning, Bruteforce & Content Generation (`generate.rs` + tuning commands)

**Goal:** Close the loop: don't just diagnose imbalance — search for fixes and design new content automatically, with every candidate validated by full simulation before it touches the game.

## Bruteforce parameter search (`bruteforce`, `mode-bruteforce`)

```rust
pub struct LevelBruteforceOptions<'a> { /* level id, which fields to vary, ranges/steps, styles, runs, seed */ }
pub fn bruteforce_level(data: &GameData, options: LevelBruteforceOptions)
```

Design rules:

1. **Vary few parameters at a time** (1–3: e.g. `spawn_interval`, `hp_bonus`, `enemy_count_step`). Full grids explode; use coarse steps first, then refine around the best cell.
## Bruteforce parameter search (`bruteforce`, `mode-bruteforce`)

```rust
pub struct LevelBruteforceOptions<'a> { /* level id, which fields to vary, ranges/steps, styles, input_models, runs, seed */ }
pub fn bruteforce_level(data: &GameData, options: LevelBruteforceOptions)
```

Design rules:

1. **Vary few parameters at a time** (1–3: e.g. `spawn_interval`, `hp_bonus`, `enemy_count_step`). Full grids explode; use coarse steps first, then refine around the best cell.
2. **Score against the bands, not a single metric.** A candidate's score = distance of every `style × input_model` cell win rate from its target band center, weighted, plus penalties for: star-histogram degeneracy, downtime dominance, leak concentration on one enemy kind, economy drift (clear-time change alters coins/minute), and **platform gap penalty** (`max(0, mouse_win_rate - touch_win_rate - 0.12)`). A candidate that fixes desktop but widens the mouse-vs-touch gap fails.
3. **Simulate all styles and shipped input models for every candidate** — a candidate that fixes `average@mouse` but drops `average@touch` to 30% fails.
4. **Reduced run counts while searching** (100–300), then re-validate the winner at full runs (1000+) before recommending.
5. **Output a ranked shortlist with exact source edits**: print the candidate values in the same form they appear in the game source (`lvl.spawn_interval = 1.15`) so applying the fix is copy-paste; the extractor guarantees the next run reflects it.

`tune_mode_progression(...)` follows the same pattern for mode curves (e.g. deadline timer per level: `target_time = base + level_id * step` — search `base`/`step` so each level's mode win rates stay in band across all shipped input models).

## Content generation (`gen-level`, `gen-weapon`, `gen-trap`)

```rust
pub struct GeneratedLevel { /* candidate + LevelValidation */ }
pub fn generate_level(data, /* id, target profile, constraints */) -> GeneratedLevel
pub fn generate_weapon(...) -> GeneratedWeapon
pub fn generate_trap(data, id, name, unlock) -> (Trap, String) // returns ready-to-paste GDScript too
```

### Generation procedure

1. **Fit curves to existing content.** Regress each balance-relevant field against progression index from the extracted catalog (e.g. enemy HP vs level id, weapon DPS vs unlock tier, trap cost vs power). New content starts ON the fitted curve, then gets its identity from deliberate trade-offs (high damage ⇔ low magazine; cheap trap ⇔ short duration).
2. **Respect the influence graph & platform limits.** A new level picks its enemy pool from what's unlocked, introduces exactly one new element, and inherits curve coefficients interpolated between neighbors. Generated mechanics must respect the touch tap-rate cap (`taps_per_second_cap` e.g. 7.0/sec) and support `simultaneous_actions = 1` for one-hand play.
3. **Validate by simulation** (`LevelValidation`): run the full `style × input_model` matrix on the candidate; iterate (bounded retries with adjusted parameters) until all cells land in band; report the final aggregates alongside the candidate.
4. **Emit source, not just JSON.** Generate the exact GDScript block (factory function / level definition) matching the game's existing code patterns, so the designer pastes it in and the extractor immediately picks it up.

## Recalibration workflow (when content changes)

Run this whenever a weapon/enemy/trap/mode/economy value changes or new content lands:

1. `inspect` — confirm the extractor sees the change (and nothing else moved unexpectedly).
2. `simulate --runs 1000` full matrix across all shipped input models with the standard seed — diff against the saved JSON snapshot.
3. If the change touches any input-sensitive mechanic (tap minigame, drag placement, target sizes), re-run touch cells at 1000+ runs even if desktop cells look unchanged.
4. Triage every cell that left its band; classify: intended (the change) vs collateral (shared constants, curve interactions, platform gap widening).
5. For collateral damage: `bruteforce` the affected level's local parameters to bring it back in band **without** reverting the new content or widening the mouse-vs-touch platform gap.
6. `mode --runs 500` for all modes + `career` for casual & average — verify economy, session length caps, and grind targets still hold.
7. Save the new snapshot. Summarize: what changed, what was retuned, before/after win rates per cell across input models.

## Level-design-from-scratch workflow

1. Define the level's role in the interest curve (breather? spike? new-mechanic showcase?) and its target bands (may deviate from defaults intentionally — a breather can target casual 80–95%).
2. `gen-level` with those targets; review the candidate's aggregates AND texture metrics (leaks by kind, downtime, time-to-first-fault, touch platform gap) — numbers in band with degenerate texture (all threat from one enemy) still need manual pool/weight edits.
3. Paste emitted source into the game; `inspect`; full-matrix re-run including neighboring levels (a new level changes the career economy for everything after it).
4. `career` to confirm progression pacing and session caps with the new level inserted.

