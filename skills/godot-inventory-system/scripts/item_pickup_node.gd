# item_pickup_node.gd
# World-to-Inventory bridge
extends Area2D

@export var item_data: InventoryItem
@export var count: int = 1

func _on_body_entered(body: Node2D):
	if body.has_method("get_inventory"):
		var inv = body.get_inventory() as InventoryData
		if inv.add_item(item_data, count):
			queue_free()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/using_area_2d.html
# - https://docs.godotengine.org/en/stable/classes/class_area2d.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — world drops after combat rewards
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — pickup → inventory grant signals
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md
# =============================================================================
