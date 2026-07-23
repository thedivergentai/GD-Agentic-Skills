# Anara Rubric: Genre: Survival
## Pillar Overview
The endurance of the vision. This rubric measures the project's logic for hunger/thirst, resource-gathering, crafting, and environmental hazards.

---

## Analytical Performance Matrix

| Criterion | Weight | SLOP (0-2) | FUNCTIONAL (3-5) | PROFESSIONAL (6-8) | ELITE (Visionary) (9-10) |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Endurance Logic** | 35% | Stats (Hunger/Health) as raw ints on the Player script; unscaled decay. | Formal 'Stat' Resource, but lacks 'Injury' logic or complex status-effects. | Status-Effect System; buffs/debuffs; integrated stat-decay based on world-time. | Dynamic metabolic simulation; status-interactions (Wet -> Cold -> Flu); infinite depth. |
| **Crafting Depth** | 25% | Hardcoded recipes in the UI; no ability to add new items without coding. | Data-driven recipes (JSON), but lacks 'Station' requirements or tiered tools. | Multi-tiered crafting; resource-refining cycles; sophisticated ingredient logic. | Procedural crafting; modular item assembly; the world is the workbench. |
| **Env. Resilience** | 20% | Static environment; "Night" is just a color-tint; zero hazard logic. | Basic Day/Night cycle; some simple fire/poison zones, but unmanaged. | Full Weather System; temperature zones; dynamic hazardous world-states. | Reactive environment; the world adapts to the player's survival state. |
| **Progression State** | 20% | No long-term survival tracking; inventory/stats lost on restart. | Basic save of inventory, but lacks state-save for the world (Resources harvested). | Persistent world-objects; re-growing resources; saved base-building states. | Infinite survival-manifest; the world remembers every tree cut and every fire lit. |

---

## Visionary Diagnostic Hooks
- *Is 'Death' a loss of data or a failure of the vision?*
- *Does the 'Hunger' grow in the player's mind or just on a bar?*
- *When the 'Night' falls, does the machine fear the dark?*

## 🌟 Visionary's Final Decree
To reach **Elite** status, survival should be 'Systemic', not 'Scripted'. The world should be a hierarchy of threats that the systems manage autonomously. If you have to manually check `if hunger < 0` every frame, you have **Slop**. Visionaries use an **Effect Manager**.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-survival/SKILL.md — domain remediation for this Anara rubric
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md — compliance citations alongside Visionary scores
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-analyst/SKILL.md
-->
