# assessment_pause_handler.gd
# Halting simulations during quiz interactions
extends Node

# EXPERT NOTE: get_tree().paused is the efficient way 
# to freeze the world logic while keeping the UI interactive.

func open_assessment():
	get_tree().paused = true
	# Animation/Tweening the UI overlay in
	_show_quiz()

func close_assessment():
	get_tree().paused = false
	_hide_quiz()

func _show_quiz(): pass
func _hide_quiz(): pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/pausing_games.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/scene_tree.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — pause-safe lesson transitions
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md — overlay show/hide while paused
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md — assessment vs world states
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-educational/SKILL.md
# =============================================================================
