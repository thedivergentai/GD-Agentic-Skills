# Aurelius Protocol: Genre Open World NEVER List

- NEVER prioritize Map Size over Density; empty landscapes are poor design. Strictly focus on **Points of Interest (POIs)** within every 30 seconds of travel.
- NEVER save the entire world state; strictly use **Delta Persistence** to record only unique changes (chopped trees, looted chests) to prevent massive save files.
- NEVER load large chunks or scenes synchronously; strictly use **`ResourceLoader.load_threaded_request()`** to prevent "Loading Hitches" and frame freezes.
- NEVER manipulate the active SceneTree directly from a background thread; strictly use **`call_deferred()`** to safely apply background thread chunk instantiations back to the main thread.
- NEVER keep distant, unloaded chunks in memory; strictly `queue_free()` and nullify references to prevent Out-Of-Memory (OOM) crashes.
- NEVER bake massive collision into one mesh; strictly break the world into chunks with local collision regions for efficient physics queries.
- NEVER save high-volume entity states in text formats (.tscn/.json); strictly use **Binary Serialization** (`store_var`) for high-speed I/O.
- NEVER ignore the "Floating Origin" jitter beyond 8,192 units; strictly implement a **World-Shift system** or enable **Large World Coordinates (Double Precision)** in project settings.
- NEVER process physics or AI at extreme distances; strictly use **Spatial Partitioning** to disable logic for entities in far-away, inactive chunks.
- NEVER calculate physics-sensitive state in `_process()`; strictly use `_physics_process()` for deterministic interaction at fluctuating framerates.
- NEVER spawn individual `MeshInstance3D` nodes for massive foliage; strictly use **MultiMeshInstance3D** to batch hundreds of thousands of meshes into a single GPU draw call.
- NEVER move `OccluderInstance3D` nodes at runtime; this forces a CPU BVH rebuild and causes severe micro-stuttering.
- NEVER leave `CSGShape3D` nodes active in exported builds; strictly bake them into static `ArrayMesh` geometry before shipping.
- NEVER compile complex shaders during gameplay; strictly perform "warm-up" during loading or enable project-wide caching.
- NEVER rely solely on automatic mesh decimation; strictly use **VisibilityRange (HLOD)** to substitute complex materials with cheap imposters or completely hide objects at extreme distances.
- NEVER perform global A* searches across the entire massive world; strictly use `NavigationPathQueryParameters3D` to limit pathfinding to localized active regions.
- NEVER use `find_child()` or deep tree iteration for global state (e.g., Time of Day); strictly use **Scene Groups** (`call_group()`) for optimized broadcasting.
- NEVER synchronize complex Resource types over the network; strictly serialize world changes into primitive Dictionaries or PackedByteArrays.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-open-world/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — simulate balance impact of structural fixes
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
