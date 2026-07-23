# ghost_replayer.gd
# [GDSKILLS] godot-game-loop-time-trial
# EXPORT_REFERENCE: ghost_replayer.gd

extends Node3D

## Replays ghost samples. Expects recorder format: `{ "t": float, "p": Vector3, "q": Quaternion }`.
## Position uses lerp; rotation uses Quaternion.slerp — never Euler lerp.

@export var ghost_visual: Node3D
@export var interpolation_enabled: bool = true

var recording_data: Array = []
var is_playing: bool = false
var playback_time: float = 0.0
var _data_size: int = 0
var _last_index: int = 0

func start_playback(data: Array) -> void:
	if data.is_empty():
		return
	recording_data = data
	_data_size = recording_data.size()
	playback_time = 0.0
	_last_index = 0
	is_playing = true
	_apply_transform(recording_data[0])
	if ghost_visual:
		ghost_visual.show()

func stop_playback() -> void:
	is_playing = false
	if ghost_visual:
		ghost_visual.hide()

func _process(delta: float) -> void:
	if not is_playing:
		return
	playback_time += delta
	if playback_time >= recording_data[_data_size - 1].t:
		_apply_transform(recording_data[_data_size - 1])
		is_playing = false
		return
	_update_transform()

func _update_transform() -> void:
	var idx := _find_keyframe_index(playback_time)
	if idx < 0:
		return
	var frame_a: Dictionary = recording_data[idx]
	var frame_b: Dictionary = recording_data[idx + 1]
	if not interpolation_enabled:
		_apply_transform(frame_a)
		return
	var duration: float = frame_b.t - frame_a.t
	if duration <= 0.0001:
		_apply_transform(frame_a)
		return
	var weight := (playback_time - frame_a.t) / duration
	var target_pos: Vector3 = frame_a.p.lerp(frame_b.p, weight)
	var rot_a := _sample_quat(frame_a)
	var rot_b := _sample_quat(frame_b)
	var target_quat := rot_a.slerp(rot_b, weight)
	if ghost_visual:
		ghost_visual.global_position = target_pos
		ghost_visual.global_basis = Basis(target_quat)

func _apply_transform(frame: Dictionary) -> void:
	if not ghost_visual:
		return
	ghost_visual.global_position = frame.p
	ghost_visual.global_basis = Basis(_sample_quat(frame))

func _sample_quat(frame: Dictionary) -> Quaternion:
	if frame.has("q"):
		return frame.q as Quaternion
	# Legacy Euler samples (`"r"`) — convert once; new recordings must store Quaternion `"q"`.
	if frame.has("r"):
		return Quaternion.from_euler(frame.r)
	return Quaternion.IDENTITY

func _find_keyframe_index(time: float) -> int:
	# Resume from last index — samples are strictly ordered by `"t"`.
	for i in range(_last_index, _data_size - 1):
		if time < recording_data[i + 1].t:
			_last_index = i
			return i
	return -1
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_quaternion.html
# - https://docs.godotengine.org/en/stable/tutorials/3d/using_transforms.html
# - https://docs.godotengine.org/en/stable/classes/class_node3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md — replay cameras following non-colliding ghost visuals
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — lerp/slerp weight math between ordered keyframes
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-game-loop-time-trial/SKILL.md
# =============================================================================
