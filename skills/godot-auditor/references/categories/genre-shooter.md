# Aurelius Protocol: Genre Shooter NEVER List

- NEVER use `_process()` for hit detection; strictly use **`_physics_process()`** to maintain frame-rate independent accuracy (aiming/firing are physics events).
- NEVER apply recoil solely to the weapon model transform; strictly apply it to **Camera Rotation (kick)** and **Weapon Bloom (spread)**.
- NEVER use `Area3D` overlap for high-speed hit detection; strictly use **`PhysicsDirectSpaceState3D.intersect_ray()`** for 100x better performance.
- NEVER trust the client for hit registration in multiplayer; strictly use **Server-Authoritative** validation using lag compensation (rewinding).
- NEVER synchronize every bullet over the network; strictly use **Client-Side Prediction** for visual tracers and only send the initial "Fire" event.
- NEVER forget to exclude the player's own RID from hitscan raycasts; strictly use **`add_exception()`** to prevent shots colliding with the weapon barrel.
- NEVER use exact floating-point equality (==) for bullet damage or health; strictly use **`is_equal_approx()`** to mitigate precision loss.
- NEVER hardcode weapon statistics (Damage, Recoil) inside logic; strictly use **Resource-based WeaponData** for rapid balancing.
- NEVER use a single `AudioStreamPlayer` for gunfire; strictly use **Layered Audio** (Mechanical + Shot + Reverb Tail) for punchy feedback.
- NEVER instantiate and `free()` hundreds of projectile nodes; strictly use **Object Pooling** or the `PhysicsServer3D` API for stability.
- NEVER use `Sprite3D` for bullet impacts on surfaces; strictly use the **Decal** node for conforming, perspective-correct projection.
- NEVER use absolute pixel positioning for crosshairs; strictly rely on **Anchors & RectCenter** to ensure accuracy across resolutions.
- NEVER scale `CollisionShape3D` non-uniformly; strictly scale the **Internal Shape Resource** to maintain valid physics calculations.
- NEVER use TCP for multiplayer shooter synchronization; strictly use **ENet (UDP)** with unreliable transfer modes to avoid latency spikes.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — simulate balance impact of structural fixes
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
