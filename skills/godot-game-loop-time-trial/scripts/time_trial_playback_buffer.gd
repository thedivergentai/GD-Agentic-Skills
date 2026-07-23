class_name TimeTrialPlaybackBuffer
extends Node

## Handles ghost playback with a jitter buffer for network-streamed data.
## Ensures smooth playback even if packets arrive out of order or in bursts.

@export var buffer_time: float = 0.5 # Seconds to buffer before starting playback
@export var ghost_visual: Node3D

var _incoming_buffer: Array[Dictionary] = []
var _is_playing: bool = false
var _playback_time: float = 0.0
var _buffer_filled: bool = false

## Call this whenever a new ghost frame arrives from the network.
func push_frame(time: float, transform: Transform3D) -> void:
	_incoming_buffer.append({"t": time, "xform": transform})
	# Keep buffer sorted by time
	_incoming_buffer.sort_custom(func(a, b): return a.t < b.t)
	
	if not _is_playing and _get_buffer_duration() >= buffer_time:
		_buffer_filled = true
		_start_playback()

func _process(delta: float) -> void:
	if not _is_playing:
		return
		
	_playback_time += delta
	_update_ghost_transform()

func _start_playback() -> void:
	if _incoming_buffer.is_empty(): return
	_playback_time = _incoming_buffer[0].t
	_is_playing = true

func _update_ghost_transform() -> void:
	if _incoming_buffer.size() < 2: return
	
	# Find interpolation frames
	var frame_a = _incoming_buffer[0]
	var frame_b = _incoming_buffer[1]
	
	# Remove old frames that are behind the playback head
	while _incoming_buffer.size() > 2 and _incoming_buffer[1].t < _playback_time:
		_incoming_buffer.remove_at(0)
		frame_a = _incoming_buffer[0]
		frame_b = _incoming_buffer[1]
	
	if ghost_visual and frame_a.t <= _playback_time:
		var span = frame_b.t - frame_a.t
		var weight = (_playback_time - frame_a.t) / span if span > 0 else 0.0
		ghost_visual.global_transform = frame_a.xform.interpolate_with(frame_b.xform, weight)

func _get_buffer_duration() -> float:
	if _incoming_buffer.size() < 2: return 0.0
	return _incoming_buffer[-1].t - _incoming_buffer[0].t
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_transform3d.html
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
# - https://docs.godotengine.org/en/stable/classes/class_multiplayerpeer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md — unreliable streamed frames that need a jitter buffer
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md — snapshot/interpolation patterns for remote ghosts
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-game-loop-time-trial/SKILL.md
# =============================================================================
