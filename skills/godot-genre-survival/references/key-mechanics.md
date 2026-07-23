# Key Mechanics Implementation

### Needs System
Simple float values that deplete over time.

```gdscript
# needs_manager.gd
var hunger: float = 100.0
var thirst: float = 100.0
var decay_rate: float = 1.0

func _process(delta: float) -> void:
    hunger -= decay_rate * delta
    thirst -= decay_rate * 1.5 * delta
    
    if hunger <= 0:
        take_damage(delta)
```

### Crafting Logic
Check if player has ingredients -> Remove ingredients -> Add result.

```gdscript
func craft(recipe: Recipe) -> bool:
    if not has_ingredients(recipe.ingredients):
        return false
        
    remove_ingredients(recipe.ingredients)
    inventory.add_item(recipe.result_item, recipe.result_amount)
    return true

### 4. Tiered Tool Scaling
Scaling resource yield with tool quality (`item_data.gd` metadata):
- **Stone Axe**: 1 yield per hit, 3s harvest time.
- **Steel Axe**: 5 yield per hit, 1.5s harvest time.
- **Auto-Saw**: Constant yield stream while within proximity.

### 5. Spawn Safe Zones
Preventing "Spawn Camping" via check:
```gdscript
func get_spawn_point() -> Vector3:
    var point = find_random_point()
    for bed in get_tree().get_nodes_in_group("player_beds"):
        if point.distance_to(bed.global_position) < safe_radius:
            return get_spawn_point() # Re-roll
    return point
```
```
