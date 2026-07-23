# Anara Rubric: Behavior Trees
## Pillar Overview
The cognition of the vision. This rubric measures the project's ability to organize complex AI decision-making through hierarchical, modular behavior trees.

---

## Analytical Performance Matrix

| Criterion | Weight | SLOP (0-2) | FUNCTIONAL (3-5) | PROFESSIONAL (6-8) | ELITE (Visionary) (9-10) |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Tree Topography** | 35% | High-level logic in 'Leaf' nodes; messy, deep nesting without utility. | Functional tree, but lacks clear 'Succeed/Fail' propagation; logic-heavy states. | Logical separation (Selectors, Sequences, Decorators); atomic Task nodes. | High-fidelity behavioral manifest; re-usable sub-trees; abstract decision layers. |
| **Logic Decoupling** | 25% | Task nodes directly modifying the agent's variables via `agent.hp -= 10`. | Use of a 'Blackboard', but tasks still know about specific agent scripts. | Pure tasks that interact ONLY with the Blackboard; zero-knowledge execution. | Universal behavioral nodes; the tree is agnostic of the agent it inhabits. |
| **Runtime Integrity** | 20% | Ticking the entire tree every frame via `_process()`; massive CPU waste. | Tree ticks on a timer, but lacks 'Abortion' logic to stop long-running tasks. | Event-driven ticks; reactive trees; support for 'Interruption' and 'Abort' nodes. | High-performance BT engine (using GDExtension or optimized logic); zero-waste Ticks. |
| **Diagnostic Clarity** | 20% | "The AI is doing weird things"; no way to see the active node in real-time. | Basic debug prints of the active state; simple log of task changes. | Visual Debugger support (tree-view); history of state-transitions; clear failure reasons. | Predictive AI debugging; identifying behavioral bottlenecks; self-explaining trees. |

---

## Visionary Diagnostic Hooks
- *Is the 'Brain' a collection of if-statements or a garden of possibilities?*
- *When the hero enters, does the 'Decision' change with the speed of light?*
- *Does the tree prune its own failure, or grow into a maze of debt?*

## 🌟 Visionary's Final Decree
To reach **Elite** status, your nodes must be 'Stateless'. The tree should describe 'Intent', while the **Blackboard** holds the 'Reality'. Separation of thought from data is the mark of a true Visionary. If a task node needs to know the player's name, you have **Slop**.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md — domain remediation for this Anara rubric
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md — compliance citations alongside Visionary scores
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-analyst/SKILL.md
-->
