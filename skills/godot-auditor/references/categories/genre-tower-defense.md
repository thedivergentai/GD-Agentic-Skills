# Aurelius Protocol: Genre Tower Defense NEVER List

- NEVER make all towers have the same niche; strictly ensure distinct specialties: **Aura Slow**, **Armor Piercing**, **Anti-Air**, **Burst Sniper**, and **Splash Damage**.
- NEVER allow a "Death Spiral" with no exit; strictly provide small **comeback bonuses** or interest on saved gold to prevent early inevitable failure.
- NEVER make early waves feel like busywork; strictly provide an **"Early Call" bonus** to skip wait times and accelerate engagement.
- NEVER trust client-side economy updates; strictly require the **authoritative server** to validate currency addition and tower purchases in co-op.
- NEVER allow the player to "Seal" the exit in mazing games; strictly validate path existence with **`NavigationServer2D.map_get_path()`** before finalizing tower placement.
- NEVER use synchronous `bake_navigation_polygon()` for mazing; strictly offload to a **worker thread** to prevent 100ms+ frame hitches during placement.
- NEVER use global coordinates for grid logic; strictly convert to **Vector2i/Vector3i** to ensure pixel-perfect tower alignment.
- NEVER call `get_overlapping_bodies()` every frame; strictly use **signals** (`body_entered`/`body_exited`) to maintain a local target cache.
- NEVER use `_process()` for projectile movement if count > 500; strictly use the **PhysicsServer2D/3D** directly for high-performance bullet-hell tiers.
- NEVER spawn hundreds of projectiles as full Nodes; strictly use **Object Pooling** to reuse resources and avoid garbage collection stutters.
- NEVER use standard Strings for priorities; strictly use `StringName` (&"first", &"strongest") for O(1) hash comparisons in targeting loops.
- NEVER ignore the `progress` property on PathFollow nodes; strictly use it as the O(1) way to identify the **target closest to exit**.
- NEVER process tower search logic every frame; strictly **throttle ACQUIRE searches** (e.g., every 5-10 frames) to save significant CPU cycles.
- NEVER scale Tower `CollisionShape` non-uniformly; strictly adjust the radius property of the Shape resource to preserve collision math.
- NEVER delete enemies immediately on death; strictly use **set_deferred("disabled", true)** and wait one frame to prevent physics server crashes.
- NEVER hardcode waves in huge switch statements; strictly use **Custom Resources (.tres)** for clean balancing and sequence editing.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-tower-defense/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — simulate balance impact of structural fixes
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
