# string_name_optimization.gd
# Speeding up move-lookups via hashed strings
extends Node

# EXPERT NOTE: Use StringName (&"name") for high-frequency 
# lookups. It uses an internal hash for near O(1) matching.

var move_set: Dictionary = {
	&"punch": 10,
	&"kick": 15
}

func execute_move(move_name: StringName):
	if move_set.has(move_name):
		print("Executing ", move_name)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — StringName comparisons for AI/state
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md — state id tokens
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-fighting/SKILL.md
# =============================================================================
