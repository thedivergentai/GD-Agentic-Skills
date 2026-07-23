# Anara Rubric: Composition
## Pillar Overview
The modular mindset of the architect. This rubric assesses how the vision is assembled through atomic components rather than monolithic inheritance trees.

---

## Analytical Performance Matrix

| Criterion | Weight | SLOP (0-2) | FUNCTIONAL (3-5) | PROFESSIONAL (6-8) | ELITE (Visionary) (9-10) |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Logic Atomicity** | 30% | Massive 'Player' or 'Enemy' scripts (500+ lines); logic-heavy base classes. | Some logic moved to 'Helper' scripts, but still tightly coupled to parent state. | Logic split into discrete Component nodes (`HealthComponent`, `MoveComponent`). | Atomic design; scripts are focus-specific (one capability per component); zero bloat. |
| **Interface Purity** | 25% | Components directly modifying each other's variables via `parent.health -= 10`. | Use of direct function calls between components (`parent.take_damage()`). | Signal-driven communication; components emit intent; managers handle execution. | Decoupled 'Behavioral' nodes that only interact through a central 'Blackboard' data layer. |
| **Scalability** | 25% | Adding a new enemy requires creating a new script and inheriting from `BaseEnemy`. | New enemies created via scene instances with minor script parameter tweaks. | Data-driven components; enemy behaviors are swapped via Resources or Node-swapping. | True composition; 'Enemy' is a shell populated by interchangeable, reactive behavior nodes. |
| **Engine Flow** | 20% | Using inheritance to share common variables like `speed` or `health`. | Basic use of `_notification` in base class to handle common logic. | Favoring 'Traits' over 'Classes'; components handle their own lifecycle independently. | Leveraging Godot 4.7 `Feature` and `Custom Node` types to build a domain-specific kit. |

---

## Visionary Diagnostic Hooks
- *Is your 'Player' a single heavy node, or a collection of agile components?*
- *If I remove a component, does the vision collapse or simply lose a capability?*
- *When you build, are you stacking bricks or growing a monolithic tower of debt?*

## 🌟 Visionary's Final Decree
Inheritance is a debt that child nodes must pay for the rest of their existence. Composition is an investment in architectural freedom. To achieve **Elite** status, ensure that your core entity is an empty shell that gains its soul through the nodes you attach to it.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
- https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
- https://docs.godotengine.org/en/stable/tutorials/best_practices/autoloads_versus_regular_nodes.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md — domain remediation for this Anara rubric
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md — compliance citations alongside Visionary scores
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-analyst/SKILL.md
-->
