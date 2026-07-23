# Player Abilities

Five categories of stealth tools (per Mark Brown's analysis):

### 1. Movement Alteration

```gdscript
# Crouch, crawl, run (noisy vs quiet)
func calculate_noise_level() -> float:
    if is_crouching:
        return 0.2
    elif is_running:
        return 1.0
    else:
        return 0.5
```

### 2. Information Gathering

```gdscript
# Peek, scout, mark enemies
func activate_detective_vision() -> void:
    for enemy in get_tree().get_nodes_in_group("enemies"):
        enemy.show_outline()
        enemy.show_vision_cone()
```

### 3. AI Manipulation

```gdscript
# Throw distractions
func throw_distraction(target_position: Vector3) -> void:
    var rock := distraction_scene.instantiate()
    rock.global_position = target_position
    add_child(rock)
    SoundPropagation.propagate_sound(target_position, 30.0, "impact")
```

### 4. Space Control

```gdscript
# Shoot out lights, create hiding spots
func shoot_light(light: Light3D) -> void:
    light.visible = false
    # Update light level for area
```

### 5. Enemy Elimination

```gdscript
func perform_takedown(enemy: EnemyAI, lethal: bool) -> void:
    if enemy.alert_state == AlertState.COMBAT:
        return  # Can't stealth kill alert enemy
    
    if lethal:
        enemy.die()
    else:
        enemy.knockout()
    
    # Body becomes interactable
    spawn_body(enemy)
```

---
