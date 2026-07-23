# Aurelius Protocol: Physics 3D NEVER List

- **NEVER move `PhysicsBody3D` nodes in `_process()`** — Use `_physics_process()`. Moving bodies outside the physics step causes visual jitter and unreliable collision detection [12, 13].
- **NEVER scale collision shapes directly** — Scaling physics shapes causes instability, inaccurate normals, and jitter. Use the `shape` properties (height, radius, size) instead.
- **NEVER modify `RigidBody3D` transforms directly** — This ignores the physics solver. Use `apply_impulse()`, `apply_torque()`, or the `_integrate_forces()` callback for safe manipulation [17].
- **NEVER use `RigidBody3D` for platformer player controllers** — RigidBody is for objects driven by physics. For refined movement, use `CharacterBody3D` with `move_and_slide()` [move_and_slide].
- **NEVER leave Continuous CD (CCD) enabled for static meshes** — It adds heavy CPU cost. Reserve it for high-speed small objects (bullets) to prevent them from passing through walls.
- **NEVER use `PhysicsServer3D` RIDs without manual cleanup** — RIDs are not garbage collected. If you create bodies via the server, you MUST call `free_rid()` when done to avoid memory leaks.
- **NEVER use `RayCast3D` for precise ground detection on stairs** — A single ray is too thin. Use `ShapeCast3D` with a cylinder or sphere shape to detect walkable steps reliably [Stair Logic].
- **NEVER rely on `VehicleBody3D` for non-racing arcade vehicles** — It's a complex sim. For arcade hovercraft or simple cars, a custom `CharacterBody3D` with Raycasts is often easier to tune.
- **NEVER forget to set `collision_layer` and `collision_mask` properly** — If everything is on layer 1, performance will tank from redundant checks. Categorize your world.
- **NEVER use `Area3D` for high-frequency blocking** — Areas are for detection. For walls/barriers, use `StaticBody3D` to ensure immediate, robust containment.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/performance/cpu_optimization.html
- https://docs.godotengine.org/en/stable/tutorials/performance/general_optimization.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
