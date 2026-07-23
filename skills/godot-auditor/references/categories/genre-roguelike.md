# Aurelius Protocol: Genre Roguelike NEVER List

- NEVER make runs dependent on pure RNG; strictly provide **mitigation** (rerolls, shops, pity timers) to ensure every run is winnable.
- NEVER use unseeded RNG for world generation; strictly initialize isolated `RandomNumberGenerator` with a predictable seed for daily runs/debugging.
- NEVER rely on `@GlobalScope.randi()` for critical logic; strictly use local RNG instances to prevent global state pollution.
- NEVER use `Array.pick_random()` for critical content drops; strictly use a **Shuffle Bag** to prevent statistically unfair streaks.
- NEVER generate massive dungeons on the main thread; strictly use **`WorkerThreadPool.add_task()`** or **`add_group_task()`** to distribute generation across cores and prevent frame freezes.
- NEVER interact with the SceneTree from a background thread; strictly generate dungeon data in a **thread-safe Array/PackedByteArray** before parsing on the main thread.
- NEVER allow **Save Scumming**; strictly delete mid-run save files immediately upon loading to enforce permadeath.
- NEVER allow Run State to leak into Meta State; strictly use separate singletons or Resources for `RunManager` and `MetaManager`.
- NEVER scale meta-progression to be overpowered (+100% damage); strictly keep upgrades subtle (+5-15%) to maintain skill-based play.
- NEVER forget to call `duplicate(true)` on base stat Resources; failing to deep-duplicate causes all entities to share a single health instance.
- NEVER save run states to `.tscn` files; strictly serialize to JSON or binary in `user://` to prevent bloat.
- NEVER rely on the `SceneTree` as the source of truth for grid logic; strictly maintain grid data in a separate Dictionary or Array.
- NEVER forget to handle **Navigation re-baking**; strictly rebake `NavigationRegion2D` AFTER procedural tiles are placed.
- NEVER use AStar2D for tile grids; strictly use **`AStarGrid2D`** with **`jumping_enabled = true`** (Jump Point Search) for O(1) queries and high-performance pathing across open areas.
- NEVER forget to call `update()` on `AStarGrid2D` after modifying states; strictly ensures pathfinding queries aren't stale.
- NEVER use floats (`Vector2`) for discrete grid coordinates; strictly use **Vector2i** to prevent precision drift.
- NEVER use Manhattan heuristics for 8-way movement; strictly use **`HEURISTIC_CHEBYSHEV`** or **`HEURISTIC_OCTILE`**.
- NEVER iterate over every cell coordinate (0 to W,H) in GDScript; strictly use `get_used_cells()` for optimized tile access.
- NEVER clear procedural levels using `free()`; strictly use `queue_free()` to avoid mid-frame segmentation faults.
- NEVER broadcast mass state changes to a grid immediately; strictly use `call_deferred()` or **`call_group_flags`** to avoid frame spikes during turn transitions.
- NEVER use heavy TileMapLayer nodes for high-resolution Fog of War; strictly use a **GPU Shader Mask** via `ColorRect` and an `ImageTexture` updated via **`RenderingServer.texture_2d_update()`**.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-roguelike/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — simulate balance impact of structural fixes
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
