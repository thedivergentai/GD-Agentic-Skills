# Anara Rubric: Genre: Strategy
## Pillar Overview
The grand simulation of the vision. This rubric assesses the project's implementation of turn-based or real-time tactical systems, resource management, and unit AI.

---

## Analytical Performance Matrix

| Criterion | Weight | SLOP (0-2) | FUNCTIONAL (3-5) | PROFESSIONAL (6-8) | ELITE (Visionary) (9-10) |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Tactical Logic** | 35% | Hardcoded unit-behaviors; flat decision-making; no pathfinding optimization. | Basic A* pathfinding; units can move/attack but lack context-awareness. | Grid-aware logic; multi-unit coordination; environmental tactical bonuses. | Advanced AI decision-trees; predictive unit behavior; true tactical simulation. |
| **Economy/Balance** | 25% | Values hardcoded; no central "Balance Sheet"; exploits are obvious. | Functional stats, but lacks 'Rock-Paper-Scissors' counters or meaningful depth. | Data-driven unit metrics; balanced resource-cycles; systemic interaction depth. | Macro-economic feedback loops; dynamic balance adjustment; infinite strategic depth. |
| **Interface Clarity** | 20% | Clunky unit-selection; no 'Fog-of-War'; obscure unit-stats in the UI. | Basic marquee selection; functional stat-displays; simple map-scrolling. | High-fidelity Strategy UI; fluid camera control; clear visual units-commands. | Cinematic tactical interface; holographic map-readouts; zero-friction command flow. |
| **Simulation Perf.** | 20% | UI/Logic hang during "Enemy Turn" calculations; massive CPU-latency. | Sequential unit processing; functional but slow during large-scale battles. | Multi-threaded AI-thinking; optimized path-caching; performant grid-logic. | Zero-latency simulation; thousand-unit processing (Compute-ready); infinite scale. |

---

## Visionary Diagnostic Hooks
- *Is the 'Enemy' a thinker or a series of random IF statements?*
- *When the 'War' starts, does the frame-rate survive the slaughter?*
- *Does the player feel like a General or a User?*

## 🌟 Visionary's Final Decree
Strategy is the architecture of decision. To reach **Elite** status, your systems must provide 'Total Information' with zero 'Total Confusion'. Use **WorkerThreadPool** for heavy tactical calculations. A visionary strategy game makes the player feel like the master of a living world, not a spreadsheet.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-turn-system/SKILL.md — domain remediation for this Anara rubric
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md — compliance citations alongside Visionary scores
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-analyst/SKILL.md
-->
