# skills/inventory-system/code/grid_inventory_logic.gd
extends Resource
class_name GridInventory

## Grid Inventory Expert Pattern
## Implements Tetris-style cell occupancy and rotation math.

@export var grid_size: Vector2i = Vector2i(10, 8)
var _grid: Array = [] # 2D Array of item_ids or null

func _init() -> void:
    for x in grid_size.x:
        _grid.append([])
        for y in grid_size.y:
            _grid[x].append(null)

func can_place_item(item_size: Vector2i, pos: Vector2i) -> bool:
    # 1. Bounds & Occupancy Check
    if pos.x < 0 or pos.y < 0 or \
       pos.x + item_size.x > grid_size.x or \
       pos.y + item_size.y > grid_size.y:
        return false
        
    for x in range(pos.x, pos.x + item_size.x):
        for y in range(pos.y, pos.y + item_size.y):
            if _grid[x][y] != null:
                return false
    return true

func place_item(item_id: String, item_size: Vector2i, pos: Vector2i) -> void:
    if not can_place_item(item_size, pos): return
    
    for x in range(pos.x, pos.x + item_size.x):
        for y in range(pos.y, pos.y + item_size.y):
            _grid[x][y] = item_id

## EXPERT NOTE:
## For irregular shapes (L-shapes, T-shapes), use a 'BitMap' or an 
## 'Array of Vector2i' representing the relative cell offsets instead 
## of a simple 'item_size' Vector2i.
## For 'inventory-system', ALWAYS decouple the 'InventoryResource' (Data) 
## from the 'InventoryPanel' (UI). The UI should only listen to signals 
## (e.g., 'item_placed', 'item_removed') and update its visual grid accordingly.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/classes/class_resource.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — Dictionary[Vector2i] footprint maps
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — typed Vector2i keys and placement math
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md
# =============================================================================
