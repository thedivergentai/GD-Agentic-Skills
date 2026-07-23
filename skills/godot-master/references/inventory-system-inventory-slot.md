# Inventory Slot

```gdscript
# inventory_slot.gd
class_name InventorySlot
extends Resource

signal slot_changed

var item: Item = null
var amount: int = 0

func is_empty() -> bool:
    return item == null

func clear() -> void:
    item = null
    amount = 0
    slot_changed.emit()
```
