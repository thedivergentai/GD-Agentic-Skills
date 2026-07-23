# persistent_data_holder.gd
# Keeping data alive across scene changes
extends Node

# EXPERT NOTE: Values in Autoloads survive SceneTree.change_scene_to_file().
# Use for player inventory, settings, and quest progress.

var inventory: Array[String] = []
var settings: Dictionary = {"volume": 0.8, "fullscreen": false}

func add_item(item: String):
	inventory.append(item)
	print("Items persistent: ", inventory)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
# - https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/change_scenes_manually.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — serialize inventory/settings from this holder
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md — cross-scene inventory consumer
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — data that must survive change_scene
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md
# =============================================================================
