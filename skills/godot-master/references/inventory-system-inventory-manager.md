# Inventory Manager

```gdscript
# inventory.gd
class_name Inventory
extends Resource

signal item_added(item: Item, amount: int)
signal item_removed(item: Item, amount: int)
signal inventory_changed

@export var slots: Array[InventorySlot] = []
@export var max_slots: int = 20
@export var max_weight: float = 100.0

func _init() -> void:
    slots.resize(max_slots)
    for i in max_slots:
        slots[i] = InventorySlot.new()

func add_item(item: Item, amount: int = 1) -> bool:
    var remaining := amount
    
    # Try stacking first
    if item.max_stack > 1:
        for slot in slots:
            if slot.item == item and slot.amount < item.max_stack:
                var space := item.max_stack - slot.amount
                var to_add := mini(space, remaining)
                slot.amount += to_add
                remaining -= to_add
                
                if remaining <= 0:
                    item_added.emit(item, amount)
                    inventory_changed.emit()
                    return true
    
    # Add to empty slots
    while remaining > 0:
        var empty_slot := find_empty_slot()
        if empty_slot == null:
            return false  # Inventory full
        
        var to_add := mini(item.max_stack, remaining)
        empty_slot.item = item
        empty_slot.amount = to_add
        remaining -= to_add
    
    item_added.emit(item, amount)
    inventory_changed.emit()
    return true

func remove_item(item: Item, amount: int = 1) -> bool:
    var remaining := amount
    
    for slot in slots:
        if slot.item == item:
            var to_remove := mini(slot.amount, remaining)
            slot.amount -= to_remove
            remaining -= to_remove
            
            if slot.amount <= 0:
                slot.clear()
            
            if remaining <= 0:
                item_removed.emit(item, amount)
                inventory_changed.emit()
                return true
    
    return false  # Not enough items

func has_item(item: Item, amount: int = 1) -> bool:
    var count := 0
    for slot in slots:
        if slot.item == item:
            count += slot.amount
    return count >= amount

func find_empty_slot() -> InventorySlot:
    for slot in slots:
        if slot.is_empty():
            return slot
    return null

func get_total_weight() -> float:
    var total := 0.0
    for slot in slots:
        if slot.item:
            total += slot.item.weight * slot.amount
    return total
```
