# Aurelius Protocol: Turn System NEVER List

- NEVER recalculate turn order every action; strictly sort once per round or ONLY when a speed-relevant stat changes to prevent O(n log n) lag.
- NEVER use random tie-breaking for initiative; strictly use a secondary static attribute (Agility, ID, or persistent "luck") for **deterministic replays**.
- NEVER modify an active turn-order queue while iterating it; strictly iterate over a `duplicate()` or apply queue modifications after the loop.
- NEVER broadcast global turn state changes using immediate `call_group()`; strictly use **`call_group_flags(SceneTree.GROUP_CALL_DEFERRED, ...)`** to prevent frame spikes when notifying hundreds of units.
- NEVER rely on the Node hierarchy as the source of truth; strictly use a **Dictionary board state** for logical grid coordinates.
- NEVER deduct Action Points (AP) before validation; strictly call `can_perform_action(cost)` before applying `current_ap -= cost` to prevent exploits.
- NEVER hardcode phase transitions (`if phase == 0`); strictly use an **enum + match** or a dedicated State Machine for Draw/Main/End phases.
- NEVER emit "Turn Ended" before internal cleanup; strictly reset AP and tick status effects **BEFORE** signaling the next turn.
- NEVER use exact floating-point equality (`==`) for AP checks; strictly use `>=` or `is_equal_approx()` for robust comparisons.
- NEVER use generic `AStar2D` for tile grids; strictly use **`AStarGrid2D`** for 10x faster pathfinding and native diagonal handling.
- NEVER forget to call **`update()`** on `AStarGrid2D` after changing obstacle states; if you toggle `set_point_solid()`, the grid MUST refresh before the next query.
- NEVER lock the main thread with `while` loops for input; strictly use the **await keyword** or signals to yield execution back to the Tree.
- NEVER handle turn decisions with `is_action_pressed()`; strictly use `is_action_just_pressed()` for discrete, frame-locked menu input.
- NEVER skip turn timeouts in networked games; strictly implement a **server-side timer** with a default "pass" action to prevent griefing.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-turn-system/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
