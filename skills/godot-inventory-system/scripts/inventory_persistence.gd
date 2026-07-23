# inventory_persistence.gd
# Saving and loading complex inventory structures
extends Node

@export var inventory: InventoryData

func save_to_file(path: String):
	# Serializing the entire Resource tree automatically
	var err = ResourceSaver.save(inventory, path)
	if err != OK:
		push_error("Inventory save failed: ", err)

func load_from_file(path: String):
	if ResourceLoader.exists(path):
		inventory = load(path)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
# - https://docs.godotengine.org/en/stable/classes/class_json.html
# - https://docs.godotengine.org/en/stable/classes/class_fileaccess.html
# - https://docs.godotengine.org/en/stable/classes/class_resourceloader.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — inventory slice of project save schema
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — serialize ids/paths not nested Resources
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md
# =============================================================================
