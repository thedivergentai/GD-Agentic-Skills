# Roguelike Meta-Systems Deep-Dive (load on demand)

> **LLM-ignorance keep rule:** content here is expert Godot/genre knowledge a general agent would not know without reading — never delete, only relocate.

> **MANDATORY** when implementing systems beyond the `scripts/` catalog. Peer skills own full tutorials — route after this reference.

---

## Architecture Overview

Roguelikes require a strict separation between **Run State** (temporary) and **Meta State** (persistent).

### 1. Run Manager (AutoLoad)
Handles the lifespan of a single run. Resets completely on death.

```gdscript
# run_manager.gd
extends Node

signal run_started
signal run_ended(victory: bool)
signal floor_changed(new_floor: int)

var current_seed: int
var current_floor: int = 1
var player_stats: Dictionary = {}
var inventory: Array[Resource] = []
var rng: RandomNumberGenerator

func start_run(seed_val: int = -1) -> void:
    rng = RandomNumberGenerator.new()
    if seed_val == -1:
        rng.randomize()
        current_seed = rng.seed
    else:
        current_seed = seed_val
        rng.seed = current_seed
        
    current_floor = 1
    _reset_run_state()
    run_started.emit()

func _reset_run_state() -> void:
    player_stats = { "hp": 100, "gold": 0 }
    inventory.clear()

func next_floor() -> void:
    current_floor += 1
    floor_changed.emit(current_floor)
    
func end_run(victory: bool) -> void:
    run_ended.emit(victory)
    # Trigger meta-progression save here
```

### 2. Meta-Progression (Resource)
Stores permanent unlocks.

```gdscript
# meta_progression.gd
class_name MetaProgression
extends Resource

@export var total_runs: int = 0
@export var unlocked_weapons: Array[String] = ["sword_basic"]
@export var currency: int = 0
@export var skill_tree_nodes: Dictionary = {} # node_id: level

func save() -> void:
    ResourceSaver.save(self, "user://meta_progression.tres")

static func load_or_create() -> MetaProgression:
    if ResourceLoader.exists("user://meta_progression.tres"):
        return ResourceLoader.load("user://meta_progression.tres")
    return MetaProgression.new()
```

---

## Key Mechanics implementation

### Procedural Dungeon Generation
- **Drunkard's Walk (Walker)**: Ideal for organic, cave-like or connected room layouts.
- **Binary Space Partitioning (BSP)**: Best for rectangular, connected room-and-hallway dungeons.
- **Wave Function Collapse (WFC)**: For highly detailed, rule-based tile environments and modular room assembly.

```gdscript
# dungeon_generator.gd
extends Node

@export var map_width: int = 50
@export var map_height: int = 50
@export var max_walkers: int = 5
@export var max_steps: int = 500

func generate_dungeon(tilemap: TileMapLayer, rng: RandomNumberGenerator) -> void:
    tilemap.clear()
    var walkers: Array[Vector2i] = [Vector2i(map_width/2, map_height/2)]
    var floor_tiles: Array[Vector2i] = []
    
    for step in max_steps:
        var new_walkers: Array[Vector2i] = []
        for walker in walkers:
            floor_tiles.append(walker)
            # 25% chance to destroy walker, 25% to spawn new one
            if rng.randf() < 0.25 and walkers.size() > 1:
                continue # Destroy
            if rng.randf() < 0.25 and walkers.size() < max_walkers:
                new_walkers.append(walker) # Spawn
            
            # Move walker
            var direction = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT].pick_random()
            new_walkers.append(walker + direction)
        
        walkers = new_walkers
    
    # Set tiles
    for pos in floor_tiles:
        tilemap.set_cell(pos, 0, Vector2i(0,0)) # Assuming source_id 0 is floor
    
    # Post-process: Add walls, spawn points, etc.
```

### Item/Relic System (Resource-based)
Relics modify stats or add behavior.

```gdscript
# relic.gd
class_name Relic
extends Resource

@export var id: String
@export var name: String
@export var icon: Texture2D
@export_multiline var description: String

# Hook system for complex interactions
func on_pickup(player: Node) -> void:
    pass

func on_damage_dealt(player: Node, target: Node, damage: int) -> int:
    return damage # Return modified damage

func on_kill(player: Node, target: Node) -> void:
    pass
```

```gdscript
# example_relic_vampirism.gd
extends Relic

func on_kill(player: Node, target: Node) -> void:
    player.heal(5)
    print("Vampirism triggered!")
```

### 4. Director-AI (Pacing Manager)
Use frame-slicing to evaluate student performance and adjust difficulty without CPU spikes.

```gdscript
# director_ai.gd (Autoload)
func _process(_delta):
    # Only evaluate every 60 frames
    if Engine.get_process_frames() % 60 == 0:
        _update_pacing_logic()

func _update_pacing_logic():
    if player_health < 30:
        spawn_rate -= 0.5 # Ease up
    elif player_kills > 100:
        spawn_rate += 1.0 # Challenge more
```

### 5. Procedural Room Assembler (Markers)
Snap rooms together using connection markers for pixel-perfect stitching.

```gdscript
# room_assembler.gd
func add_room(new_scene: PackedScene, prev_exit: Marker2D):
    var inst = new_scene.instantiate()
    add_child(inst)
    await inst.tree_entered # Wait for node to be ready
    
    var entrance = inst.get_node("Entrance")
    # Snap room so entrance matches previous exit
    var offset = inst.global_position - entrance.global_position
    inst.global_position = prev_exit.global_position + offset
```

### 6. Synergy-Tag System (Relics)
Use tag aggregation on ItemData resources to trigger synergistic effects.

```gdscript
# synergy_manager.gd
func check_synergies(inventory: Array[ItemData]):
    var tags = {}
    for item in inventory:
        for tag in item.synergy_tags:
            tags[tag] = tags.get(tag, 0) + 1
            
    if tags.get(&"Fire", 0) >= 1 and tags.get(&"Projectile", 0) >= 1:
        activate_synergy(&"Flaming_Arrow")
```
```

---

## Godot-Specific Tips

-   **Seeded Runs**: Always initialize `RandomNumberGenerator` with a seed. This allows players to share specific run layouts.
-   **ResourceSaver**: Use `ResourceSaver` for meta-progression, but be careful with cyclical references in deeply nested resources.
-   **Scenes as Rooms**: Build your "rooms" as separate scenes (`Room1.tscn`, `Room2.tscn`) and instance them into the generated layout for handcrafted quality within procedural layouts.
-   **Navigation**: Rebake `NavigationRegion2D` at runtime after generating the dungeon layout if using 2D navigation.

---

## Advanced Techniques

-   **Synergy System**: Tag items (`fire`, `projectile`, `companion`) and check for tag combinations to create emergent power-ups.
-   **Director AI**: An invisible "Director" system that tracks player health/stress and adjusts spawn rates dynamically (like *Left 4 Dead*).
