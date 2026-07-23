# Aurelius Protocol: Genre Stealth NEVER List

- NEVER use binary "Seen/Not Seen" detection; strictly use a **Gradual Detection Meter** (0-100%) that builds based on distance, light level, and speed.
- NEVER use standard `RayCast3D` nodes for massive amounts of vision checks; strictly use **`PhysicsDirectSpaceState3D.intersect_ray()`** to query the PhysicsServer instantly and nodelessly.
- NEVER allow AI to see through solid geometry; strictly use raycasts between AI eyes and player sample points (Head/Torso/Feet).
- NEVER use a single sample point for visibility; strictly sample **at least 3 points** (Head, Torso, Feet) to prevent detection bugs when partially in cover.
- NEVER forget to pass the guard's own **RID** into the raycast exclude array; if omitted, the ray will hit the guard's own body, causing false blocking.
- NEVER run complex AI detection for off-screen guards; strictly use `VisibleOnScreenNotifier3D` to pause heavy logic for distant enemies.
- NEVER use a simple `distance_to()` check for hearing; strictly calculate sound travel along the **Navigation Path** to determine if a wall blocks noise.
- NEVER make combat as viable as stealth; strictly ensure "going loud" triggers intense reinforcements or high-lethality states to preserve the stealth loop.
- NEVER hide the "Why" of detection; strictly provide immediate feedback via **UI icons (?, !)** or audio barks ("What was that?").
- NEVER ignore the return value of `intersect_ray()`; strictly check `is_empty()` first to prevent runtime crashes.
- NEVER assume a raycast won't hit the guard itself; strictly **exclude the guard's RID** from Query Parameters.
- NEVER tightly couple AI to player scripts; strictly use **duck-typing** (e.g., `if body.has_method("get_detected")`) so guards can spot decoys or dead bodies without brittle dependencies.
- NEVER maintain hardcoded arrays to trigger base-wide alarms; strictly add guards to a **"guards" group** and use `get_tree().call_group()` for dynamic notification.
- NEVER use standard Strings for AI state; strictly use `StringName` (&"alert") for O(1) pointer-level comparisons in high-frequency loops.
- NEVER bake massive NavigationMeshes synchronously; strictly use `use_async_iterations` to prevent main thread stalls during runtime bakes.
- NEVER rely on `Node.find_child()` during gameplay; strictly use **Groups** or exported references for O(1) player tracking.
- NEVER leave CollisionShapes enabled on incapacitated bodies; strictly disable them or move them to a "corpse" layer to prevent pathing interference.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-stealth/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — simulate balance impact of structural fixes
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
