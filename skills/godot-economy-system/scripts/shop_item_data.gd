# shop_item_data.gd
# Pricing and availability for purchasables
class_name ShopItem extends Resource

# EXPERT NOTE: Shop items wrap InventoryItems with 
# pricing and stock metadata.

@export var item: InventoryItem
@export var cost: int = 100
@export var currency_id: String = "gold"
@export var initial_stock: int = -1 # -1 for infinite

var current_stock: int = 0

func _init():
	current_stock = initial_stock
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# - https://docs.godotengine.org/en/stable/classes/class_resource.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md — ShopItem wraps InventoryItem
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — priced Resource templates
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-economy-system/SKILL.md
# =============================================================================
