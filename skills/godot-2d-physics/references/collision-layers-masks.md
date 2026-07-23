# Collision layers and masks

## Mental model

```gdscript
# collision_layer: What broadcast channels am I transmitting on?
# collision_mask:   What broadcast channels am I listening to?

# Player: layer=0b0001, mask=0b0110 (hears enemies + world)
# Enemy:  layer=0b0010, mask=0b0101 (hears player + world)
```

**Layer** = who I am. **Mask** = who I detect. Setting both to the same value is usually wrong.

## Helpers (prefer over magic bitmasks)

```gdscript
func setup_player_collision() -> void:
    set_collision_layer_value(1, true)   # I am layer 1
    set_collision_mask_value(2, true)    # Detect enemies
    set_collision_mask_value(3, true)    # Detect world

func enable_layers(base_layer: int, count: int) -> void:
    var mask := 0
    for i in range(count):
        mask |= (1 << (base_layer + i - 1))
    collision_mask = mask
```

Scripts: [collision_bitmask_helper.gd](../scripts/collision_bitmask_helper.gd), [collision_layer_matrix_manager.gd](../scripts/collision_layer_matrix_manager.gd).

## Common patterns

```gdscript
# Projectile hits enemies, ignores other projectiles
extends Area2D
func _ready() -> void:
    set_collision_layer_value(4, true)  # Projectiles
    set_collision_mask_value(2, true)   # Enemies only
```

Name layers in Project Settings before hardcoding layer indices in team docs.

## Edge cases

| Issue | Fix |
|-------|-----|
| Raycast false in `_ready()` | `await get_tree().physics_frame` first |
| `CharacterBody2D` not seen by Area2D | Default `collision_layer = 0` — set layer explicitly |
| One-way platforms | Godot 4.7: `body_set_shape_as_one_way_collision` with shape-relative direction |
