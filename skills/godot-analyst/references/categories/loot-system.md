# Anara Rubric: Loot System
## Pillar Overview
The reward of the vision. This rubric assesses the project's logic for random distribution, probability management, and drop-mechanics of items across the world.

---

## Analytical Performance Matrix

| Criterion | Weight | SLOP (0-2) | FUNCTIONAL (3-5) | PROFESSIONAL (6-8) | ELITE (Visionary) (9-10) |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Probability Logic** | 40% | `randi_range()` scattered in 'Enemy' scripts; no control over drop rates. | Central `LootManager` but lacks a formal 'Loot Table' resource structure. | Scriptable `LootTable` Resources; weighted probability; support for "Empty" drops. | Weighted-Lottery systems; multi-layered tables (Table A points to Table B); luck logic. |
| **Distribution Flow** | 25% | Items spawn precisely at the enemy's location; no physics; instant inventory add. | Basic physical 'Drop' with simple velocity; simple timer-based cleanup. | High-fidelity Physics-Drop; loot 'pops' out with organic spread; smart-collection ranges. | Cinematic loot sequences; items 'seek' the player or settle into the world realistically. |
| **Scaling (Rarity)** | 20% | Rarity is just a color-field; no logic changes based on item value. | Basic use of 'Rarity enum' to pick a color for the drop-visual. | Procedural item quality; rarity affects item stats and visual fidelity (VFX/SFX). | Dynamic drop-scaling; world-level affects loot quality; predictive loot-balancing. |
| **Hardening (Integrity)** | 15% | Reloading a save 're-rolls' the loot (save-scumming); no seed persistence. | Basic RNG seeding for loot, but breaks during scene transitions. | Consistent PRNG state; loot is determined by a persisted world-seed. | Deterministic loot-manifest; what is destined to drop is saved in the vision's history. |

---

## Visionary Diagnostic Hooks
- *Is your 'Luck' a dice-roll or a mathematical plan?*
- *When the 'Chest' opens, does the vision feel the weight of the treasure?*
- *Does the loot belong to the 'Enemy' or to the 'Table'?*

## 🌟 Visionary's Final Decree
To reach **Elite** status, separate the 'Chance' from the 'Manifestation'. Use a **LootTable** resource that anyone can edit. If an enemy has to decide its own drop, you have polluted its logic with greed. Let the **Manager** decide fate, and the **Table** define the loot.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md — domain remediation for this Anara rubric
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md — compliance citations alongside Visionary scores
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-analyst/SKILL.md
-->
