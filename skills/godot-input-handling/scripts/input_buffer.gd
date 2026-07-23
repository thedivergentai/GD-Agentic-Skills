# skills/input-handling/scripts/input_buffer.gd
extends Node

## Input Buffer Expert Pattern
## Buffers inputs for responsive controls - press jump 100ms before landing? Still registers.

class_name InputBuffer

var _buffer: Dictionary = {}  # action_name → buffer time remaining
@export var buffer_duration: float = 0.15  # 150ms

func _physics_process(delta: float) -> void:
	# Decay on the physics tick so buffer windows match CharacterBody consumption,
	# not render FPS (avoids short windows vanishing on hitch frames).
	for action in _buffer.keys():
		_buffer[action] -= delta
		if _buffer[action] <= 0:
			_buffer.erase(action)

func buffer_action(action_name: String) -> void:
	_buffer[action_name] = buffer_duration

func is_action_buffered(action_name: String) -> bool:
	return action_name in _buffer

func consume_action(action_name: String) -> bool:
	if action_name in _buffer:
		_buffer.erase(action_name)
		return true
	return false

## EXPERT USAGE:
## In _unhandled_input():
##   if Input.is_action_just_pressed("jump"):
##     input_buffer.buffer_action("jump")
##
## In _physics_process():
##   if is_on_floor() and input_buffer.consume_action("jump"):
##     velocity.y = JUMP_VELOCITY
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html
# - https://docs.godotengine.org/en/stable/classes/class_input.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-platformer/SKILL.md — jump/dash buffer windows
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md — consume buffer on floor contact
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md
# =============================================================================
