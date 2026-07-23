# Architecture Overview

### 1. Item Data (Resource-based)
Everything in the inventory is an Item.

```gdscript
# item_data.gd
extends Resource
class_name ItemData

@export var id: String
@export var name: String
@export var icon: Texture2D
@export var max_stack: int = 64
@export var weight: float = 1.0
@export var consumables: Dictionary # { "hunger": 10, "health": 5 }
```

### 2. Inventory System
A grid-based data structure.

```gdscript
# inventory.gd
extends Node

signal inventory_updated

var slots: Array[ItemSlot] = [] # Array of Resources or Dictionaries
@export var size: int = 20

func add_item(item: ItemData, amount: int) -> int:
    # 1. Check for existing stacks
    # 2. Add to empty slots
    # 3. Return amount remaining (that couldn't fit)
    pass
```

### 3. Interaction System
A universal way to harvest, pickup, or open things.

```gdscript
# interactable.gd
extends Area2D
class_name Interactable

@export var prompt: String = "Interact"

func interact(player: Player) -> void:
    _on_interact(player)

func _on_interact(player: Player) -> void:
    pass # Override this
```
