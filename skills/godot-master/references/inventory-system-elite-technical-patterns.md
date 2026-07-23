# Elite Godot 4.x Patterns

### 1. Refined Partial Stacking & Overflow Logic
Decouple data from UI using `Resource` arrays. Use a two-pass approach: fill existing partial stacks first, then seek empty slots for overflow.

```gdscript
# inventory_data.gd
func add_item(item: Item, amount: int) -> int:
    var remaining := amount
    # Pass 1: Fill partial stacks
    for slot in slots:
        if slot.item == item and slot.amount < item.max_stack:
            var space := item.max_stack - slot.amount
            var to_add := mini(remaining, space)
            slot.amount += to_add
            remaining -= to_add
            if remaining == 0: break
            
    # Pass 2: Fill empty slots
    if remaining > 0:
        for slot in slots:
            if slot.is_empty():
                var to_add := mini(remaining, item.max_stack)
                slot.item = item
                slot.amount = to_add
                remaining -= to_add
                if remaining == 0: break
    
    inventory_changed.emit()
    return remaining # Returns overflow
```

### 2. Spatial Grid Inventory (Tetris-Style)
Use a `Dictionary` keyed by `Vector2i` for O(1) coordinate lookups. Items occupy multiple cells defined by a footprint.

```gdscript
# grid_inventory.gd
class_name GridInventory extends Resource

var _grid: Dictionary[Vector2i, Item] = {}

func can_place(item: Item, pos: Vector2i) -> bool:
    for offset in item.grid_footprint:
        var check_pos := pos + offset
        if _grid.has(check_pos) or is_out_of_bounds(check_pos):
            return false
    return true

func place_item(item: Item, pos: Vector2i) -> void:
    if can_place(item, pos):
        for offset in item.grid_footprint:
            _grid[pos + offset] = item
        emit_changed()
```

### 3. Safe Resource Serialization (JSON Mapping)
Avoid bloating save files with recursive Resource data. Save only the `resource_path` and use `ResourceLoader.load()` at runtime to restore references to static item blueprints.

```gdscript
# inventory_serializer.gd
func save_inventory(slots: Array[InventorySlot]) -> void:
    var data := []
    for slot in slots:
        if not slot.is_empty():
            data.append({
                "path": slot.item.resource_path,
                "amount": slot.amount
            })
    var file := FileAccess.open("user://inv.json", FileAccess.WRITE)
    file.store_string(JSON.stringify(data))

func load_inventory() -> void:
    # ... read JSON string ...
    for entry in data:
        var slot := InventorySlot.new()
        slot.item = ResourceLoader.load(entry.path) # Efficiently loads cached reference
        slot.amount = entry.amount
```
