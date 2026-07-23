extends Node3D
class_name AimAssist

## Controller friction + magnetism near targets. Tune assist_angle to avoid mouse feel on PC builds.

@export var assist_range: float = 50.0
@export var assist_angle: float = 15.0
@export var friction_strength: float = 0.3
@export var magnetism_strength: float = 0.1


func apply_aim_assist(look_input: Vector2, camera: Camera3D) -> Vector2:
	var target := _find_closest_target(camera)
	if target == null:
		return look_input
	var to_target: Vector3 = target.global_position - camera.global_position
	var camera_forward := -camera.global_basis.z
	var angle := rad_to_deg(camera_forward.angle_to(to_target.normalized()))
	if angle > assist_angle:
		return look_input
	var friction := 1.0 - (friction_strength * (1.0 - angle / assist_angle))
	look_input *= friction
	var target_screen_pos := camera.unproject_position(target.global_position)
	var screen_center := get_viewport().get_visible_rect().size * 0.5
	var pull_direction := (target_screen_pos - screen_center).normalized()
	look_input += pull_direction * magnetism_strength * (1.0 - angle / assist_angle)
	return look_input


func _find_closest_target(camera: Camera3D) -> Node3D:
	var closest: Node3D = null
	var closest_angle := assist_angle
	for target: Node3D in get_tree().get_nodes_in_group(&"enemies"):
		var to_target: Vector3 = target.global_position - camera.global_position
		var angle := rad_to_deg((-camera.global_basis.z).angle_to(to_target.normalized()))
		if angle < closest_angle and to_target.length() < assist_range:
			closest = target
			closest_angle = angle
	return closest
# ---
# GDSkills research links (agents)
# Docs:
# - https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html — analog look + deadzones
# Related:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter-fps/SKILL.md — friction 0.3 + magnetism 0.1 baseline
# ---
