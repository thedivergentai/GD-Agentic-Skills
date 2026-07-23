# Save/Load

```gdscript
func save_inventory() -> Dictionary:
    return {
        "slots": slots.map(func(s): return s.to_dict())
    }

func load_inventory(data: Dictionary) -> void:
    for i in data.slots.size():
        slots[i].from_dict(data.slots[i])
    inventory_changed.emit()
```
