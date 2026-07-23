# Phase 6 — Genre & Engine Adaptation

**Goal:** Reuse extraction → playstyles → seeded Monte Carlo → bands/metrics → careers → bruteforce. Map abstractions in Phase 0; load Domain Skills instead of reinventing genre design here.

## Abstract model reminder

Fill Threat / Defense / Fault / Resource / Economy / Session / Grade in Phase 0. Delete unmapped subsystems from the sim.

## Genre → Domain Skill Chain (mandatory loads)

| Genre | Primary metric override | **READ** |
|-------|-------------------------|----------|
| Tower defense / waves | Win rate (default) | `godot-genre-tower-defense`, `godot-game-loop-waves` |
| Simulation / tycoon | Economy pacing + soft fail | `godot-genre-simulation`, `godot-economy-system` |
| Idle / clicker | Minutes-to-milestone bands | `godot-genre-idle-clicker`, `godot-economy-system` |
| Combat formulas / ARPG | Win rate + power curve | `godot-combat-system`, `godot-rpg-stats`, `godot-ability-system`, `godot-genre-action-rpg` |
| Roguelike | Win% vs meta level; runs-to-first-win | `godot-genre-roguelike`, `godot-procedural-generation` |
| Fighting / competitive | Matchup matrix / frame data — **not** AFK→pro | `godot-genre-fighting` Balance Guidelines |
| Educational | ~70% flow / mastery | `godot-genre-educational` |
| Stealth | Detection/suspicion fail; route styles | `godot-genre-stealth` |
| RTS | Build-order policies; coarse ticks | `godot-genre-rts` |
| Platformer | Encounter-granularity success probs (not raw input) | `godot-genre-platformer` |
| Party / asymmetric | Role power offsets | `godot-genre-party` |
| MOBA / shooters | Weapon/hero asymmetry (lighter matrix) | `godot-genre-moba`, `godot-genre-shooter` |

### Genre notes (knowledge delta only)

- **Stealth:** suspicion meter + patrol graph; styles `ghost` / `rusher` / sloppy floor; grade = detections + time.
- **Roguelike:** career IS the loop; per-run RNG inside `simulate_run`; dead-item detection (pick never moves win rate).
- **Idle:** coarse timestep; playstyles = check-in frequency + spend policy; pacing bands replace win%.
- **RTS PvE:** extract AI build orders; Lanchester-style resolution calibrated against a few engine battles.
- **Platformer / action:** simulate at encounter grain; calibrate from playtests or headless bots (Phase 7).
- **Fighting / PvP:** NEVER use PvE AFK→pro bands as the sole truth.

## Engine adaptation (extraction only)

`model` / `sim` / `analysis` / `generate` stay engine-agnostic.

| Engine | Prefer | Fallback |
|--------|--------|----------|
| Godot | `.tres` / Resource JSON dump | Regex for inline formula coeffs |
| Unity | ScriptableObject YAML | C# `const` regex |
| Unreal | Exported CSV/JSON DataTables | Ask for export step if Blueprint-only |
| JSON-driven | serde direct | — |

Root marker: `project.godot` / `.uproject` / `Assets/` / `package.json` + `BALANCE_LAB_PROJECT_ROOT`.

## What never changes

Source extraction + `inspect`; behavioral `PlayStyle`; seeded determinism; CI-aware bands; careers; band-scored bruteforce; Phase 7 calibration for Godot projects.
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
