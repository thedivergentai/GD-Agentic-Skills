# resource_based_inventory.gd
# Managing item collections using Resource arrays
class_name Inventory extends Resource

@export var items: Array[ItemData] = []

func add_item(item: ItemData):
	items.append(item)
	emit_changed()

func remove_item(item: ItemData):
	items.erase(item)
	emit_changed()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# - https://docs.godotengine.org/en/stable/classes/class_resource.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md — full inventory UX built on Resource item arrays
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — emit_changed for bag UI refresh
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md
# =============================================================================
