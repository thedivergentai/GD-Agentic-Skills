# analog_deadzone_manager.gd
# Expert radial deadzone management for analog sticks [24]
extends Node

# PROBLEM: Axial deadzones (X/Y separately) cause "cross-shaped" deadzones.
# SOLUTION: Radial deadzone (vector length) provides a circular, natural feel.

@export var deadzone: float = 0.2

func get_movement_vector() -> Vector2:
	var raw = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if raw.length() < deadzone:
		return Vector2.ZERO
	
	# Optional: Scaled Radial Deadzone (remaps 0.2..1.0 to 0.0..1.0)
	return raw.normalized() * ((raw.length() - deadzone) / (1.0 - deadzone))
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_input.html
# - https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html
# - https://docs.godotengine.org/en/stable/classes/class_inputeventjoypadmotion.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md — radial stick → move_and_slide
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-console/SKILL.md — pad feel on console targets
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md
# =============================================================================
