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
