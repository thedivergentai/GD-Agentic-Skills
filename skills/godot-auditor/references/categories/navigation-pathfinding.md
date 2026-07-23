# Aurelius Protocol: Navigation Pathfinding NEVER List

- **NEVER set `target_position` before awaiting physics frame** — NavigationServer not ready in `_ready()`? Path fails silently. MUST `call_deferred()` then `await get_tree().physics_frame`.
- **NEVER use `NavigationRegion2D.bake_navigation_polygon()` at runtime** — Synchronous baking freezes game for 100+ ms. Use `NavigationServer.bake_from_source_geometry_data_async()` for stutter-free updates.
- **NEVER forget to check `is_navigation_finished()`** — Calling `get_next_path_position()` after reaching target = stale path, AI walks to old position.
- **NEVER use `avoidance_enabled` without setting radius** — Default radius = 0, agent passes through others. Set `nav_agent.radius = collision_shape.radius` for proper avoidance.
- **NEVER poll `target_position` every frame for chase AI** — Setting target 60x/sec = path recalculation spam. Use timer (0.2s intervals) or distance threshold for updates.
- **NEVER assume path exists** — Target unreachable (blocked by walls)? `get_next_path_position()` returns invalid. Check `is_target_reachable()` or validate path length.
- **NEVER use heavy node-based navigation for thousands of simple entities** — Use `NavigationServer3D/2D` RIDs directly to bypass node overhead.
- **NEVER call `get_path()` every frame** — Use `query_path()` with reused `NavigationPathQueryResult` objects to prevent massive heap allocation and GC pressure.
- **NEVER leave 'enter_cost' at 0 for high-penalty areas** — Use costs to make AI prefer logical paths (roads over water) instead of just shortest geometric distance.
- **NEVER ignore `agent_set_avoidance_callback`** — Always use the callback for safe velocity computation to avoid synchronization issues and "jittery" movement.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/performance/cpu_optimization.html
- https://docs.godotengine.org/en/stable/tutorials/performance/using_multiple_threads.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
