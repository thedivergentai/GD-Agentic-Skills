class_name VRLocomotionHandler
extends Node

## Expert locomotion handler with Snap Turning and Comfort Vignette.
## Prevents motion sickness by narrowing FOV during rotation.

@export var player_origin: XROrigin3D
@export var comfort_vignette: CanvasItem # A black overlay with a hole

var _is_rotating := false

func perform_snap_turn(angle_deg: float) -> void:
	if _is_rotating: return
	
	_is_rotating = true
	_show_vignette(true)
	
	# Rotate the origin around the camera's local Y axis
	player_origin.rotate_y(deg_to_rad(angle_deg))
	
	await get_tree().create_timer(0.1).timeout
	_show_vignette(false)
	_is_rotating = false

func _show_vignette(visible: bool) -> void:
	if comfort_vignette:
		comfort_vignette.visible = visible

## Accessibility teleport: move XROrigin3D to a validated floor hit.
## Failure modes to handle in callers:
## - Guardian clip: reject targets outside XRServer play-area bounds (see vr_safety_guardian_warner.gd).
## - Focus pause: never teleport while get_tree().paused / headset focus lost (see vr_headset_focus_guard.gd).
func teleport_to(target_global: Vector3) -> bool:
	if get_tree().paused:
		return false
	if player_origin == null:
		return false
	var bounds := XRServer.get_reference_frame_bounds_2d()
	if bounds.size != Vector2.ZERO:
		var local := player_origin.to_local(target_global)
		if not bounds.has_point(Vector2(local.x, local.z)):
			return false
	_show_vignette(true)
	player_origin.global_position = target_global
	await get_tree().create_timer(0.05).timeout
	_show_vignette(false)
	return true

## Rule: Always provide 'Snap Turn' + teleport as VR comfort defaults.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/xr/basic_xr_locomotion.html
# - https://docs.godotengine.org/en/stable/classes/class_xrorigin3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md — rotate origin around headset/camera Y
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md — comfort vignette overlays during turns
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-vr/SKILL.md
# =============================================================================
