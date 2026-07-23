# Aurelius Protocol: Genre Horror NEVER List

- NEVER maintain 100% tension at all times; strictly use a **Sawtooth Pacing** model (buildup → peak/scare → dedicated relief period) to prevent player "numbing" and exhaustion.
- NEVER rely on jump-scares as the primary source of horror; focus on atmosphere, spatial audio cues, and the *anticipation* of a threat to build genuine dread.
- NEVER make environments pitch black to the point of frustrating navigation; darkness should obscure *threats* (details), not the *floor*. Use rim lighting or a limited-battery flashlight.
- NEVER grant the player unlimited resources; survival horror relies on **Scarcity**. Limited battery, rare ammo, and slow animations are mandatory to force stressful decision-making.
- NEVER allow AI to detect the player instantly; implement a **Suspicion Meter** or a 1-3s reaction window before the AI enters full aggression to avoid "unfair cheating" feel.
- NEVER use predictable AI paths; an enemy on a perfect loop is a puzzle, not a predator. Use the **Director** to periodically "hint" a new destination near the player.
- NEVER use Area3D overlap signals for instant, frame-perfect Line-of-Sight (LoS) checks; use nodeless raycasting via `PhysicsDirectSpaceState3D.intersect_ray()` for fixed-physics sync.
- NEVER calculate complex AI vision or pathfinding for monsters far outside the camera's frustum; use `VisibleOnScreenNotifier3D` to disable processing logic.
- NEVER leave navigation avoidance layers unconfigured on chasing monsters; explicitly assign avoidance masks to prevent visual "stacking" in tight corridors.
- NEVER use the visual SceneTree (like GridContainer children) as the source of truth for inventory; strictly maintain a typed memory structure like `Dictionary[StringName, Resource]`.
- NEVER rely on instantiating standard Nodes to store base item stats/definitions; use custom `Resource` scripts to reduce memory overhead and allow direct Inspector editing.
- NEVER forget to call `duplicate(true)` on an item's Resource when adding to inventory; if items have mutable states (ammo/durability), you will overwrite the global resource otherwise.
- NEVER parse massive JSON save files synchronously; strictly offload heavy parsing to the `WorkerThreadPool` to prevent auto-save freezes.
- NEVER use standard strings for hot-path IDs (states, item types); strictly use `StringName` (&"chasing") for pointer-speed comparisons.
- NEVER evaluate exact floating-point equality (sanity == 0.0); strictly use `is_equal_approx()` or threshold checks for deterministic triggers.
- NEVER write screen-reading shaders expecting Godot 3 `SCREEN_TEXTURE`; strictly use `sampler2D` with `hint_screen_texture`.
- NEVER instantiate detailed monster meshes or lights without culling; strictly configure `visibility_range` for automatic HLOD efficiency.
- NEVER rely on AnimationPlayer for random flickering; use `Tween` for programmatic, clean energy manipulation.
- NEVER load heavy scare scenes or 4K textures synchronously via `load()`; strictly use `ResourceLoader.load_threaded_request()` to prevent frame stalls.
- NEVER scale CollisionShape3D non-uniformly; strictly adjust internal shape resource parameters (radius, height) to prevent erratic physics.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-horror/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — simulate balance impact of structural fixes
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
