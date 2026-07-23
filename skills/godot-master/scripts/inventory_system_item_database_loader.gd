# item_database_loader.gd
# Global item registry pattern
extends Node

# EXPERT NOTE: Pre-assigning unique IDs to items allows 
# the save system to store IDs instead of full resources.

var items: Dictionary = {}

func _ready():
	var dir = DirAccess.open("res://items/")
	dir.list_dir_begin()
	var filename = dir.get_next()
	while filename != "":
		if filename.ends_with(".tres"):
			var item = load("res://items/" + filename) as InventoryItem
			items[item.id] = item
		filename = dir.get_next()

func get_item(id: String) -> InventoryItem:
	return items.get(id)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_resourceloader.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/tutorials/io/runtime_file_loading_and_saving.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — id → Resource registry pattern
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — global ItemDatabase autoload ownership
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md
# =============================================================================
