# skills/genre-survival/code/inventory_slot_resource.gd
extends Resource
class_name InventorySlot

## Survival Inventory Expert Pattern
## Uses Resources for type-safety and modularity.

@export var item_id: String = ""
@export var quantity: int = 0
@export var max_stack: int = 99
@export var item_icon: Texture2D
@export var metadata: Dictionary = {} # Store durability, mods, etc.

func can_add(amount: int) -> bool:
    return (quantity + amount) <= max_stack

func add(amount: int) -> void:
    quantity += amount

func use() -> bool:
    if quantity > 0:
        quantity -= 1
        return true
    return false

## EXPERT NOTE:
## NEVER use a simple 'Dictionary' [id, count] for survival inventories. 
## Using a 'Resource' allows each item to store unique state (Durability, 
## Custom Names, Enchantments) and enables easy use of the Inspector 
## for balancing.
## For 'genre-survival', implement a 'Weighted Inventory' system where the 
## total weight of all Slot resources affects the player's move speed.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — durability metadata on slots
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md — weighted stack Resources
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-survival/SKILL.md
# =============================================================================
