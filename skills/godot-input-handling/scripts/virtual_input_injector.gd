# virtual_input_injector.gd
# Injects virtual hardware events into the engine pipeline for tests / tutorials.
extends Node
class_name VirtualInputInjector

func simulate_jump() -> void:
	var event := InputEventAction.new()
	event.action = &"jump"
	event.pressed = true
	Input.parse_input_event(event)
	await get_tree().create_timer(0.1).timeout
	event.pressed = false
	Input.parse_input_event(event)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_input.html
# - https://docs.godotengine.org/en/stable/classes/class_inputeventaction.html
# - https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md — CI input injection
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md
# =============================================================================
