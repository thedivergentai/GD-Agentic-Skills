# hit_stop_controller.gd
# Simulating fighter "impact freeze" via time scale
extends Node

# EXPERT NOTE: Hit-stop adds "juice" and impact feel. 
# Temporarily slowing Engine.time_scale provides immediate feedback.

func apply_hit_stop(duration: float = 0.1):
	Engine.time_scale = 0.0
	await get_tree().create_timer(duration, true, false, true).timeout # Process during pause
	Engine.time_scale = 1.0
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_engine.html
# - https://docs.godotengine.org/en/stable/classes/class_scenetreetimer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — hit-stop thaw timers ignore_time_scale
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-fighting/SKILL.md
# =============================================================================
