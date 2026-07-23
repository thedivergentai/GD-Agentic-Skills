# Aurelius Protocol: Characterbody 2D NEVER List

- **NEVER use `RigidBody2D` for standard player controllers** — RigidBody is for physics-simulated objects. For responsive, feel-driven player movement, always use `CharacterBody2D`.
- **NEVER multiply `velocity` by `delta` before `move_and_slide()`** — `move_and_slide()` handles delta internally. Manual multiplication makes movement framerate-dependent [12].
- **NEVER use `global_position` updates for movement** — Use `velocity` and `move_and_slide()`. Direct position updates bypass collision detection and floor snapping.
- **NEVER ignore the return value of `move_and_slide()`** — While optional, checking `is_on_floor()` or `get_last_motion()` immediately after is critical for state logic.
- **NEVER rely on default `floor_snap_length` for fast stair-climbing** — Default snapping is too small for high-velocity characters. Use custom raycast-based stair logic for smooth transitions.
- **NEVER apply gravity while `is_on_floor()` is true** — Constant downward force on the floor can cause "micro-jitter" or prevent floor-snap from working correctly. Reset `velocity.y` to 0 or a small constant.
- **NEVER use `Area2D` for ground detection** — Real collisions (rays/shapecasts) are more precise. `is_on_floor()` is highly optimized; only augment it if necessary.
- **NEVER forget Ceiling Bonk detection** — If you don't reset `velocity.y` to 0 when `is_on_ceiling()`, the player will "float" against the ceiling until gravity pulls them down.
- **NEVER use high-precision physics for pixel art visuals** — Keep physics math high-precision, but round your Sprite nodal positions in `_process` to avoid visual sub-pixel jitter.
- **NEVER use `queue_free()` on characters every frame** — Use object pooling for bullets or enemies to avoid SceneTree performance spikes.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
