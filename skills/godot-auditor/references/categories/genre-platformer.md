# Aurelius Protocol: Genre Platformer NEVER List

- NEVER multiply velocity by `delta` before `move_and_slide()`; the method internalizes the timestep.
- NEVER skip **Coyote Time** (approx 0.1s); without this grace period, jumps will feel unresponsive when walking off ledges.
- NEVER ignore **Jump Buffering** (approx 0.15s); players expect to jump the instant they touch the ground if they pressed the button early.
- NEVER use a fixed jump height; strictly implement **Variable Jump Height** (cut velocity on release) for player expression.
- NEVER forget to scale gravity by `delta` before adding to velocity; gravity is an acceleration and must be frame-rate independent.
- NEVER rely on discrete collision for high-speed movement; strictly use `CCD_MODE_CAST_RAY` to prevent tunneling through geometry.
- NEVER use `move_and_collide()` for standard traversal; it lacks the slope/stair handling of `move_and_slide()`.
- NEVER check coyote or buffer timers using exact equality (== 0.0); strictly use `is_equal_approx()` or `>= 0.0`.
- NEVER use linear camera snapping; strictly use **Camera Smoothing** or `lerp()` to prevent motion sickness.
- NEVER skip **Squash and Stretch** on jump/land; movement feels weightless without these subtle visual "juice" cues.
- NEVER create **Blind Jumps**; strictly use camera look-ahead or zoom triggers to reveal landing zones.
- NEVER use individual `Sprite2D` nodes for level geometry; strictly use **TileMapLayer** for optimized collision and rendering.
- NEVER use complex/concave `CollisionShape2D` for the player; strictly favor primitive shapes (Capsule/Rectangle) for stability.
- NEVER use `CharacterBody2D` for simple moving platforms; strictly use **AnimatableBody2D** and enable `sync_to_physics`.
- NEVER ignore `platform_on_leave` for descending platforms; use `PLATFORM_ON_LEAVE_ADD_UPWARD_VELOCITY` to preserve jump impulse.
- NEVER disable `recovery_as_collision` on the player character; it is required for correct floor snapping reports.
- NEVER use the `!` (NOT) operator in AnimationTree expressions; strictly use `is_walking == false`.
- NEVER use standard Strings for high-frequency state checks; strictly use `StringName` (e.g., `&"jumping"`).
- NEVER load heavy level chunks synchronously; strictly use `ResourceLoader.load_threaded_request()` to prevent frame stutters.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-platformer/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — simulate balance impact of structural fixes
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
