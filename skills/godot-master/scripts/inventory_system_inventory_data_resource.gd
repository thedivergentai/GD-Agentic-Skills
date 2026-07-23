# inventory_data_resource.gd
# Centralized inventory storage and logic
class_name InventoryData extends Resource

# EXPERT NOTE: Move all logic into the Resource to make it
# decoupled from any specific Node (Player vs Chest).

signal inventory_updated

@export var slots: Array[ItemSlot] = []
@export var max_weight: float = 100.0

func get_total_weight() -> float:
	var total := 0.0
	for slot in slots:
		if slot.item != null:
			total += slot.item.weight * float(slot.quantity)
	return total

## Two-pass add: fill partial stacks, then empty slots. Validates weight first.
## Returns remaining count that did not fit (0 = full success).
func add_item(new_item: InventoryItem, count: int = 1) -> int:
	if new_item == null or count <= 0:
		return count

	var projected := get_total_weight() + new_item.weight * float(count)
	if projected > max_weight + 0.0001:
		return count

	var remaining := count

	# Pass 1: partial stacks
	if new_item.stackable:
		for slot in slots:
			if remaining <= 0:
				break
			if slot.item == new_item and slot.quantity < new_item.max_stack:
				var space := new_item.max_stack - slot.quantity
				var to_add := mini(space, remaining)
				slot.quantity += to_add
				remaining -= to_add

	# Pass 2: empty slots
	if remaining > 0:
		for i in range(slots.size()):
			if remaining <= 0:
				break
			if slots[i].item == null:
				var to_add := remaining
				if new_item.stackable:
					to_add = mini(remaining, new_item.max_stack)
				var new_slot := ItemSlot.new()
				new_slot.item = new_item
				new_slot.quantity = to_add
				slots[i] = new_slot
				remaining -= to_add

	if remaining != count:
		inventory_updated.emit()
	return remaining

func remove_at(index: int) -> void:
	slots[index].item = null
	slots[index].quantity = 0
	inventory_updated.emit()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — inventory arrays owned as Resources
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — batch inventory_updated after loops
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md
# =============================================================================
