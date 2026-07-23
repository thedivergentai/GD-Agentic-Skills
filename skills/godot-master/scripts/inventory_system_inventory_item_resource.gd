# inventory_item_resource.gd
# Base Resource for all inventory items
class_name InventoryItem extends Resource

# EXPERT NOTE: Defining item properties in a Resource allows 
# for creating .tres database files.

@export var id: String = ""
@export var name: String = "New Item"
@export var icon: Texture2D
@export var stackable: bool = false
@export var max_stack: int = 99
@export_multiline var description: String = ""

func use(_actor: Node) -> void:
	# Virtual method for item behavior
	pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/classes/class_resource.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# - https://docs.godotengine.org/en/stable/classes/class_texture2d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — item blueprints as composable Resources
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md — weight/stat fields on equipment items
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md
# =============================================================================
