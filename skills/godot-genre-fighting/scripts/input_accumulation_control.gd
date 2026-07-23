# input_accumulation_control.gd
# Disabling OS input merging for raw frame-perfect polling
extends Node

# EXPERT NOTE: Input accumulation merges events to the framerate. 
# Disabling it is vital for frame-perfect Fighting game inputs.

func _ready():
	# Ensuring every button press is parsed exactly as it arrived
	Input.use_accumulated_input = false

func _physics_process(_delta):
	# Optional: flush if you need absolute immediate state
	# Input.flush_buffered_events()
	pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_input.html
# - https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — sub-frame timing and accumulation policy
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-fighting/SKILL.md
# =============================================================================
