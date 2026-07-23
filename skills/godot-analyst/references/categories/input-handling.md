# Anara Rubric: Input Handling
## Pillar Overview
The bridge between the player's soul and the vision. This rubric measures the responsiveness, rebindability, and architectural purity of the project's input layer.

---

## Analytical Performance Matrix

| Criterion | Weight | SLOP (0-2) | FUNCTIONAL (3-5) | PROFESSIONAL (6-8) | ELITE (Visionary) (9-10) |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Input Mapping** | 35% | Hardcoded keys in scripts (`if input == KEY_W`); zero rebinding support. | Using `InputMap` actions, but actions are tied directly to player logic (no mid-layers). | Action-based input; full rebinding support via `InputMap.action_add_event()`. | Semantic input architecture; Input-to-Intent mapping; decoupled action descriptors. |
| **Responsiveness** | 25% | Input lag; missing frames; using `Input.is_action_pressed` in high-load loops incorrectly. | Use of `_input()` event for some actions, but lacks 'Input Buffer' for combos. | Buffered input (coyote time, input queue); 100% frame-responsive feel. | Predictive input handling; zero-latency response; sub-frame event processing. |
| **Modal Switching** | 20% | Input "leaks" through UI to the player (e.g., clicking a button also fires a gun). | Manual `set_process_input(false)` hacks; fragile during complex menu states. | Formal Input State Machine; states (UI, Game, Cutscene) consume input exclusively. | Multi-layered input stack; hierarchical consumption; context-aware input-swapping. |
| **Multi-Device Flow** | 20% | Keyboard-only or Gamepad-only; no hybrid support (no prompts switching). | Support for both, but requires restart/manual toggle; static UI prompts. | Dynamic device detection; real-time UI prompt swapping (Xbox vs DS4 icons). | Universal input abstraction; the vision is agnostic of the tool that touches it. |

---

## Visionary Diagnostic Hooks
- *Does the vision feel the player's heartbeat, or just the click of a button?*
- *If I change the 'Jump' key, do five scripts catch on fire?*
- *When the menu opens, does the 'World' still listen to the player's hands?*

## 🌟 Visionary's Final Decree
To reach **Elite** status, your input must be 'Intentional'. The script shouldn't look for 'Spacebar'; it should look for the 'Jump Intent'. Separation of device from desire is the mark of a true architect. A visionary vision reacts before the input is even finished.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html
- https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — domain remediation for this Anara rubric
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md — compliance citations alongside Visionary scores
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-analyst/SKILL.md
-->
