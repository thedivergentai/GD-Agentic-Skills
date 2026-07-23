---
name: godot-monte-carlo-balancer
description: "Use when auditing or recalibrating game balance: build a source-driven Monte Carlo balance lab (Rust + rayon) that extracts live game data, simulates human playstyles (AFK→pro), emits win-rate/economy verdicts with confidence intervals, and bruteforce-tunes parameters. Trigger on unfair levels, unreachable shops, farm exploits, interest-curve cliffs, post-content recalibration, or CI balance JSON diffs. Keywords: balance lab, Monte Carlo, win rate, difficulty curve, economy career, playstyle simulation, Resource extraction, GDScript parser, bruteforce tuning."
---

## Godot 4.7 Baseline

- Patterns assume **Godot 4.7+** projects; prefer `.tres` / Resources as the extract truth layer (Godot 4.x Resource pipelines).

# Monte Carlo Game Balancer

Build a **bespoke, source-driven Monte Carlo balance lab** for one game — not a prebuilt tool. Reference architecture: Rust CLI + rayon that extracts `GameData`, simulates imperfect humans, verdicts with CIs, tunes by simulation, and calibrates against headless Godot.

**Always Phase 0 first.** Lane-defense field names are **not** the default model.

## Skill Chain

```text
godot-resource-data-patterns → godot-economy-system →
  (godot-combat-system | godot-rpg-stats | godot-game-loop-waves) →
  godot-monte-carlo-balancer → godot-testing-patterns → godot-builder
```

## The Iron Law: Source-Extracted, Zero Config

No hand-copied numbers in the sim. Parse Resources / source at startup so the next run reflects designer edits.

## Abstract Model (mandatory Phase 0)

| Abstraction | Meaning | If absent |
|-------------|---------|-----------|
| Session | Bounded attempt | — |
| Threat | Pressure toward fail | delete |
| Defense / agency | Player levers | delete |
| Faults | Attention taxes | delete |
| Resources | Consumable flow | delete |
| In-run economy | Session spend | delete |
| Meta economy | Shop / unlocks / prestige | delete |
| Grade | Stars / rank / time / score | delete |

Write `BALANCE_PLAN.md`. Simulate only mapped rows.

## Progressive disclosure

> **MANDATORY**: Read the linked reference before implementing that phase.
>
> **Do NOT Load**:
> - `example-lane-defense.md` — unless Phase 0 maps to lane-defense / shift TD
> - `06-genre-adaptation.md` — unless genre ≠ default PvE win%-band session
> - `07-godot-calibration.md` — only when starting calibration **or** Phase 0 did **not** waive physics/AI (waiver = fully formulaic math-only game, documented in `BALANCE_PLAN.md`)

### Phase 0 — Audit → [references/00-game-audit.md](monte-carlo-balancer-00-game-audit.md)
Genre, win/fail, modes, catalog, influence graph, economy, styles + **primary metric**, extraction plan. Confirm with designer.

### Phase 1 — Extract → [references/01-source-extraction.md](monte-carlo-balancer-01-source-extraction.md)
Resource-first decision tree; `inspect` before any simulate.

### Phase 2 — Sim → [references/02-simulation-engine.md](monte-carlo-balancer-02-simulation-engine.md)
Behavioral `PlayStyle`, seeded `SmallRng`, rayon over independent jobs.

### Phase 3 — Analyze → [references/03-analysis-reporting.md](monte-carlo-balancer-03-analysis-reporting.md)
Wilson/bootstrap CI verdicts; secondary agency checks; stable JSON.

### Phase 4 — Economy → [references/04-economy-retention.md](monte-carlo-balancer-04-economy-retention.md)
Careers, farms, interest curve, reward-cadence checkpoints.

### Phase 5 — Tune → [references/05-tuning-generation.md](monte-carlo-balancer-05-tuning-generation.md)
Band-scored bruteforce; emit `.tres` when the project is Resource-first.

### Phase 6 — Genre → [references/06-genre-adaptation.md](monte-carlo-balancer-06-genre-adaptation.md)
Metric overrides + Domain Skill chains.

### Phase 7 — Calibrate → [references/07-godot-calibration.md](monte-carlo-balancer-07-godot-calibration.md)
3–5 golden cells vs headless Godot before full-matrix sign-off (unless waived).

## Bundled Resources

