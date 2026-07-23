# Movement Recipes & Collision (load on demand)

> **MANDATORY** when implementing top-down/tank controllers, slide-collision response, moving platforms, or debug-tuning jump arcs. Platformer foundation → [expert_physics_2d.gd](../scripts/characterbody_2d_expert_physics_2d.gd) first — do not duplicate coyote/buffer inline.

## Platformer golden path

1. [expert_physics_2d.gd](../scripts/characterbody_2d_expert_physics_2d.gd) — coyote, buffer, accel/friction
2. Add [variable_jump_height.gd](../scripts/characterbody_2d_variable_jump_height.gd), wall/dash scripts only after base feels right

**WHY no `velocity * delta` before `move_and_slide()`:** CharacterBody integrates delta internally — manual multiply causes framerate-dependent speed.

## Top-down 8-way

```gdscript
var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
if input_vector != Vector2.ZERO:
    velocity = velocity.move_toward(input_vector * SPEED, ACCELERATION * delta)
else:
    velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
move_and_slide()
```

Normalize diagonals via `Input.get_vector` — do not add raw axis floats.

## Tank controls

Rotate with `Input.get_axis("rotate_left", "rotate_right")`; drive along `transform.x * move_direction * SPEED`.

## Collision after slide

```gdscript
move_and_slide()
for i in get_slide_collision_count():
    var collision := get_slide_collision(i)
    # wall jump normals, bounce groups, platform velocity
```

**Moving platforms:** after `move_and_slide()`, if `is_on_floor()`, add `get_platform_velocity()` to velocity — prevents stutter on elevators.

## One-way platforms — NEVER `position.y += 1`

Correct recipe (also in SKILL.md): one-way on **platform collider**, layer/mask drop-through while holding down+jump, restore on next physics frames. `position` nudges bypass `move_and_slide` floor rules.

## Floor tuning exports

```gdscript
floor_max_angle = deg_to_rad(45)
floor_snap_length = 8.0  # raise for fast characters + custom stair rays
motion_mode = MOTION_MODE_GROUNDED
```

Default snap is too small for high-velocity stair climbing — use [slope_stair_snapping.gd](../scripts/characterbody_2d_slope_stair_snapping.gd).

## State machine vs monolith

Dash/air states → [dash_state_controller.gd](../scripts/characterbody_2d_dash_state_controller.gd) + [godot-state-machine-advanced](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md). Avoid giant `_physics_process` match blocks.

## Game-feel debug

[game_feel_profiler.gd](../scripts/characterbody_2d_game_feel_profiler.gd) — `_draw()` polyline of recent positions + velocity vector while tuning exports.

## Root motion

[root_motion_controller.gd](../scripts/characterbody_2d_root_motion_controller.gd) — `animation_tree.get_root_motion_position()` → 2D velocity.

## Common gotchas

| Issue | Fix |
|-------|-----|
| Slope slide | Raise `FRICTION` on ground |
| Double jump exploit | `can_jump` reset only on `is_on_floor()` |
| Ceiling float | Reset `velocity.y` on `is_on_ceiling()` — [ceiling_bonk_detection.gd](../scripts/characterbody_2d_ceiling_bonk_detection.gd) |
| Pixel jitter | Round **sprite** in `_process` — [subpixel_movement_rounding.gd](../scripts/characterbody_2d_subpixel_movement_rounding.gd) |
