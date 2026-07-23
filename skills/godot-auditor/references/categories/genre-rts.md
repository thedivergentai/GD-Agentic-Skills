# Aurelius Protocol: Genre Rts NEVER List

- NEVER allow pathfinding "Jitter" when moving group units; strictly **stagger path queries** and enable **RVO Avoidance** only when units are in motion to save CPU cycles.
- NEVER update RVO avoidance every frame for all units; strictly use **Avoidance Threading** (Project Settings) and replace static units with `NavigationObstacle`.
- NEVER let units get stuck in infinite path loops; strictly implement a **timeout and IDLE state** if a destination is unreachable.
- NEVER use `_process()` on hundreds of individual units; strictly use a central **UnitManager** or `_physics_process` only when required.
- NEVER calculate unit visibility manually for Fog of War; strictly use a **Shader-based mask** (SubViewport + ColorRect) for GPU efficiency.
- NEVER process unit AI or pathfinding synchronously for mass groups; strictly offload to **`WorkerThreadPool`** and stagger path updates.
- NEVER use high-poly visual meshes as NavMesh source geometry; strictly use simplified **Collision Shapes** for baking.
- NEVER forget **Command Queuing** (Shift-Click); strictly store an `Array[Command]` and implement a "Force Move/Attack" bypass.
- NEVER create excessive micromanagement; strictly automate low-level tasks like **auto-aggro range** and auto-return for resource gathering.
- NEVER use exact floating-point equality (==) for grid or timers; strictly use `is_equal_approx()` for deterministic triggers.
- NEVER rely on the visual SceneTree for selection data; strictly maintain a **Typed Selection Set** of `RefCounted` or `Resource` objects for deterministic serialization and netcode.
- NEVER forget **Command Queuing**; strictly implement a **Command Pattern** using serializable `Dictionary` or `JSON` states for save-game and multiplayer playback.
- NEVER forget to **duplicate_deep()** globally shared Resources; otherwise, modifying one unit's data (e.g., stats) affects all.
- NEVER render thousands of units using separate `MeshInstance3D` nodes; strictly use **`MultiMeshInstance`** with **`INSTANCE_CUSTOM`** data to drive unique GPU-side state animations (walking/attacking/color).
- NEVER calculate transforms for mass units on the main thread; strictly use **`WorkerThreadPool`** to push buffers to `RenderingServer.multimesh_set_buffer()`.
- NEVER update every unit's navigation path in the same frame; strictly use random timers to **stagger updates**.
- NEVER use standard Strings for high-frequency AI state identifiers; strictly use **StringName** (&"harvesting") for pointer-speed comparisons.
- NEVER allow simulation coordinates to exceed 8192 units without float-precision management; strictly use world-origin shifts.
- NEVER use `CSGShape3D` for building placement ghosts; strictly use optimized static `ArrayMesh` geometry.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-rts/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — simulate balance impact of structural fixes
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
