# Equipment System

```gdscript
# equipment.gd
class_name Equipment
extends Resource

signal equipment_changed(slot: String, item: Item)

@export var weapon: Item = null
@export var armor: Item = null
@export var accessory: Item = null

func equip(slot: String, item: Item) -> Item:
    var old_item: Item = null
    
    match slot:
        "weapon":
            old_item = weapon
            weapon = item
        "armor":
            old_item = armor
            armor = item
        "accessory":
            old_item = accessory
            accessory = item
    
    equipment_changed.emit(slot, item)
    return old_item

func unequip(slot: String) -> Item:
    return equip(slot, null)

func get_total_stats() -> Dictionary:
    var stats := {
        "attack": 0,
        "defense": 0,
        "speed": 0
    }
    
    for item in [weapon, armor, accessory]:
        if item and item.has("stats"):
            for key in item.stats:
                stats[key] += item.stats[key]
    
    return stats
```