Canonical layout after copy:

```text
tools/
  balance_lab.ps1          # from launcher.ps1
  balance_lab.sh           # from launcher.sh
  balance_lab/
    Cargo.toml
    src/main.rs            # clap stubs — expand per Phase 0
```

### [scripts/balance-lab-template/](../scripts/monte_carlo_balancer_balance_lab_template_Cargo.toml)
Copy `Cargo.toml` + `src/` into `tools/balance_lab/`. Place launchers as `tools/balance_lab.ps1` / `tools/balance_lab.sh` (siblings of the crate dir).

### [scripts/compare_balance_snapshots.py](../scripts/monte_carlo_balancer_compare_balance_snapshots.py)
CI-aware snapshot diff.

### [references/json-schema.md](monte-carlo-balancer-json-schema.md)
Stable `--json` field contract.

## CLI Contract

```text
balance-lab inspect
balance-lab simulate --level 3 --style average --runs 1000
balance-lab career --style casual --runs 200
balance-lab mode <key> --runs 500
balance-lab bruteforce --level 4 ...
balance-lab gen-level ...
balance-lab calibrate --cells golden.json
balance-lab --json <any command>
balance-lab --seed 42 <any command>
```

## Target Bands (default; Phase 0 overrides)

| Style   | Win-rate target | Below → | Above → |
|---------|-----------------|---------|---------|
| afk     | 5% – 55%        | TOO HARD | TOO EASY |
| casual  | 55% – 90%       | TOO HARD | TOO EASY |
| average | 70% – 95%       | TOO HARD | TOO EASY |
| pro     | 90% – 100%      | TOO HARD | — |

### CI verdict law (single source of truth)

| Mode | Runs/cell | `OK` rule |
|------|-----------|-----------|
| Search / working | 100–300 | 95% CI **overlaps** band; else TOO_HARD / TOO_EASY / INCONCLUSIVE |
| Sign-off / DoD / snapshot | ≥1000 | 95% CI **fully ⊆** band for **every** style |

Fighting / educational / idle often replace win% — set primary metric in Phase 0. Difficulty from content curve, not input-speed punishment alone.

## NEVER Do

### Data & Extraction
- **NEVER hardcode game numbers or skip existing Resources / `.tres`** — hand copies rot into false conclusions; regex farms on Resource projects fight the data layer. Resource-first; regex only for inline formula coefficients. Flag every `(default!)` in `inspect` before the first simulate.
- **NEVER skip embedded formulas** — extract coefficients; one reimplementation in sim. Shape change must fail the regex loudly.

### Simulation Fidelity
- **NEVER simulate only optimal play** — a pro-only PASS ships an unplayable floor; AFK/casual failures are the bug players feel.
- **NEVER model humans as instantaneous** — zero-delay agents clear jam/fault windows real players miss; difficulty collapses into twitch gates.
- **NEVER skip meta-game** — omit shop/upgrades/modes/replay → “balanced” sessions with broken careers.
- **NEVER use unseeded or `HashMap`-hashed seed paths** — default hasher is process-randomized → false CI diffs across machines/rayon schedules; use `seed_for` + stable hash; unit-test determinism.
- **NEVER share `RunState`/RNG across rayon jobs** — cross-talk masquerades as balance noise and breaks reproducibility.
- **NEVER claim mathematical balance from an uncalibrated physics/AI model** — Phase 7 or documented waiver; abstract DPS ≠ Godot collisions.

### Judging Balance
- **NEVER judge by a single average** — histograms, downtime, failure-by-kind, resource ratios hide coin-flips vs skill cliffs.
- **NEVER verdict on point estimates alone** — CI law (search overlap / sign-off ⊆); ≥300 search, ≥1000 sign-off.
- **NEVER declare winnable without resource-flow checks** — pressure AND income vs consumption (classic starved-but-“beatable” bug).
- **NEVER balance difficulty and economy separately** — clear-time changes currency/minute; re-run careers after difficulty edits.
- **NEVER over-nerf a farm without re-checking shop reachability** — post-exploit patches often strand the ladder.
- **NEVER balance PvP with sole AFK→pro PvE bands** — matchup / MMR metrics.

