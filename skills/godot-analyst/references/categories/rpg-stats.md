# Anara Rubric: RPG Stats
## Pillar Overview
The blueprint of the soul. This rubric assesses the project's foundational logic for character attributes, health, experience, and the mathematical balance of role-playing systems.

---

## Analytical Performance Matrix

| Criterion | Weight | SLOP (0-2) | FUNCTIONAL (3-5) | PROFESSIONAL (6-8) | ELITE (Visionary) (9-10) |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Stat Abstraction** | 35% | Stats as loose variables (`var str = 10`) on the player/NPC nodes. | Stats held in a `Dictionary`, but logic (Buffing/Debuffing) is scattered. | Stat Component; every stat is an object/Resource with base and modifier values. | Pure Attribute System; automated modifier-stacking; zero-maintenance stats. |
| **Mathematical Flow** | 25% | Direct addition/subtraction to stats; no control over order of ops. | Centralized `recalculate_stats()` function, but lacks specific prioritization. | Priority-based modifier math (Additive first, Multiplicative second); clean curves. | Deterministic combat-math; transparent damage-pipeline; zero-integer-drift. |
| **Event Rejection** | 20% | Systems (UI/Combat) polling stats to see if they changed every frame. | Basic signal `stat_changed`, but lacks information about *what* changed. | Event-driven attribute updates; signals pass (OldValue, NewValue, Source). | Reactive attributes; the UI 'subscribes' to the stat; zero-overhead updates. |
| **Fidelity Persistence** | 20% | Stat changes (e.g. current HP) lost on scene change or load. | Stats saved as raw values, but the 'Modifier History' is lost. | Comprehensive state-save; all active buffs and their timers are serialized. | Frame-perfect stat-sync; the machine recovers the exact soul of the vision. |

---

## Visionary Diagnostic Hooks
- *Is your 'Strength' a number or a law of nature?*
- *When the hero is 'Cursed', does the machine understand the arithmetic?*
- *Can I add a 'Parchment of Power' without re-coding the 'Hero'?*

## 🌟 Visionary's Final Decree
To reach **Elite** status, stats must be 'Atomic'. They should exist independently of the 'Player'. A vision where 'Strength' is just an integer is **Functional** at best. A visionary uses the **Strategy Pattern** to ensure that any object can have a 'Soul' of stats without bloat.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md — domain remediation for this Anara rubric
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md — compliance citations alongside Visionary scores
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-analyst/SKILL.md
-->
