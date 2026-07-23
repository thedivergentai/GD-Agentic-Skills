# Aurelius Protocol: Combat System NEVER List

- **NEVER use direct damage references (`target.health -= 10`)** — This bypasses armor, resistances, and invincibility logic. Always use a `DamageData` + `HealthComponent` pattern for consistent results.
- **NEVER forget invincibility frames (i-frames)** — Without them, multi-hit attacks deal damage every single frame. Always apply a brief invincibility period (0.1–0.5s) after taking a hit.
- **NEVER keep hitboxes active permanently** — This causes unintended "ghost" damage. Enable and disable hitboxes precisely using `AnimationPlayer` tracks or code-timed triggers.
- **NEVER use groups for physics-based hit filtering** — Collision layers are evaluated in C++ and are significantly faster. Groups don't restrict physics intersections adequately for high-performance combat.
- **NEVER emit damage signals without a DamageData object** — A raw number loses critical context like damage type, source, and knockback direction.
- **NEVER use try/catch blocks with validate targets** — GDScript does not support exceptions. Use `has_method(&"take_damage")` or the `is` operator for safe type checking.
- **NEVER hardcode hitstun pauses using OS.delay_msec()** — This blocks the entire OS thread and freezes the game. Use `create_tween()` or `Engine.time_scale` for visual hit-stop effects.
- **NEVER apply massive impulses to a RigidBody inside _process()** — Physics-altering impulses must happen in `_physics_process()` or `_integrate_forces()` to remain deterministic and stable.
- **NEVER couple UI lifebars directly inside the Player script** — Use a `health_changed` signal. This keeps your combat logic clean and independent of UI implementation details.
- **NEVER leave CollisionShapes active on dead entities** — Corpses will block players and towers. Disable them immediately using `set_deferred("disabled", true)`.
- **NEVER scale CollisionShapes non-uniformly** — Non-uniform scaling breaks the physics engine's collision math. Always scale the internal resource (e.g., `CircleShape2D.radius`) instead.
- **NEVER use instanced Nodes for base stat data** — Nodes carry unnecessary overhead. Use Godot's `Resource` class for lightweight, efficient, and inspectable stat containers.
- **NEVER use raw strings for elemental damage types** — Strings are slow and error-prone. Use `enum` flags (optionally with `@export_flags`) to manage multi-type damage efficiently.
- **NEVER use standard strings for state names in high-frequency loops** — Use `StringName` (&"attacking", &"stunned") to drastically improve dictionary lookups and hash comparison speeds.
- **NEVER forget to duplicate() a shared Resource stats block** — If you don't call `duplicate()` when instancing a mob, all enemies of that type will share the same health pool.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — simulate balance impact of structural fixes
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
