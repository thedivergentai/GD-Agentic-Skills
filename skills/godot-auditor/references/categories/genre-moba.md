# Aurelius Protocol: Genre Moba NEVER List

- NEVER trust the client for damage calculation or resource costs; strictly validate mana, ranges, and hit detection on the **authoritative server** using `multiplayer.is_server()`.
- NEVER use `TRANSFER_MODE_RELIABLE` for continuous movement; strictly use `UNRELIABLE` or `UNRELIABLE_ORDERED` for position/velocity to prevent network congestion.
- NEVER sync units at 60Hz; strictly use a lower tick rate (10-20Hz) via `MultiplayerSynchronizer` and implement **Interp/Client-Side Prediction** for visual smoothness.
- NEVER attach individual synchronizers to hundreds of minions; strictly batch state updates into compressed byte arrays via a central manager.
- NEVER synchronize complex Engine objects directly; strictly serialize state into primitive properties or Dictionaries for reliable peer-to-peer sync.
- NEVER use expensive pathfinding for all minions every frame; strictly use **Time Slicing** to spread `get_next_path_position()` calls across multiple frames.
- NEVER query `NavigationAgent` paths inside `_process()`; strictly use `_physics_process()` to interact with the navigation server and avoidance systems.
- NEVER use complex visual geometry for NavMesh baking; parse simple primitives to avoid stalling the `RenderingServer` or crashing the engine.
- NEVER set `path_search_max_polygons` too low in large maps; agents will stop or walk incorrectly if the limit is reached before the destination.
- NEVER use `Area2D` for high-performance Fog of War LOS; strictly use nodeless physics queries (`intersect_ray`) to bypass node overhead.
- NEVER forget Tower "Dive" protection; towers MUST switch targets immediately if an enemy Hero damages an allied Hero within range (Priority: Hero attacking Ally > Minion > Hero).
- NEVER allow "Snowballing" without counter-play; strictly implement **Comeback Mechanisms** (Kill Bounties, Catch-up XP) to maintain competitive tension.
- NEVER manage hero stats as standard Node variables; strictly use custom `Resource` scripts for data separation and memory efficiency.
- NEVER forget to call `duplicate(true)` on shared ability Resources; modifying a buff on a shared resource will affect all heroes globally.
- NEVER use standard strings for status checks (e.g., "stunned"); strictly use `StringName` (&"stunned") for pointer-speed comparisons.
- NEVER loop over massive Fog of War grids with floats; strictly use `Vector2i` and `TileMapLayer` to prevent precision jitter.
- NEVER execute heavy world/minimap logic on the main thread; strictly offload complex array math to `WorkerThreadPool` to maintain 60+ FPS.
- NEVER rigidly couple UI cooldowns to Hero scripts; strictly use a Signal Bus or `Callable` bindings for decoupled architecture.
- NEVER evaluate exact floating-point equality (==); strictly use `is_equal_approx()` for range, cooldown, and mana validations.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-moba/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — simulate balance impact of structural fixes
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
