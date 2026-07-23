# skills/genre-survival/scripts/inventory_slot_data.gd
class_name InventorySlotData
extends Resource

## Inventory Slot Data (Expert Pattern)
## Separate resource for individual slots to allow easy serialization.

@export var item: Resource # Reference to ItemDefinition
@export var count: int = 0
@export var max_stack: int = 64 # Should theoretically come from Item Resource

func can_stack_with(other_slot: InventorySlotData) -> bool:
    return item == other_slot.item and item != null and count < max_stack

## EXPERT USAGE:
## Used internally by InventoryData.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/classes/class_resource.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — slot Resources for serialization
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md — stackable slot payloads
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-survival/SKILL.md
# =============================================================================
