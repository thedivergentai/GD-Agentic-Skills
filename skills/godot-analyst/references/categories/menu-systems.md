# Anara Rubric: Menu Systems
## Pillar Overview
The gateway to the vision. This rubric assesses the architectural structure, navigation logic, and transition fluidity of the project's menu hierarchies.

---

## Analytical Performance Matrix

| Criterion | Weight | SLOP (0-2) | FUNCTIONAL (3-5) | PROFESSIONAL (6-8) | ELITE (Visionary) (9-10) |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Hierarchy Control** | 35% | Infinite nesting of `Button -> Function` calls; redundant 'Back' logic; menu leaks. | Basic `MenuManager` script to toggle visibilities, but prone to state overlap. | Formal Menu Stack (Push/Pop logic); exclusive input focus per menu level. | Fully decoupled Menu Architecture; menus are generic viewers for systemic data. |
| **Navigation Flow** | 25% | Broken Gamepad focus; manual `grab_focus()` hacks in `_process()`. | Functional focus-neighbor mapping; basic cross-device support (Mouse/Stick). | Automated Focus-Linker; consistent directional logic; smart-default focus positions. | Implicitly intuitive navigation; circular focus loops; context-aware menu jumping. |
| **Transition Quality** | 20% | Immediate visibility toggles ($`Menu`.hide()); harsh cuts; flickering backgrounds. | Basic `fade_in/out` logic using Tweens, but blocking during the move. | Non-blocking async transitions; layered menu animations (Slide, Zoom). | Cinematic menu flow; the transitions are as beautiful as the menus themselves. |
| **State Persistence** | 20% | Going back resets the menu state (e.g. scroll position lost); no history. | Basic tracking of 'Previous' menu, but lacks deep state-recovery. | Full UI state-recall; returning to a sub-menu restores active checkboxes and scrolls. | Seamless UI-to-Logic synchronization; the menu reflects the vision's state instantly. |

---

## Visionary Diagnostic Hooks
- *Is the menu a list or a journey?*
- *When the player returns, does the menu remember their last step?*
- *Does the 'Start' button feel like an invitation or a trigger?*

## 🌟 Visionary's Final Decree
To reach **Elite** status, implement a 'Menu Stack' that manages the breadcrumbs of the player's journey automatically. No menu should ever 'know' about its parent. It should merely emit a 'Close' signal and let the machine handle the rest. Architecture is the silence between the menus.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — domain remediation for this Anara rubric
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md — compliance citations alongside Visionary scores
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-analyst/SKILL.md
-->