### Tuning & Maintenance
- **NEVER tune one session in isolation** — full matrix + career after changes.
- **NEVER accept generated content without sim validation**.
- **NEVER emit `.gd` factories into a Resource-first project** — emit `.tres` / Resource shape.
- **NEVER cache `GameData` across game-source edits**.
- **NEVER make designers compile manually** — self-rebuilding launchers; stale binaries → stale conclusions.
- **NEVER stdout-only for agents** — `--json` + `game_data_hash`.

## Golden path (first engagement)

1. Phase 0 → `BALANCE_PLAN.md` + designer lock on bands/metrics.
2. Phase 1 extract → **`inspect`** → if unexpected `(default!)`, stop and fix extract ([example-lane-defense.md](monte-carlo-balancer-example-lane-defense.md) smell).
3. Phase 2–3: one cell at 300 runs (Search overlap) → full matrix → SignOff ⊆ at 1000.
4. Phase 4 career → farm/shop flags → Phase 7 calibrate (unless waived) → snapshot JSON.

## Definition of Done

1. `inspect` verified; no unexpected `(default!)`.
2. Seed-determinism test passes.
3. Phase 7 PASS (or Phase 0 waiver recorded).
4. Full matrix ≥1000 runs/cell — every style **CI ⊆ band** (sign-off law).
5. Modes + career: currency/minute OK; no dominant farm; shop reachable.
6. Interest curve + reward-cadence checkpoints PASS.
7. Regression JSON snapshot committed for CI.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API;
> load Related Skills when routing work to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html) — Preferred extract source for GameData (`.tres` over regex farms).
- [JSON](https://docs.godotengine.org/en/stable/classes/class_json.html) — Snapshot / CI balance JSON emit and parse.
- [FileAccess](https://docs.godotengine.org/en/stable/classes/class_fileaccess.html) — Reading exported balance dumps and golden cells.
- [ResourceLoader](https://docs.godotengine.org/en/stable/classes/class_resourceloader.html) — Loading designer Resources for extract/calibration.
- [Command line tutorial](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html) — Headless Godot for Phase 7 calibration runs.
- [Unit testing](https://docs.godotengine.org/en/stable/engine_details/architecture/unit_testing.html) — Determinism tests around seeds and extract.
- [OS](https://docs.godotengine.org/en/stable/classes/class_os.html) — Process/env hooks for lab launchers.
- [ProjectSettings](https://docs.godotengine.org/en/stable/classes/class_projectsettings.html) — Paths and feature tags for CI balance jobs.
- [RandomNumberGenerator](https://docs.godotengine.org/en/stable/classes/class_randomnumbergenerator.html) — Seeded RNG patterns mirrored by the Rust lab.
- [SceneTree](https://docs.godotengine.org/en/stable/classes/class_scenetree.html) — Headless scene boot for golden-cell calibration.
- [Engine](https://docs.godotengine.org/en/stable/classes/class_engine.html) — Time scale / frames for headless sims.
- [ConfigFile](https://docs.godotengine.org/en/stable/classes/class_configfile.html) — Optional designer band overrides outside code.

### Related Skills

#### Prerequisites
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — Resource-first GameData before extract regex.
- [godot-testing-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md) — Headless runners and golden cells for Phase 7.
- [godot-builder](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-builder/SKILL.md) — CLI/headless project scaffolding for calibration.
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Repo layout so extract paths stay stable.

#### Complements
- [godot-economy-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-economy-system/SKILL.md) — Careers, sinks, and shop reachability inputs.
- [godot-combat-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md) — Damage/health Resources the matrix simulates.
- [godot-rpg-stats](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md) — Curves and modifiers to extract and tune.
- [godot-ability-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md) — Cooldown/cost loadouts for style matrices.
- [godot-game-loop-waves](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-game-loop-waves/SKILL.md) — Wave difficulty bands as sim cells.
- [godot-inventory-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md) — Loot/economy coupling for career sims.

#### Downstream / consumers
- [godot-genre-roguelike](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-roguelike/SKILL.md) — Meta progression win-rate bands.
- [godot-genre-tower-defense](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-tower-defense/SKILL.md) — Lane-defense style matrices (see example ref).
- [godot-genre-idle-clicker](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-idle-clicker/SKILL.md) — Career/minutes-to-milestone bands.
- [godot-genre-fighting](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-fighting/SKILL.md) — Matchup matrices beyond AFK→pro PvE.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry for the balance lab.
