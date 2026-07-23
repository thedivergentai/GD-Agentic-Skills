# Camera Expert Patterns (load on demand)

> **MANDATORY** when implementing multi-target framing, custom 3D occlusion rigs, or trauma decay tuning. Do not paste these into scenes from memory.

## Multi-target framing (WHY)

Smash-style or local-coop cameras must fit an AABB of all targets — not chase a single `global_position`. Juice shake stays on `offset` only so follow math is not overwritten.

Use [framing_box_camera_2d.gd](../scripts/camera_systems_framing_box_camera_2d.gd) — lerp center, clamp zoom to fit margin.

## Occlusion without SpringArm

When SpringArm3D is insufficient, raycast between target and ideal camera position. Exclude the target RID; offset along hit normal to prevent wall clipping.

Use [occlusion_aware_camera_3d.gd](../scripts/camera_systems_occlusion_aware_camera_3d.gd). For SpringArm-first rigs see [spring_lerp_camera_3d.gd](../scripts/camera_systems_spring_lerp_camera_3d.gd).

## Trauma decay audit

> **CAUTION:** Plot `get_trauma()` over time while tuning [camera_shake_trauma_pro.gd](../scripts/camera_systems_camera_shake_trauma_pro.gd). Raw `randf` offset demos hide whether decay feels intentional.

[trauma_debugger.gd](../scripts/camera_systems_trauma_debugger.gd) draws the last 200 samples via `_draw()`.

## 2D follow recipes (beginner → expert)

### Lerp follow

```gdscript
extends Camera2D
@export var target: Node2D
@export var follow_speed := 5.0

func _process(delta: float) -> void:
	if target:
		global_position = global_position.lerp(target.global_position, follow_speed * delta)
```

Prefer `position_smoothing_enabled` when built-in smoothing suffices.

### Look-ahead

Offset camera by `target.velocity.normalized() * look_ahead_distance` — requires velocity from [godot-characterbody-2d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md).

### Deadzone / drag

Use [deadzone_drag_margins.gd](../scripts/camera_systems_deadzone_drag_margins.gd) — enable `drag_horizontal_enabled` / margins instead of manual lerp every frame.

## 3D patterns

### Third-person orbit

Orbit with `sin/cos` on horizontal angle + `look_at(target, Vector3.UP)`. Guard vertical targets — see NEVER on `look_at` up-vector flip in SKILL.md.

### First-person mouse look

Yaw on parent, pitch on camera child with clamped pitch. Use [first_person_sway.gd](../scripts/camera_systems_first_person_sway.gd) for bob on `offset`.

## Transitions & cinematics

Tween `global_position` with `TRANS_CUBIC` / `EASE_IN_OUT`. PathFollow2D `progress_ratio` for cutscenes — see [cinematic_framing_logic.gd](../scripts/camera_systems_cinematic_framing_logic.gd) and [camera_state_machine.gd](../scripts/camera_systems_camera_state_machine.gd).

## Zoom

**WHY exponential zoom:** Linear zoom feels robotic. Use [zoom_damping_controller.gd](../scripts/camera_systems_zoom_damping_controller.gd) or wheel-driven exponential lerp.

## Minimap / split-screen

SubViewport `render_target_update_mode` must not default to always-on updates — [minimap_viewport_manager.gd](../scripts/camera_systems_minimap_viewport_manager.gd), [split_screen_setup.gd](../scripts/camera_systems_split_screen_setup.gd).
