# Anara Rubric: Composition Apps
## Pillar Overview
The macro-scale application framework. This rubric measures how the project organizes high-level systems (UI, Game, Save) through modular application controllers.

---

## Analytical Performance Matrix

| Criterion | Weight | SLOP (0-2) | FUNCTIONAL (3-5) | PROFESSIONAL (6-8) | ELITE (Visionary) (9-10) |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Systemic Isolation** | 35% | All systems (UI/Save/Input) inside a single `Global.gd` or `Main.gd`. | Systems split into several Singletons, but they all reference each other directly. | Decoupled 'Service' modules; systems communicate via a central 'Application Hub'. | Pure 'Micro-system' architecture; the Core is an empty runner for independent services. |
| **Initialization Priority** | 25% | No clear boot sequence; systems initialize 'randomly' based on tree order. | Linear init in a singleton, but crashes if a system is missing. | Weighted initialization; critical services boot first; dependent services wait. | Parallelized initialization with dependency-injection for non-blocking boot-up. |
| **Scalability (Plugin)** | 20% | Adding a new global system requires editing 5+ core files. | New systems are added as Autoloads, but require manual registration in `ProjectSettings`. | Plugin-style architecture; new systems register themselves to the 'App Controller'. | Hot-swappable systems; switching from 'Steam' to 'Epic' is a single config change. |
| **Engine Runtime** | 20% | Main thread blocked by background system logic (e.g. Save file writing). | Using base `_process` for systems; some use of `Node` lifecycle. | Systems run in separate `MainLoop` or dedicated high-priority threads where needed. | Ultra-high-performance runtime; systems use specialized 'Processing Servers' (Rendering/Physics). |

---

## Visionary Diagnostic Hooks
- *Is your 'Global' a closet of mess or a server-room of precision?*
- *Can I run the 'Game' without loading the 'UI' system first?*
- *If I add a 'Discord' integration, do I have to re-read the entire project?*

## 🌟 Visionary's Final Decree
To reach **Elite** status, implement a 'System Registry' where components register themselves to the core upon ready. No system should 'hard-reference' another. You must aim for 'Averaging the Complexity'—no single file should bear the weight of the entire vision.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
- https://docs.godotengine.org/en/stable/tutorials/best_practices/autoloads_versus_regular_nodes.html
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition-apps/SKILL.md — domain remediation for this Anara rubric
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md — compliance citations alongside Visionary scores
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-analyst/SKILL.md
-->
