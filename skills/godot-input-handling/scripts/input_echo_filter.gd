# input_echo_filter.gd
# Filtering echo events for UI navigation vs Gameplay
extends Control

# EXPERT NOTE: InputEvent.is_echo() is true for auto-repeated keys.
# Never trigger gameplay actions on echo, but always allow UI movement.

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if event.is_echo():
			# Ignore hold-to-confirm if that's not desired
			return
		_do_confirm()

func _do_confirm():
	print("Confirmed!")
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_inputevent.html
# - https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html
# - https://docs.godotengine.org/en/stable/classes/class_control.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — echo OK for UI nav, not confirm
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-dialogue-system/SKILL.md — advance lines ignore key repeat
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md
# =============================================================================
