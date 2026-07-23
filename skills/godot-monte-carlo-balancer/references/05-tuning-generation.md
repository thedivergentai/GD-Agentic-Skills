# Phase 5 — Tuning, Bruteforce & Content Generation

**Goal:** Close the loop — search fixes and propose content, accepting only simulation-validated candidates in the project's real data shape.

## Bruteforce (`bruteforce`, `mode-bruteforce`)

1. Vary **1–3** parameters at a time; coarse grid then refine.
2. Score vs **all** style bands (distance from band centers) + penalties: grade degeneracy, downtime dominance, single-kind failure concentration, economy drift (clear-time → currency/minute).
3. Simulate all styles every candidate — fixing `average` while zeroing `afk` fails.
4. Search at 100–300 runs; re-validate winner at ≥1000 before recommend.
5. Print ranked shortlist as **exact source edits** in the project's truth format (Resource field / `.tres` / GDScript assignment).

## Content generation

Fit curves to existing catalog (regress balance fields vs progression index). New content starts on-curve, then identity via deliberate trade-offs. Respect influence graph: unlock-gated pools, one new element per session when designing levels.

Validate with full style matrix; bounded retries; report aggregates with the candidate.

### Emit the project's data shape

| Project truth | Generator output |
|---------------|------------------|
| `.tres` / Resources | Write `.tres` (or JSON dump the editor imports) |
| CSV→`.tres` pipeline | Emit CSV row matching designer sheet |
| GDScript factories only | Emit factory block **only if** Phase 0 confirmed no Resource layer |

**NEVER** paste `.gd` factories into a Resource-first project. Prefer `godot-resource-data-patterns` shapes.

## Recalibration (content changed)

1. `inspect` — extractor sees the change; nothing else moved unexpectedly.
2. `simulate --runs 1000` + diff snapshot (`compare_balance_snapshots.py`).
3. Triage intended vs collateral.
4. `bruteforce` collateral cells without reverting the new content.
5. Modes + `career` for casual & average.
6. Phase 7 spot-check if physics/AI-heavy systems moved.
7. Save new snapshot; summarize before/after.

## Level-from-scratch

Define role on interest curve + target bands → generate → review texture metrics (not just band OK) → write source → `inspect` → full matrix including neighbors → `career`.
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
