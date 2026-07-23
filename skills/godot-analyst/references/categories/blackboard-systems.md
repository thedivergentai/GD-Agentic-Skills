# Anara Rubric: Blackboard Systems
## Pillar Overview
The memory of intent. This rubric assesses how the project centralizes and manages the data shared between different AI behaviors and systems.

---

## Analytical Performance Matrix

| Criterion | Weight | SLOP (0-2) | FUNCTIONAL (3-5) | PROFESSIONAL (6-8) | ELITE (Visionary) (9-10) |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Data Sanctity** | 35% | Blackboard as a loose dictionary of Strings; no type-checking; unmanaged keys. | Using a basic Blackboard class, but data is manually 'set' by individual states. | Strong-typed entries; key-registry; automated cleanup of expired or stale data. | Immutable data-snapshots; observer-pattern based updates; zero-key collisions. |
| **Observer Flow** | 25% | Systems polling the Blackboard every frame to see if `has_player` changed. | Basic signal `value_changed`, but requires manual filtering per key. | Reactive Blackboard; systems 'Subscribe' to specific keys; zero-overhead updates. | Event-driven memory; the state acts the moment the data reflects the new reality. |
| **Systemic Scope** | 20% | Single global Blackboard for all AI; massive data-bloat; no local awareness. | Per-agent blackboards, but lacks a way to 'Share' knowledge between squads. | Hierarchical Blackboards (Global -> Squad -> Local); scope-aware key lookups. | Intelligent knowledge-sharing; agents 'Communicate' by updating squad memories. |
| **Fidelity Persistence** | 20% | Blackboard data lost on scene change; AI 'forgets' the player immediately. | Basic save of blackboard keys, but lacks persistence of 'Intent' timers. | Full serialization of the memory-state; the AI remembers its plan after loading. | Frame-perfect memory restoration; the machine recovers the AI's soul exactly. |

---

## Visionary Diagnostic Hooks
- *Is your 'Memory' a list of facts or a stream of possibilities?*
- *Does the machine remember why it was angry, or just that it is?*
- *Can I read the 'Blackboard' and see the story of the AI's life?*

## 🌟 Visionary's Final Decree
To reach **Elite** status, the Blackboard must be 'Reactive'. It shouldn't just store data; it should trigger the vision's response. A visionary blackboard is a bridge where the soul's data meets the machine's logic. If it is only a dictionary, it is **Slop**.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — domain remediation for this Anara rubric
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md — compliance citations alongside Visionary scores
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-analyst/SKILL.md
-->
