# persistent_data_preservation.gd
# Using an Autoload for scene-crossing variables [State Management]
extends Node

# EXPERT NOTE: Values in a Scene are lost when get_tree().change_scene is called. 
# Use a Singleton (Autoload) to keep state.

var player_hp: int = 100
var current_level_seed: int = 1234
var unlocked_items: Array = []

func save_state():
	# Logic to serialize variables to a config file
	pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/autoloads_versus_regular_nodes.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
# - https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — Autoload holders that survive change_scene
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — serialize Autoload state instead of scene locals
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md
# =============================================================================
