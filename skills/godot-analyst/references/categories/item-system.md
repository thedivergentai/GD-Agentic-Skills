# Anara Rubric: Item System
## Pillar Overview
The artifacts of the vision. This rubric measures the project's ability to define, instantiate, and utilize game-world items with a consistent, data-driven framework.

---

## Analytical Performance Matrix

| Criterion | Weight | SLOP (0-2) | FUNCTIONAL (3-5) | PROFESSIONAL (6-8) | ELITE (Visionary) (9-10) |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Data Separation** | 40% | Item stats (Damage/Cost) hardcoded in the `Area2D` or `Node3D` script. | Using a basic `ItemResource`, but items share the same script for all logic types. | Strict separation (Resource = Data, Scene = Component Viewer, Script = Logic Hook). | 100% data-driven; any item can be created by a designer without writing a line of code. |
| **Instantiation Flow** | 25% | Manual creation of items ($`Sword`.instance()); hard paths to scene files. | Central `ItemFactory` with a `match` statement to find the right scene. | Registry-based factory; items are ID-lookup based; async scene loading for large items. | High-performance pooling; items are requested by Type; zero-latency spawning. |
| **Interactive Logic** | 20% | "Using" an item requires checking the player's state manually in the item script. | Items emit a signal when used; player script catches and performs logic. | Component-based interaction; items hold a list of `Effect` resources to apply to targets. | Abstract interaction protocol; items are reactive logic containers; zero-knowledge use. |
| **Visual Fidelity** | 15% | Standard icon; no specialized visuals or specific collision per item. | Basic 2D/3D representation with generic shadows and simple physics. | Specific collision shapes per item; high-quality icons; unique drop-sound triggers. | Cinematic item presentation; detailed physics interactions; context-aware visuals. |

---

## Visionary Diagnostic Hooks
- *Is the 'Axe' a script or a data-point?*
- *Can I create a 'Magic Wand' without opening the script editor?*
- *When the 'Potion' breaks, does the vision know how to clean its spirit?*

## 🌟 Visionary's Final Decree
To reach **Elite** status, your items must be 'Pure Data' until the moment of manifestation. Use **Resources** as the anchor of existence. If your 'Item' script is longer than 50 lines, it is performing logic that belongs to a **Component**. Simplicity in data leads to complexity in the vision.
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
