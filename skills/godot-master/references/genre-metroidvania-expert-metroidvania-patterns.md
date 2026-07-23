# Expert patterns (load on demand)

> **MANDATORY** when implementing beyond Golden Path / Decision Trees. Do not paste into SKILL.md or scenes from memory.

## Architecture Overview

### 1. Game State & Persistence
Metroidvanias require tracking the state of every collectible and boss across the entire world.

```gdscript
# game_state.gd (AutoLoad)
extends Node

var collected_items: Dictionary = {} # "room_id_item_id": true
var unlocked_abilities: Array[String] = []
var map_visited_rooms: Array[String] = []

func register_collectible(id: String) -> void:
    collected_items[id] = true
    save_game()

func has_ability(ability_name: String) -> bool:
    return ability_name in unlocked_abilities
```

### 2. Room Transitions
Seamless transitions are key. Use a `SceneManager` to handle instancing new rooms and positioning the player.

```gdscript
# door.gd
extends Area2D

@export_file("*.tscn") var target_scene_path: String
@export var target_door_id: String

func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("player"):
        SceneManager.change_room(target_scene_path, target_door_id)
```

### 3. Ability System (State Machine Integration)
Abilities should be integrated into the player's State Machine.

```gdscript
# player_state_machine.gd
func _physics_process(delta):
    if Input.is_action_just_pressed("jump") and is_on_floor():
        transition_to("Jump")
    elif Input.is_action_just_pressed("jump") and not is_on_floor() and GameState.has_ability("double_jump"):
        transition_to("DoubleJump")
    elif Input.is_action_just_pressed("dash") and GameState.has_ability("dash"):
        transition_to("Dash")
```

## Key Mechanics Implementation

### Map System
A grid-based or node-based map is essential for navigation.
*   **Grid Map**: Auto-fill cells based on player position.
*   **Room State**: Track "visited" status to reveal map chunks.

```gdscript
# map_system.gd
func update_map(player_pos: Vector2) -> void:
    var grid_pos = local_to_map(player_pos)
    if not grid_map_data.has(grid_pos):
        grid_map_data[grid_pos] = VISITED
        ui_map.reveal_cell(grid_pos)
```

### Ability Gating (The "Lock")
Obstacles that check for specific abilities.

```gdscript
# breakable_wall.gd
extends StaticBody2D

@export var required_ability: String = "super_missile"

func take_damage(amount: int, ability_type: String) -> void:
    if ability_type == required_ability:
        destroy()
    else:
        play_deflect_sound()
```

## Godot-Specific Tips

*   **Camera2D**: Use `limit_left`, `limit_top`, etc., to confine the camera to the current room bounds. Update these limits on room transition.
*   **Resource Preloading**: Preload adjacent rooms for seamless open-world feel if not using hard transitions.
*   **RemoteTransform2D**: Use this to have the camera follow the player but stay detached from the player's rotation/scale.
*   **TileMap Layers**: Use separate layers for background (parallax), gameplay (collisions), and foreground (visual depth).

## Advanced Exploration Systems

Professional implementation of world persistence, sequence-breaking prevention, and seamless navigation.

### 1. Room-Metadata Resource (Persistence)
To persist room states efficiently, create a custom `Resource` that holds exported variables like `is_cleared` or `items_found`. Setting the `resource_local_to_scene` property to true ensures that the resource is uniquely duplicated upon scene instantiation, allowing each room to maintain its own state while being serializable via `ResourceSaver`.

```gdscript
class_name RoomMetadata extends Resource

@export var is_cleared: bool = false
@export var collected_item_ids: Array[StringName] = []
@export var enemy_positions: Array[Vector3] = []

func save_room_state(node: Node) -> void:
    # Logic to populate resource from current room state
    ResourceSaver.save(self, node.scene_file_path + ".tres")
```

### 2. Sequence-Breaking Protection (Ability Checks)
Prevent unintended progression by using a Singleton (Autoload) to track global player progression. Interactable objects and gates should perform safe checks against this central authority to verify prerequisites before allowing passage.

```gdscript
# progression_manager.gd (Autoload)
class_name ProgressionManager extends Node

var unlocked_abilities: Dictionary = {
    "double_jump": false,
    "dash": false,
    "wall_slide": false
}

func check_gate(ability_name: String) -> bool:
    return unlocked_abilities.get(ability_name, false)

func unlock_ability(id: String) -> void:
    if unlocked_abilities.has(id):
        unlocked_abilities[id] = true
```

### 3. Fast-Travel Logic
Implement fast-travel by utilizing `ResourceLoader` to asynchronously load target room scenes. This avoids main-thread hitches and allows for smooth transitions between distant points in the interconnected world.

```gdscript
class_name FastTravelSystem extends Node

func travel_to_node(scene_path: String, spawn_id: StringName) -> void:
    # Load the packed scene resource
    var room_scene := ResourceLoader.load(scene_path) as PackedScene
    if room_scene:
        # Cache the spawn ID for the next scene's _ready() call
        GlobalState.target_spawn_id = spawn_id
        get_tree().change_scene_to_packed(room_scene)
```

**Architectural Tip**: For "Rooms", use the `resource_local_to_scene` flag on your metadata resource to ensure that instanced rooms don't share data accidentally, which is critical for unique item pickups.
