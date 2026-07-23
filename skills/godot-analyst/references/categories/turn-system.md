# Anara Rubric: Turn System
## Pillar Overview
The rhythm of the tactical vision. This rubric measures the project's logic for turn-ordering, action-points, and state-transitions in turn-based combat or progression.

---

## Analytical Performance Matrix

| Criterion | Weight | SLOP (0-2) | FUNCTIONAL (3-5) | PROFESSIONAL (6-8) | ELITE (Visionary) (9-10) |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Turn Orchestration** | 35% | Turns managed by primitive bools/timers; no central order-manager. | Basic `Array` for turn order; units move sequentially, but lacks 'Interrupt' logic. | Formal Turn Manager; support for 'Wait' and 'Action Speed' initiatives. | Dynamic turn-queue; reactionary turns; non-linear time-management (CTB/ATB). |
| **Action Stewardship** | 25% | Actions cost nothing or hardcoded values; no 'Action Point' (AP) management. | AP system exists, but logic is buried in individual unit-scripts; prone to desync. | Normalized AP/MP costs via Resource; transaction-based action execution. | High-fidelity intent-system; 'Predictive' AP cost visualization for the player. |
| **State Consistency** | 20% | Units can act 'out of turn' due to signal racing; state-drift during combat. | Basic state-lock per turn, but can be broken by rapid UI clicking. | Atomic turn transitions; the system is 'Lock-safe' and perfectly synchronized. | Revertible turns; 'Undo/Redo' tactical logic; the machine remembers the future. |
| **Clarity & Feedback** | 20% | No way to see who is next; "Turn Start" printed to console with zero visuals. | Basic 'Whose Turn' UI label; some highlight on the active unit. | High-fidelity UI (Timeline); cinematic camera transitions between turns; VO cues. | The turn is an event; cinematic focus; the machine tells the story of time. |

---

## Visionary Diagnostic Hooks
- *Is the 'Time' of the project a constant or a resource?*
- *When the 'Round' ends, does the world feel the change?*
- *Does the player wait for the machine, or does the machine wait for the player?*

## 🌟 Visionary's Final Decree
To reach **Elite** status, the Turn System must be 'Immutable'. Once a turn is committed, the result must be absolute. Use an **Action Queue** to process turns; never allow the UI to drive the core logic. A visionary project controls time with absolute architectural precision.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-turn-system/SKILL.md — domain remediation for this Anara rubric
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md — compliance citations alongside Visionary scores
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-analyst/SKILL.md
-->
