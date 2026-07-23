class_name SecretSequenceComboMatcher
extends Node

## Expert Time-Sensitive Combo Matcher.
## Suffix/window match against a decaying buffer (Konami-friendly prefixes).

signal combo_achieved(combo_name: String)

@export var sequences: Dictionary = {"Konami": ["ui_up", "ui_up", "ui_down", "ui_down", "ui_left", "ui_right", "ui_left", "ui_right"]}
@export var input_timeout: float = 0.5
## Only these actions enter the buffer (avoids O(all InputMap) scans).
@export var watched_actions: Array[StringName] = [
	&"ui_up", &"ui_down", &"ui_left", &"ui_right", &"ui_accept", &"ui_cancel"
]

var current_buffer: Array[String] = []
var last_input_time: float = 0.0

func _input(event: InputEvent) -> void:
	if not event.is_pressed() or event.is_echo():
		return
	for action in watched_actions:
		if event.is_action_pressed(action):
			_add_to_buffer(String(action))
			return

func _add_to_buffer(action: String) -> void:
	var current_time = Time.get_ticks_msec() / 1000.0
	if current_time - last_input_time > input_timeout:
		current_buffer.clear()
	current_buffer.append(action)
	last_input_time = current_time
	# Cap buffer to longest sequence length to bound memory
	var max_len := 1
	for combo_name in sequences:
		max_len = maxi(max_len, sequences[combo_name].size())
	if current_buffer.size() > max_len:
		current_buffer = current_buffer.slice(current_buffer.size() - max_len)
	_check_matches()

func _check_matches() -> void:
	for combo_name in sequences:
		var target: Array = sequences[combo_name]
		var n := target.size()
		if n == 0 or current_buffer.size() < n:
			continue
		# Suffix/window match — allows leading junk / partial windows
		if current_buffer.slice(current_buffer.size() - n) == target:
			combo_achieved.emit(combo_name)
			current_buffer.clear()
			return

## Rule: Always clear the buffer on a successful match to prevent double-procs.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html
# - https://docs.godotengine.org/en/stable/classes/class_inputmap.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — timeout windows vs gameplay input buffers
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — combo_achieved event bus
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-mechanic-secrets/SKILL.md
# =============================================================================
