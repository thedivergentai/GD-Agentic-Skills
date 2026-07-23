# input_replay_buffer.gd
# Captures and replays deterministic input streams (debug / ghost data).
extends Node
class_name InputReplayBuffer

var _recorded_events: Array[Dictionary] = []
var _is_replaying: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if _is_replaying:
		return
	_recorded_events.append({
		"frame": Engine.get_frames_drawn(),
		"event": event.duplicate()
	})

func start_replay() -> void:
	_is_replaying = true
	var start_frame := Engine.get_frames_drawn()
	for entry in _recorded_events:
		var target_frame: int = entry.frame
		while Engine.get_frames_drawn() < start_frame + target_frame:
			await get_tree().process_frame
		Input.parse_input_event(entry.event)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_input.html
# - https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md — deterministic replay harnesses
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-racing/SKILL.md — ghost playback consumers
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md
# =============================================================================
