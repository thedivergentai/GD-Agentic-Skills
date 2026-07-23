# unhandled_input_priority.gd
# Expert use of _unhandled_input across the tree [26]
extends Node2D

# 1. _input() -> Global (always)
# 2. Control._gui_input() -> UI only
# 3. _unhandled_input() -> Gameplay (only if UI didn't use it)
# 4. _unhandled_key_input() -> Shortcuts

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		# This interaction only triggers if the player didn't 
		# just click a 'Use' button on a menu!
		_check_interaction()

func _check_interaction():
	pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html
# - https://docs.godotengine.org/en/stable/classes/class_control.html
# - https://docs.godotengine.org/en/stable/classes/class_viewport.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — menus accept_event before gameplay
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — interact only when UI idle
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md
# =============================================================================
