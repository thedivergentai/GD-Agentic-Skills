# focus_navigation_manager.gd
# Enabling keyboard/gamepad-only menu navigation
extends Node

# EXPERT NOTE: Ensuring focus management is vital 
# for accessibility and keyboard-only classroom environments.

func set_initial_focus(container: Control):
	var first_btn = container.find_next_valid_focus()
	if first_btn:
		first_btn.grab_focus()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		# Escape key behavior for menu exits
		pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/ui/gui_navigation.html
# - https://docs.godotengine.org/en/stable/classes/class_control.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md — ui_cancel / focus actions
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — focusable control trees
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-theming/SKILL.md — visible focus styles for classrooms
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-educational/SKILL.md
# =============================================================================
