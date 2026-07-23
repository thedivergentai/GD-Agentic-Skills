# Anara Rubric: Core Architecture
## Pillar Overview
The skeletal integrity of the vision. This rubric assesses how the project handles system-level dependencies, initialization sequences, and the overall structural flow of the application.

---

## Analytical Performance Matrix

| Criterion | Weight | SLOP (0-2) | FUNCTIONAL (3-5) | PROFESSIONAL (6-8) | ELITE (Visionary) (9-10) |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Dependency Purity** | 30% | Circular dependencies; heavy use of `get_parent()` or hardcoded global paths. | Some separation via Singletons, but systems are tightly coupled. | Use of Dependency Inversion or Service Locators; systems share interfaces, not instances. | 100% decoupled systems; zero-knowledge architecture; hot-swappable core modules. |
| **Initialization Flow** | 25% | Random `_ready()` ordering; race conditions during startup; opaque boot sequence. | Linear init sequence in a central `Main.gd`, but fragile during errors. | Formal initialization manager with explicit state checks (Init -> Load -> Ready). | Multi-staged, async-ready boot system with deterministic recovery and validation. |
| **Scene Composition** | 20% | Deep inheritance (4+ levels); monolithic scenes; no clear scene ownership. | Basic scene instances; some use of 'Base' scenes for UI/Enemies. | Atomic scene design; components handle specific logic; shallow inheritance. | Composition-first architecture where the 'Node' is the assembly point, not the logic container. |
| **Systemic Scalability** | 25% | Adding a new feature requires modifying multiple core singletons. | Feature-parity via global registry, but requires manual mapping. | Extension-point architecture; new features 'register' to a central bus. | Pure Plugin architecture; the core is agnostic of the features it runs. |

---

## Visionary Diagnostic Hooks
- *Does the system's heart stop if a single non-essential node fails to load?*
- *Can I move the 'Player' to a different project without bringing 5 other folders with it?*
- *If I add a second 'World', does the machine know which one is the reality?*

## 🌟 Visionary's Final Decree
Your architecture is the vessel for the vision. If the technical debt of the foundation weighs down the soul of the project, it is **Slop**. To achieve **Elite** status, you must reach the 'Stateless Core'—where the architecture is so pure that the data simply flows through it without friction.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
- https://docs.godotengine.org/en/stable/tutorials/best_practices/autoloads_versus_regular_nodes.html
- https://docs.godotengine.org/en/stable/classes/class_resourceloader.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — domain remediation for this Anara rubric
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md — compliance citations alongside Visionary scores
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-analyst/SKILL.md
-->
