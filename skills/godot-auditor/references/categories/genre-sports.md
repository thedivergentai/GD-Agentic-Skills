# Aurelius Protocol: Genre Sports NEVER List

- NEVER parent the ball directly to a player Transform; strictly keep it a standalone `RigidBody3D` and use `apply_central_impulse()` for **realistic dribble physics**.
- NEVER allow the ball to "Tunnel" through goals; strictly enable **Continuous CD** (`continuous_cd = true`) on the ball's properties for high-velocity validation.
- NEVER scale a `CollisionShape3D` non-uniformly; strictly adjust the resource radius to preserve the internal **moment of inertia**.
- NEVER apply impulses in `_process()`; strictly use `_physics_process()` or `_integrate_forces()` to prevent visual jitter.
- NEVER use a single collision shape for characters; strictly use **layered shapes** for Head, Torso, and Legs to enable headers and chest-traps.
- NEVER allow all AI to chase the ball ("Kindergarten Soccer"); strictly implement **Formation Slots** (Defense/Attack) where only the closest 1-2 players engage.
- NEVER use perfect goalkeeper reflexes; strictly add a **Reaction Delay** (0.2s-0.5s) and an "Error Rate" based on shot angle and velocity.
- NEVER ignore **Root Motion** for movement; strictly use `AnimationTree` with root motion to ensure momentum and turns are visually grounded.
- NEVER trust client-side goal validations; strictly require the **Authoritative Server** to validate physics and score logic.
- NEVER rely on the default physics tick rate (60 TPS) for fast-moving ballistics; strictly increase **physics_ticks_per_second** (e.g., to 120 or 240) to prevent tunneling.
- NEVER leave **Physics Interpolation** disabled if you want broadcast-quality smoothness; enable it in Project Settings to smooth ball transforms between ticks on high-refresh monitors.
- NEVER parent the ball directly to a player Transform; strictly keep it a standalone `RigidBody3D` and use `apply_central_impulse()` for **realistic dribble physics**.
- NEVER skip **vector normalization** on joystick input; strictly normalize to prevent diagonal movement from being 1.4x faster.
- NEVER handle contextual buttons with `is_action_pressed()`; strictly use a **ContextManager** to determine if Button A means "Pass", "Tackle", or "Switch".
- NEVER evaluate an `Area3D` goal trigger immediately; strictly `await get_tree().physics_frame` to allow the Physics Server to sync.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-sports/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — simulate balance impact of structural fixes
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
