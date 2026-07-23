# Aurelius Protocol: Game Loop Waves NEVER List

- **NEVER iterate through get_children() to find all enemies** — This is extremely slow. Always add enemies to an "enemies" group and use `get_tree().get_nodes_in_group(&"enemies")` for efficient access.
- **NEVER constantly instantiate() and queue_free() hundreds of enemies** — This causes garbage collection stutters. Use an object pool to reuse existing enemy instances.
- **NEVER spawn thousands of separate MeshInstance3D nodes for swarms** — This will tank your draw calls. Use `MultiMeshInstance3D` to batch thousands of meshes into a single GPU call.
- **NEVER calculate pathfinding for hundreds of agents on the main thread** — This will freeze your game. Enable `use_async_iterations` on your navigation regions or use `NavigationServer3D.query_path()`.
- **NEVER forget to check is_inside_tree() before adding a child** — If the spawner is queued for deletion, adding a child will crash. Always verify the spawner is still active in the tree.
- **NEVER assign a preloaded resource (like stats.tres) directly to spawned mobs** — They will all share the exact same health/stats. Always call `base_stats.duplicate_deep()` to give each mob its own unique data.
- **NEVER use standard strings for high-frequency group calls** — Always use `StringName` (&"enemies", &"take_damage") for optimal hash performance and to avoid unnecessary string allocations.
- **NEVER spawn entities directly inside physics callbacks synchronously** — Instantiating nodes during physics steps can corrupt the physics state. Always use `call_deferred(&"add_child", enemy)`.
- **NEVER leave CollisionShapes on dead enemies active** — Corpses will block towers and navigation. Use `set_deferred("disabled", true)` immediately upon death.
- **NEVER synchronize complex Object types via MultiplayerSynchronizer** — It only supports primitive types. For complex data, sync a UID or ID and look up the data locally on the client.
- **NEVER auto-start waves without player feedback** — Always provide a UI countdown, a visual "Wave Incoming" effect, or a start button to maintain player agency.
- **NEVER hardcode spawn positions at (0,0,0)** — Use `Marker3D` nodes in the editor so you can visually adjust spawn points without digging into code.
- **NEVER check wave completion by counting children every frame** — It's too expensive. Maintain a local counter or use a signal-based system to track active enemy counts.
- **NEVER use the same navigation map for every entity type** — If you have flying and walking enemies, use separate navigation maps to prevent pathing issues.
- **NEVER scale collision shapes non-uniformly for spawners** — This breaks the collision detection math. Adjust the shape resource properties instead.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-game-loop-waves/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
