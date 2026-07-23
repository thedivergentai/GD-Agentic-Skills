# item_slot_data.gd
# Data structure for a single inventory slot
class_name ItemSlot extends Resource

# EXPERT NOTE: Using a Resource for slots makes the 
# inventory system serializable and easy to sync with UI.

signal changed

@export var item: InventoryItem:
	set(val):
		item = val
		changed.emit()

@export var quantity: int = 1:
	set(val):
		quantity = val
		changed.emit()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_resource.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — slot_changed without UI coupling
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — reactive slot Resource pattern
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md
# =============================================================================
