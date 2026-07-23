# hold_toggle_accessibility.gd
# Software-side Support for 'Hold' vs 'Toggle' actions
extends Node

@export var use_toggle_sprint: bool = false
var _sprint_active: bool = false

func _physics_process(_delta: float) -> void:
	if use_toggle_sprint:
		if Input.is_action_just_pressed("sprint"):
			_sprint_active = !_sprint_active
	else:
		_sprint_active = Input.is_action_pressed("sprint")
	
	if _sprint_active:
		_apply_sprint()

func _apply_sprint():
	pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_input.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html
# - https://docs.godotengine.org/en/stable/tutorials/inputs/input_examples.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — store hold vs toggle prefs
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — settings toggle for sprint mode
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md
# =============================================================================
