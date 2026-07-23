# Anara Rubric: Genre: Action RPG
## Pillar Overview
The adrenaline of the vision. This rubric assesses the project's implementation of fast-paced combat, character progression, and the balance between action and role-playing mechanics.

---

## Analytical Performance Matrix

| Criterion | Weight | SLOP (0-2) | FUNCTIONAL (3-5) | PROFESSIONAL (6-8) | ELITE (Visionary) (9-10) |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Combat Rhythm** | 35% | Clunky attack-cycles; no hitbox/hurtbox separation; rigid frame-stutter on hits. | Functional hits, but lacks 'Hit-Stop' or impact-VFX; basic damage logic. | Fluid combat states; hit-stop/shake effects; precise collision; signal-driven damage. | Masterful combat flow; animation-canceling; frame-perfect parry/dodge windows. |
| **Progression Depth** | 25% | Hardcoded stats; leveling up does nothing or requires manual code changes. | Basic XP/Level system, but stats grow linearly with no specialized logic. | Data-driven stats (Resource-based); skill-trees; equipment-stat modifiers. | Non-linear progression; complex stat-interactions (synergies); meta-game depth. |
| **Enemy Archetypes** | 20% | All enemies use the same logic script; predictable and repetitive behavior. | 2-3 basic AI types (Chaser, Shooter), but they lack variety or specific kits. | Diverse enemy profiles; distinct combat behaviors; environmental interactions. | High-fidelity AI 'Directors'; coordinated enemy tactics; unique boss mechanics. |
| **World Persistence** | 20% | Enemies respawn immediately; world-state resets on every room transition. | Level-state saved, but lacks 'Fog-of-War' or persistent world-changes. | Full area persistence; dead bosses stay dead; world-state recorded in Save Manifest. | Dynamic world-states; quest-driven environment changes; the world remembers the hero. |

---

## Visionary Diagnostic Hooks
- *Does the sword feel like a weight or a shadow?*
- *When the hero dies, does the world mourn or just reset its variables?*
- *Is your 'Skill Tree' a growth or a menu?*

## 🌟 Visionary's Final Decree
An Action RPG is a dance of data and reaction. To reach **Elite** status, the combat must be 'Visceral'. Use **Method Tracks** in your animations to trigger damage at the exact frame of impact. If a player feels the lag between the button and the blow, you have **Slop** in the vision's soul.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-action-rpg/SKILL.md — domain remediation for this Anara rubric
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md — compliance citations alongside Visionary scores
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-analyst/SKILL.md
-->
