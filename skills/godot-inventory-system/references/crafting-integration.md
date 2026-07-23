# Crafting Integration

```gdscript
# crafting_recipe.gd
class_name CraftingRecipe
extends Resource

@export var result: Item
@export var result_amount: int = 1
@export var requirements: Array[CraftingRequirement]

func can_craft(inventory: Inventory) -> bool:
    for req in requirements:
        if not inventory.has_item(req.item, req.amount):
            return false
    return true

func craft(inventory: Inventory) -> bool:
    if not can_craft(inventory):
        return false
    
    # Remove ingredients
    for req in requirements:
        inventory.remove_item(req.item, req.amount)
    
    # Add result
    inventory.add_item(result, result_amount)
    return true
```
