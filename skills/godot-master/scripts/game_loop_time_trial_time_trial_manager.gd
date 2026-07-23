# time_trial_manager.gd
# [GDSKILLS] godot-game-loop-time-trial
# EXPORT_REFERENCE: time_trial_manager.gd

extends Node

## Central race clock using microsecond wall time (or optional physics-frame counts).
## Wire checkpoint / finish Area* body_entered from `_physics_process` (or physics signals),
## never from visual `_process` alone — lag can skip finish frames.

signal lap_started()
signal lap_finished(time_usec: int, is_new_best: bool)
signal checkpoint_passed(index: int, split_usec: int)

@export var use_physics_frame_clock: bool = false

var best_time_usec: int = -1
var lap_start_usec: int = 0
var lap_start_physics_frame: int = 0
var current_lap_usec: int = 0
var is_racing: bool = false
var current_checkpoint_index: int = -1
var total_checkpoints: int = 0

func setup_track(checkpoints_count: int) -> void:
	total_checkpoints = checkpoints_count
	current_checkpoint_index = -1

func start_lap() -> void:
	is_racing = true
	current_checkpoint_index = -1
	current_lap_usec = 0
	if use_physics_frame_clock:
		lap_start_physics_frame = Engine.get_physics_frames()
	else:
		lap_start_usec = Time.get_ticks_usec()
	lap_started.emit()

func get_elapsed_usec() -> int:
	if not is_racing:
		return current_lap_usec
	if use_physics_frame_clock:
		var frames := Engine.get_physics_frames() - lap_start_physics_frame
		var hz := float(Engine.physics_ticks_per_second)
		return int((float(frames) / hz) * 1_000_000.0)
	return Time.get_ticks_usec() - lap_start_usec

## Call from Area body_entered / physics overlap handlers only.
func pass_checkpoint(index: int) -> void:
	if not is_racing:
		return
	if index != current_checkpoint_index + 1:
		return
	current_checkpoint_index = index
	current_lap_usec = get_elapsed_usec()
	checkpoint_passed.emit(index, current_lap_usec)
	if index == total_checkpoints - 1:
		_finish_lap()

func _finish_lap() -> void:
	is_racing = false
	current_lap_usec = get_elapsed_usec()
	var is_best := best_time_usec < 0 or current_lap_usec < best_time_usec
	if is_best:
		best_time_usec = current_lap_usec
	lap_finished.emit(current_lap_usec, is_best)

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_time.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html
# - https://docs.godotengine.org/en/stable/classes/class_node.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — lap/split/finish signals from ordered checkpoint validation
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md — Area gates that feed pass_checkpoint indices
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-game-loop-time-trial/SKILL.md
# =============================================================================
