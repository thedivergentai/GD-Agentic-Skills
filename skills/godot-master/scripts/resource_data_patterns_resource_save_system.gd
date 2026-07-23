# resource_save_system.gd
# Serializing game state into .tres files
extends Node

# EXPERT NOTE: ResourceSaver can save custom Resources to disk.
# This is a very clean way to implement a save system.

func save_player_stats(stats: CharacterStats, slot: int):
	var path = "user://save_slot_%d.tres" % slot
	var err = ResourceSaver.save(stats, path)
	if err != OK:
		push_error("Failed to save stats: %d" % err)

func load_player_stats(slot: int) -> CharacterStats:
	var path = "user://save_slot_%d.tres" % slot
	if FileAccess.file_exists(path):
		return load(path) as CharacterStats
	return CharacterStats.new()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_resourcesaver.html
# - https://docs.godotengine.org/en/stable/classes/class_resourceloader.html
# - https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — slots, versions, and user:// paths around ResourceSaver
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — user:// vs res:// write rules
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md
# =============================================================================
