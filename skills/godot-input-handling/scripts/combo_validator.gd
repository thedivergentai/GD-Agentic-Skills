# combo_validator.gd
# Timed input sequence buffer for special moves (e.g. Down, Right, Attack).
extends Node
class_name ComboValidator

var _input_buffer: Array[Dictionary] = []
@export var combo_timeout: float = 0.5

func add_input(action: StringName) -> void:
	_input_buffer.append({"action": action, "time": Time.get_ticks_msec()})
	_cleanup_buffer()
	if _check_sequence([&"move_down", &"move_right", &"attack"]):
		_execute_special_move(&"fireball")

func _cleanup_buffer() -> void:
	var now := Time.get_ticks_msec()
	_input_buffer = _input_buffer.filter(func(i): return now - i.time < (combo_timeout * 1000))

func _check_sequence(sequence: Array[StringName]) -> bool:
	if _input_buffer.size() < sequence.size():
		return false
	for i in range(sequence.size()):
		var buffer_idx := _input_buffer.size() - sequence.size() + i
		if _input_buffer[buffer_idx].action != sequence[i]:
			return false
	return true

func _execute_special_move(move_name: StringName) -> void:
	# Emit / call into combat FSM — leave move fiction free.
	pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html
# - https://docs.godotengine.org/en/stable/classes/class_input.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-fighting/SKILL.md — special-move sequence windows
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md
# =============================================================================
