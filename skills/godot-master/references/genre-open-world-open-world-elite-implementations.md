# Open World Elite Implementations (load on demand)

> **LLM-ignorance keep rule:** content here is expert Godot/genre knowledge a general agent would not know without reading — never delete, only relocate.

> **MANDATORY** when implementing systems beyond the `scripts/` catalog. Peer skills own full tutorials — route after this reference.

---

## Architecture Overview

### 1. The Streamer (Chunk Manager)
Loading and unloading the world around the player.

```gdscript
# world_streamer.gd
extends Node3D

@export var chunk_size: float = 100.0
@export var render_distance: int = 4
var active_chunks: Dictionary = {}

func _process(delta: float) -> void:
    var player_chunk = Vector2i(player.position.x / chunk_size, player.position.z / chunk_size)
    update_chunks(player_chunk)

func update_chunks(center: Vector2i) -> void:
    # 1. Determine needed chunks
    var needed = []
    for x in range(-render_distance, render_distance + 1):
        for y in range(-render_distance, render_distance + 1):
            needed.append(center + Vector2i(x, y))
    
    # 2. Unload old
    for chunk in active_chunks.keys():
        if chunk not in needed:
            unload_chunk(chunk)
    
    # 3. Load new (Threaded)
    for chunk in needed:
        if chunk not in active_chunks:
            load_chunk_async(chunk)
```

### 2. Floating Origin
Solving the floating point precision error (jitter) when far from (0,0,0).

```gdscript
# floating_origin.gd
extends Node

const THRESHOLD: float = 5000.0

func _process(delta: float) -> void:
    if player.global_position.length() > THRESHOLD:
        shift_world(-player.global_position)

func shift_world(offset: Vector3) -> void:
    # Move the entire world opposite to the player's position
    # So the player creates the illusion of moving, but logic stays near 0,0
    for node in get_tree().get_nodes_in_group("world_root"):
        node.global_position += offset
```

### 3. Quest State Database
Tracking "Did I kill the bandits in Chunk 45?" when Chunk 45 is unloaded.

```gdscript
# global_state.gd
var chunk_data: Dictionary = {} # Vector2i -> Dictionary

func set_entity_dead(chunk_id: Vector2i, entity_id: String) -> void:
    if not chunk_data.has(chunk_id):
        chunk_data[chunk_id] = {}
    chunk_data[chunk_id][entity_id] = { "dead": true }
```

---

## Key Mechanics Implementation

### HLOD (Hierarchical Level of Detail)
Merging 100 houses into 1 simple mesh when viewed from 1km away.
*   **Near**: High Poly House + Props.
*   **Far**: Low Poly Billboard / Imposter mesh.
*   **Very Far**: Part of the Terrain texture.

### Points of Interest (Discovery)
Compass bar logic.

```gdscript
func update_compass() -> void:
    for poi in active_pois:
        var direction = player.global_transform.basis.z
        var to_poi = (poi.global_position - player.global_position).normalized()
        var angle = direction.angle_to(to_poi)
        # Map angle to UI position
```

---

## Godot-Specific Tips

*   **VisibilityRange**: Use specific `visibility_range_begin` and `end` on MeshInstance3D to handle LODs without a dedicated LOD node.
*   **Thread**: Use `Thread.new()` for loading chunks to prevent frame stutters.
*   **OcclusionCulling**: Bake occlusion for large cities. For open fields, simple distance culling is often enough.

---

## 🚀 Elite Technical Implementations (Batch 09)

### 1. World-Origin-Shifting Pattern (Floating Origin)
Prevent physics jitter and rendering glitches at extreme distances (>5,000 units) by shifting the entire world back to the origin. This pattern snaps the world root opposite to the player's movement threshold.

```gdscript
class_name WorldOriginShifter extends Node

@export var shift_threshold: float = 4000.0
var _player_camera: Camera3D

func _process(_delta: float) -> void:
    if not is_instance_valid(_player_camera):
        _player_camera = get_viewport().get_camera_3d()
        return

    if _player_camera.global_position.length() > shift_threshold:
        _perform_origin_shift()

func _perform_origin_shift() -> void:
    var shift_vector: Vector3 = -_player_camera.global_position
    var world_root = get_tree().get_first_node_in_group("world_root") as Node3D
    if world_root:
        world_root.global_position += shift_vector
    # Broadcast signal so AI/Nav can update their internal coordinates
```

### 2. HLOD-System (Hierarchical Level of Detail)
Optimize draw calls by merging distant objects into a single proxy mesh. Use the `Visibility Range` properties on `GeometryInstance3D` to swap high-detail children for a low-poly proxy automatically based on camera distance.

```gdscript
class_name HLODConfigurator extends Node3D

@export var hlod_proxy_mesh: MeshInstance3D
@export var transition_distance: float = 150.0

func _ready() -> void:
    if not hlod_proxy_mesh: return
        
    # The proxy only appears when far away
    hlod_proxy_mesh.visibility_range_begin = transition_distance
    
    for child in get_children():
        if child is MeshInstance3D and child != hlod_proxy_mesh:
            # High-detail children disappear when the proxy appears
            child.visibility_parent = hlod_proxy_mesh.get_path()
```

### 3. Async-Streamer-Controller (Threaded Chunking)
Seamlessly load and unload world chunks using `ResourceLoader.load_threaded_request()`. This prevents the main thread from blocking during heavy I/O, ensuring a stutter-free exploration experience.

```gdscript
class_name AsyncChunkStreamer extends Node

func request_chunk_load(chunk_path: String) -> void:
    var err = ResourceLoader.load_threaded_request(chunk_path)
    if err == OK:
        set_process(true)

func _process(_delta: float) -> void:
    # Check status of pending requests
    var status = ResourceLoader.load_threaded_get_status(path)
    if status == ResourceLoader.THREAD_LOAD_LOADED:
        var chunk_scene = ResourceLoader.load_threaded_get(path) as PackedScene
        var chunk_instance = chunk_scene.instantiate()
        # Add to world...
```


- Master Skill: [godot-master](../SKILL.md)
