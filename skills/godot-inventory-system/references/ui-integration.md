# UI Integration

```gdscript
# inventory_ui.gd
extends Control

@onready var grid := $GridContainer
var inventory: Inventory

func _ready() -> void:
    inventory.inventory_changed.connect(refresh_ui)
    refresh_ui()

func refresh_ui() -> void:
    # Clear existing
    for child in grid.get_children():
        child.queue_free()
    
    # Create slot UI
    for slot in inventory.slots:
        var slot_ui := InventorySlotUI.new()
        slot_ui.setup(slot)
        grid.add_child(slot_ui)
```
