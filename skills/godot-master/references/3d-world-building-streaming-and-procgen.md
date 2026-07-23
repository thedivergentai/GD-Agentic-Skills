# Streaming And Procgen

## Level Streaming / LOD

### GridMap Chunking

```gdscript
# level_streamer.gd - Load/unload GridMap chunks based on player position
extends Node3D

@export var chunk_size := 32  # Grid cells per chunk
@export var load_radius := 2  # Chunks to keep loaded

var loaded_chunks := {}  # Vector2i → GridMap

func _process(delta: float) -> void:
    var player_pos := get_player_position()
    var player_chunk := Vector2i(
        int(player_pos.x / (chunk_size * cell_size.x)),
        int(player_pos.z / (chunk_size * cell_size.z))
    )
    
    # Load nearby chunks
    for x in range(-load_radius, load_radius + 1):
        for z in range(-load_radius, load_radius + 1):
            var chunk_coord := player_chunk + Vector2i(x, z)
            if chunk_coord not in loaded_chunks:
                load_chunk(chunk_coord)
    
    # Unload distant chunks
    for chunk_coord in loaded_chunks.keys():
        var dist := chunk_coord.distance_to(player_chunk)
        if dist > load_radius:
            unload_chunk(chunk_coord)

func load_chunk(coord: Vector2i) -> void:
    var gridmap := GridMap.new()
    gridmap.mesh_library = preload("res://library.tres")
    add_child(gridmap)
    loaded_chunks[coord] = gridmap
    
    # TODO: Load chunk data from file/database
    # gridmap.set_cell_item(...)

func unload_chunk(coord: Vector2i) -> void:
    var gridmap: GridMap = loaded_chunks[coord]
    gridmap.queue_free()
    loaded_chunks.erase(coord)
```

---

## Procedural Generation

### Random Dungeon with GridMap

```gdscript
# dungeon_generator.gd
extends GridMap

enum Tile { FLOOR, WALL, DOOR }

func generate_room(pos: Vector3i, size: Vector3i) -> void:
    # Fill with floor
    for x in range(size.x):
        for z in range(size.z):
            set_cell_item(pos + Vector3i(x, 0, z), Tile.FLOOR)
    
    # Add walls
    for x in range(size.x):
        set_cell_item(pos + Vector3i(x, 0, 0), Tile.WALL)  # North
        set_cell_item(pos + Vector3i(x, 0, size.z - 1), Tile.WALL)  # South
    
    for z in range(size.z):
        set_cell_item(pos + Vector3i(0, 0, z), Tile.WALL)  # West
        set_cell_item(pos + Vector3i(size.x - 1, 0, z), Tile.WALL)  # East

func _ready() -> void:
    generate_room(Vector3i(0, 0, 0), Vector3i(10, 1, 10))
```

---

## Expert Pattern: World-Streaming-Queue (Stutter-Free Loading)

To prevent frame-spikes when moving between level chunks, use `ResourceLoader` background threads.

```gdscript
class_name WorldStreamer extends Node

var load_queue: Array[String] = []

func request_chunk(path: String) -> void:
    # Begin background thread request
    var err = ResourceLoader.load_threaded_request(path)
    if err == OK:
        load_queue.append(path)

func _process(_delta: float) -> void:
    for i in range(load_queue.size() - 1, -1, -1):
        var path = load_queue[i]
        var status = ResourceLoader.load_threaded_get_status(path)
        
        if status == ResourceLoader.THREAD_LOAD_LOADED:
            # Resource ready! Instantiate and add to scene
            var chunk: PackedScene = ResourceLoader.load_threaded_get(path)
            add_child(chunk.instantiate())
            load_queue.remove_at(i)
```
