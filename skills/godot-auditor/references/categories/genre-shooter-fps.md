# Aurelius Protocol: Genre Shooter Fps NEVER List

- NEVER use `_process()` for hit detection; strictly use `_physics_process()` to maintain frame-rate independent accuracy.
- NEVER apply recoil to the physical weapon model; strictly apply it to **Camera Rotation (kick)** and **Weapon Bloom (spread)**.
- NEVER trust the client for hit registration in multiplayer; strictly use **Server-Authoritative** validation with lag compensation.
- NEVER synchronize every bullet over the network; strictly use **Client-Side Prediction** and send only initial "Fire" events.
- NEVER use `Area3D` or `move_and_collide()` for high-speed ballistics; strictly use `PhysicsDirectSpaceState3D.intersect_ray()` for 100x better performance.
- NEVER forget to exclude the player's own RID from hitscan raycasts; otherwise, shots will collide instantly with the barrel.
- NEVER use exact floating-point equality (==) for weapon cooldowns or timers; strictly use `is_equal_approx()`.
- NEVER use a single `AudioStreamPlayer` for gunfire; strictly use **Layered Audio** (Mechanical + Shot + Reverb Tail).
- NEVER instantiate and `free()` hundreds of projectile nodes; strictly use **Object Pooling** or the `RenderingServer`.
- NEVER use `Sprite3D` or `QuadMesh` for bullet impacts; strictly use the **Decal** node for surface-conforming texture projection.
- NEVER leave decals in the scene indefinitely; strictly implement a fade-out and cleanup cycle.
- NEVER use `Transform3D.looking_at()` for forward shooting vectors; strictly extract the direction from `-transform.basis.z`.
- NEVER multiply velocity by `delta` before `move_and_slide()`; the method internalizes the timestep automatically.
- NEVER poll mouse motion inside `_physics_process()`; strictly use `_input()` for zero-latency camera look.
- NEVER accumulate mouse rotation directly onto a `Transform3D`; strictly store **Yaw/Pitch variables** to avoid gimbal lock.
- NEVER hardcode weapon statistics (Damage, Recoil) inside logic; strictly use **Resource-based WeaponData** for balancing.
- NEVER tightly couple damage logic to specific classes; strictly use **Duck-Typing** (`has_method("take_damage")`) for environment interactivity.
- NEVER use standard Strings for high-frequency state identifiers; strictly use `StringName` (e.g., `&"reloading"`).
- NEVER use the `!` (NOT) operator in AnimationTree expressions; strictly use `is_firing == false`.
- NEVER connect weapon signals via string-based calls; strictly use **Signal-Object syntax** (`fired.connect`).
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter-fps/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — simulate balance impact of structural fixes
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
