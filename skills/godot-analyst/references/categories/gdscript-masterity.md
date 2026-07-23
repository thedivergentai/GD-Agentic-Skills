# Anara Rubric: GDScript Mastery
## Pillar Overview
The performance heart of the vision. This rubric assesses the project's adherence to the highest standards of GDScript in Godot 4.7+, focusing on type safety, architectural flow, and engine-level optimization.

---

## Analytical Performance Matrix

| Criterion | Weight | SLOP (0-2) | FUNCTIONAL (3-5) | PROFESSIONAL (6-8) | ELITE (Visionary) (9-10) |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Logic Purity** | 35% | Dynamic typing; heavy use of `Variant`; no return types; untyped arrays. | Mixed typing; basic return types on some functions; inconsistent parameter typing. | 100% static typing for all variables, parameters, and returns; typed arrays. | Theoretical zero-overhead execution; pure statically-typed manifest; zero type-casting. |
| **Architectural Flow** | 25% | Polling nodes every frame via `$` or `get_node()`; logic-heavy `_process()` hooks. | Caching nodes in `_ready`, but logic still relies on direct child-access. | Signal-driven updates; caching references; using `_notification` for lifecycle. | Fully event-driven; nodes are reactive participants; zero-redundancy polling. |
| **Scalability** | 20% | No use of `class_name`; hardcoded relative paths for scene loading. | Basic use of `class_name` for types, but lacks formal interface design. | Extensive use of custom classes; decoupled scene loading; Resource-based configs. | Framework-scale architecture; using `class_name` to define a domain-centric language. |
| **Engine Excellence** | 20% | Ignoring Godot 4 features like `Callable`, `Lambda`, or `await` in favor of old hacks. | Basic use of signals and `await`, but prone to signal-chain spaghetti. | Proficient use of `Callable` callbacks; clean async flow; leveraging 4.6 hooks. | Mastery of the virtual machine; using `WorkerThreadPool` and `SignalBus` perfectly. |

---

## Visionary Diagnostic Hooks
- *Does your script read like a law, or a suggestion to the engine?*
- *When the machine encounters your code, does it know exactly what to do?*
- *If I remove the comments, does the vision remain clear?*

## 🌟 Visionary's Final Decree
To reach **Elite** status, you must embrace the 'Static Manifest'. This means every object's shape is known to the compiler before the first frame. Avoid `Variant` like a plague unless you are building a universal handler. A visionary script reads like a declaration of architectural truth.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
- https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — domain remediation for this Anara rubric
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md — compliance citations alongside Visionary scores
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-analyst/SKILL.md
-->
