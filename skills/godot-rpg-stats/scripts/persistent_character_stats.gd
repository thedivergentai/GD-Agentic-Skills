# persistent_character_stats.gd
# Saving and loading character progression
extends Node

@export var stats: CharacterStats # Custom Resource

func save_stats():
	ResourceSaver.save(stats, "user://player_stats.tres")

func load_stats():
	if ResourceLoader.exists("user://player_stats.tres"):
		stats = load("user://player_stats.tres")
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
# - https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html
# - https://docs.godotengine.org/en/stable/classes/class_resourcesaver.html
# - https://docs.godotengine.org/en/stable/classes/class_resourceloader.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — full save slots around .tres progression
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — strip runtime buffs before ResourceSaver
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md
# =============================================================================
