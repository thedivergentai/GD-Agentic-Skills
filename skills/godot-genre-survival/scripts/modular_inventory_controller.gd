extends Node
class_name ModularInventoryController

## Expert Inventory System (Godot 4.7).
## Uses ItemResources for data and InventorySlots for state tracking.

var slots: Array[InventorySlot] = []

class InventorySlot extends RefCounted:
	var item: Resource # ItemResource
	var amount: int = 0
	func _init(i, a): item = i; amount = a

func add_item(item_res: Resource, amount: int) -> void:
	# 1. Merge into existing slots
	for slot in slots:
		if slot.item == item_res and slot.amount < item_res.max_stack:
			var can_take = item_res.max_stack - slot.amount
			var take = mini(can_take, amount)
			slot.amount += take
			amount -= take
			if amount <= 0: return

	# 2. Add as new slots
	while amount > 0:
		var take = mini(item_res.max_stack, amount)
		slots.append(InventorySlot.new(item_res, take))
		amount -= take

## [SKILL NOTICE]: Use 'ItemResource' files for static data and 
## 'InventorySlot' objects for items currently in the bag to avoid 
## modifying shared resource files during gameplay.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/classes/class_refcounted.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md — stack merge / bag controllers
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — ItemResource vs slot state
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-survival/SKILL.md
# =============================================================================
