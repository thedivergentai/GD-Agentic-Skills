# Aurelius Protocol: Genre Metroidvania NEVER List

- NEVER allow "Soft-Locks" where a player is trapped; if they enter via a one-way path ("valve"), they MUST be able to leave using current abilities. Always design **fail-safe escape routes**.
- NEVER create empty dead ends; if a player backtracks to a remote area, they MUST be rewarded with a collectible, lore, or currency. Empty rooms are design failures.
- NEVER make backtracking purely repetitive; as the player gains movement (Dash/Teleport), traversal through old areas MUST become faster. **Open shortcuts** to bypass long, early routes.
- NEVER hide the critical path without "crumbs"; use distinct **Landmarks**, unique lighting, or environmental storytelling to build the player's mental map.
- NEVER design abilities that serve only one purpose; strictly implement dual-use traversal and combat functionality (e.g., a "Dash" that crosses gaps and dodges attacks).
- NEVER forget to save **persistent room state**; if a player opens a chest or defeats a boss, that state MUST remain saved when they leave and return.
- NEVER load interconnected rooms synchronously via `load()`; strictly use `ResourceLoader.load_threaded_request()` for seamless transitions.
- NEVER track global progression within localized room scripts; strictly use **Autoload Singletons** for global ability flags and world state.
- NEVER use floating-point types for grid coordinates (minimaps/fog); strictly use `Vector2i` to prevent precision jitter.
- NEVER manipulate the SceneTree directly from a background loading thread; strictly use `call_deferred()`.
- NEVER calculate jump arcs or dashes inside `_process()`; strictly use `_physics_process()` to prevent stutter.
- NEVER multiply `CharacterBody2D` velocity by `delta` before `move_and_slide()`; the engine handles this internally.
- NEVER poll `is_action_just_pressed()` inside `_physics_process()` for buffering; strictly capture events in `_unhandled_input()`.
- NEVER use standard strings for high-frequency ability checks; strictly use `StringName` (&"dashing") for pointer-speed comparisons.
- NEVER iterate through every node to broadcast updates; strictly use `SceneTree.call_group()` for efficient mass communication.
- NEVER delete active room/player nodes via `free()`; strictly use `queue_free()` to avoid segmentation faults.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-metroidvania/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — simulate balance impact of structural fixes
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
