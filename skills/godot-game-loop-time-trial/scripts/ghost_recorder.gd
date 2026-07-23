# ghost_recorder.gd
# [GDSKILLS] godot-game-loop-time-trial
# EXPORT_REFERENCE: ghost_recorder.gd

extends Node

## Samples transforms at a fixed rate. Rotation is stored as Quaternion (`"q"`)
## so replay can `slerp` without Euler gimbal lock.

@export var target_node: Node3D
@export var sample_rate: float = 0.1 # Seconds between samples

var recording: Array = []
var is_recording: bool = false
var time_elapsed: float = 0.0
var last_sample_time: float = 0.0

func start_recording() -> void:
	recording.clear()
	is_recording = true
	time_elapsed = 0.0
	last_sample_time = 0.0

func stop_recording() -> void:
	is_recording = false

func _physics_process(delta: float) -> void:
	if not is_recording or not target_node:
		return
	time_elapsed += delta
	if time_elapsed >= last_sample_time + sample_rate:
		_capture_sample()
		last_sample_time = time_elapsed

func _capture_sample() -> void:
	recording.append({
		"t": time_elapsed,
		"p": target_node.global_position,
		"q": target_node.global_basis.get_rotation_quaternion(),
	})

func get_data() -> Array:
	return recording
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/3d/using_transforms.html
# - https://docs.godotengine.org/en/stable/classes/class_quaternion.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html
# - https://docs.godotengine.org/en/stable/classes/class_node3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md — sample transforms on physics ticks with the vehicle body
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — persist get_data() samples after stop_recording
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-game-loop-time-trial/SKILL.md
# =============================================================================
