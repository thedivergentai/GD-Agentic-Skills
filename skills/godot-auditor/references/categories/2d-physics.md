# Aurelius Protocol: 2D Physics NEVER List

- **NEVER scale `CollisionShape2D` nodes** — Use the shape handles in the editor, NOT the Node2D scale property. Scaling causes unpredictable physics behavior and incorrect collision normals [12].
- **NEVER confuse `collision_layer` with `collision_mask`** — Layer = "What AM I?", Mask = "What do I DETECT?". Setting both to the same value is usually wrong [13].
- **NEVER multiply velocity by delta when using `move_and_slide()`** — `move_and_slide()` automatically includes timestep. Only multiply gravity/acceleration by delta [14].
- **NEVER forget `force_raycast_update()` for manual mid-frame raycasts** — Raycasts update once per physics frame. If you change target_position, you MUST force an update [15].
- **NEVER use `get_overlapping_bodies()` every frame** — It is expensive. Cache results with `body_entered`/`body_exited` signals instead [16].
- **NEVER modify `RigidBody2D` state directly in `_process`** — Use `_integrate_forces()` for safe, synchronized access to `PhysicsDirectBodyState2D` [17, 411].
- **NEVER move `PhysicsBody2D` nodes in `_process()`** — Use `_physics_process()`. Moving bodies outside the physics step causes stutter and unreliable collision detection.
- **NEVER use `RigidBody2D` for 1000+ simple entities** — Use `PhysicsServer2D` to bypass node overhead for massive performance gains (Swarms/Bullets) [18, 397].
- **NEVER use `Area2D` for high-frequency blocking (Bullets)** — Area signals can be delayed. Use `move_and_collide()` or `ShapeCast2D` for frame-perfect results [19].
- **NEVER ignore 'Physics Jitter' on high-refresh monitors** — Enable Physics Interpolation to prevent micro-stutter in motion [21, 400].
- **NEVER scale collision shapes directly at runtime** — It causes major instability. Resize the shape resource (size/radius) instead.
- **NEVER use `set_deferred` for immediate physics transform logic** — It happens at the end of the frame. Use `force_raycast_update()` or `PhysicsServer2D` instead.
- **NEVER leave Continuous CD (CCD) enabled for slow objects** — It adds significant CPU overhead. Reserve it for high-speed projectiles to prevent tunneling.
- **NEVER use a single collision layer for all tiles/entities** — Separate layers (Ground, Walls, Enemies) to allow selective filtering via masks.
- **NEVER forget to free `PhysicsServer2D` RIDs manually** — They are not garbage collected and will leak memory permanently.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
