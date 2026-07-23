# Phase 5 — Tuning, Bruteforce & Content Generation

**Goal:** Close the loop — search fixes and propose content, accepting only simulation-validated candidates in the project's real data shape.

## Bruteforce (`bruteforce`, `mode-bruteforce`)

```rust
pub struct LevelBruteforceOptions<'a> { /* level id, which fields to vary, ranges/steps, styles, input_models, runs, seed */ }
pub fn bruteforce_level(data: &GameData, options: LevelBruteforceOptions)
```

Design rules:

1. Vary **1–3** parameters at a time; coarse grid then refine.
2. Score vs **all** `style × input_model` bands (distance from band centers) + penalties: grade degeneracy, downtime dominance, single-kind failure concentration, economy drift (clear-time → currency/minute), and **platform gap penalty** (`max(0, mouse_win_rate - touch_win_rate - 0.12)`). A candidate that fixes desktop but widens the mouse-vs-touch gap fails.
3. Simulate all styles and shipped input models for every candidate — fixing `average@mouse` while dropping `average@touch` to 30% fails.
4. Search at 100–300 runs; re-validate winner at ≥1000 before recommend.
5. Print ranked shortlist as **exact source edits** in the project's truth format (Resource field / `.tres` / GDScript assignment).

`tune_mode_progression(...)` follows the same pattern for mode curves — search so each level's mode win rates stay in band across all shipped input models.

## Content generation

```rust
pub struct GeneratedLevel { /* candidate + LevelValidation */ }
pub fn generate_level(data, /* id, target profile, constraints */) -> GeneratedLevel
pub fn generate_weapon(...) -> GeneratedWeapon
pub fn generate_trap(data, id, name, unlock) -> (Trap, String)
```

### Generation procedure

1. Fit curves to existing catalog (regress balance fields vs progression index). New content starts on-curve, then identity via deliberate trade-offs.
2. Respect influence graph & platform limits: unlock-gated pools, one new element per session when designing levels. Generated mechanics must respect the touch tap-rate cap (`taps_per_second_cap` e.g. 7.0/sec) and support `simultaneous_actions = 1` for one-hand play.
3. Validate with full `style × input_model` matrix; bounded retries; report aggregates with the candidate.
4. Emit the project's data shape (see table below).

### Emit the project's data shape

| Project truth | Generator output |
|---------------|------------------|
| `.tres` / Resources | Write `.tres` (or JSON dump the editor imports) |
| CSV→`.tres` pipeline | Emit CSV row matching designer sheet |
| GDScript factories only | Emit factory block **only if** Phase 0 confirmed no Resource layer |

**NEVER** paste `.gd` factories into a Resource-first project. Prefer `godot-resource-data-patterns` shapes.

## Recalibration (content changed)

1. `inspect` — extractor sees the change; nothing else moved unexpectedly.
2. `simulate --runs 1000` full matrix across all shipped input models + diff snapshot (`compare_balance_snapshots.py`).
3. If the change touches any input-sensitive mechanic (tap minigame, drag placement, target sizes), re-run touch cells at 1000+ runs even if desktop cells look unchanged.
4. Triage intended vs collateral; classify: intended vs collateral (shared constants, curve interactions, platform gap widening).
5. `bruteforce` collateral cells without reverting the new content or widening the mouse-vs-touch platform gap.
6. Modes + `career` for casual & average — verify economy, session length caps, and grind targets still hold.
7. Phase 7 spot-check if physics/AI-heavy systems moved.
8. Save new snapshot; summarize before/after win rates per cell across input models.

## Level-from-scratch

Define role on interest curve + target bands → generate → review texture metrics (leaks by kind, downtime, time-to-first-fault, touch platform gap) — not just band OK → write source → `inspect` → full matrix including neighbors → `career` to confirm progression pacing and session caps.
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
