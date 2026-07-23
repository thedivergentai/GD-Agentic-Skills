# Aurelius Protocol: Raycasting Queries NEVER List

- **NEVER access `direct_space_state` outside of `_physics_process()`** — The physics space can be locked or running on a separate thread; querying it in `_process()` is unsafe [1, 2].
- **NEVER use ShapeCast when a thin RayCast is sufficient** — Volume queries are significantly more expensive. Default to rays unless you need volumetric detection [3, 4].
- **NEVER assume results return `CollisionObject` nodes** — CSG shapes, `GridMap`, and `TileMapLayer` return themselves, not a generic physics body [5, 6].
- **NEVER assume `RayCast` nodes update instantly** — They update once per physics frame. If you move a node and query it immediately, you MUST call `force_raycast_update()` [3, 9].
- **NEVER use complex visual meshes for physics queries** — GPU-only data requires expensive thread locking to parse. Use simplified primitive collision shapes [10, 11].
- **NEVER iterate results to find the first valid hit** — Use `collision_mask` and `collision_layer` to filter queries at the server level for maximum performance.
- **NEVER forget to exclude the caster** — A ray starting from the center of a character will hit the character itself. Use `query.exclude = [self.get_rid()]` [20].
- **NEVER use rays for small, fast detection areas** — Rays can "tunnel" through thin walls if the frame rate drops. Use `cast_motion` or high-frequency stepping for bullets.
- **NEVER query 1000+ rays individually in GDScript** — Batch your queries or use the `PhysicsServer` directly in C++ if you reach extreme query counts.
- **NEVER ignore the `result.rid`** — RIDs are the fastest way to identify and exclude objects in subsequent queries, bypassing node-path lookups [20].
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
