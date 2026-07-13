---
name: godot-genre-open-world
description: "Expert blueprint for open world games including chunk-based streaming (load/unload regions dynamically), floating origin (prevent precision jitter beyond 5000 units), HLOD (hierarchical LOD for distant meshes), persistent state (track entity changes across unloaded chunks), POI discovery systems (compass, markers), and threaded loading (prevent stutters). Use for RPGs, sandboxes, or exploration games. Trigger keywords: open_world, chunk_streaming, floating_origin, HLOD, persistent_state, POI_discovery, threaded_loading."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Genre: Open World

Expert blueprint for open worlds balancing scale, performance, and player engagement.

## NEVER Do (Expert Anti-Patterns)

### World & Persistence
- NEVER prioritize Map Size over Density; empty landscapes are poor design. Strictly focus on **Points of Interest (POIs)** within every 30 seconds of travel.
- NEVER save the entire world state; strictly use **Delta Persistence** to record only unique changes (chopped trees, looted chests) to prevent massive save files.
- NEVER load large chunks or scenes synchronously; strictly use **`ResourceLoader.load_threaded_request()`** to prevent "Loading Hitches" and frame freezes.
- NEVER manipulate the active SceneTree directly from a background thread; strictly use **`call_deferred()`** to safely apply background thread chunk instantiations back to the main thread.
- NEVER keep distant, unloaded chunks in memory; strictly `queue_free()` and nullify references to prevent Out-Of-Memory (OOM) crashes.
- NEVER bake massive collision into one mesh; strictly break the world into chunks with local collision regions for efficient physics queries.
- NEVER save high-volume entity states in text formats (.tscn/.json); strictly use **Binary Serialization** (`store_var`) for high-speed I/O.

### Physics & Performance
- NEVER ignore the "Floating Origin" jitter beyond 8,192 units; strictly implement a **World-Shift system** or enable **Large World Coordinates (Double Precision)** in project settings.
- NEVER process physics or AI at extreme distances; strictly use **Spatial Partitioning** to disable logic for entities in far-away, inactive chunks.
- NEVER calculate physics-sensitive state in `_process()`; strictly use `_physics_process()` for deterministic interaction at fluctuating framerates.
- NEVER spawn individual `MeshInstance3D` nodes for massive foliage; strictly use **MultiMeshInstance3D** to batch hundreds of thousands of meshes into a single GPU draw call.
- NEVER move `OccluderInstance3D` nodes at runtime; this forces a CPU BVH rebuild and causes severe micro-stuttering.
- NEVER leave `CSGShape3D` nodes active in exported builds; strictly bake them into static `ArrayMesh` geometry before shipping.
- NEVER compile complex shaders during gameplay; strictly perform "warm-up" during loading or enable project-wide caching.
- NEVER rely solely on automatic mesh decimation; strictly use **VisibilityRange (HLOD)** to substitute complex materials with cheap imposters or completely hide objects at extreme distances.

### Logic & Architecture
- NEVER perform global A* searches across the entire massive world; strictly use `NavigationPathQueryParameters3D` to limit pathfinding to localized active regions.
- NEVER use `find_child()` or deep tree iteration for global state (e.g., Time of Day); strictly use **Scene Groups** (`call_group()`) for optimized broadcasting.
- NEVER synchronize complex Resource types over the network; strictly serialize world changes into primitive Dictionaries or PackedByteArrays.

---

## 🛠 Expert Components (scripts/)

### Original Expert Patterns
- [world_streamer.gd](scripts/world_streamer.gd) - Professional-grade chunk management and streaming engine with background threading.
- [floating_origin_shifter.gd](scripts/floating_origin_shifter.gd) - World-offset correction system to prevent floating-point precision jitter.

### Modular Components
- [async_chunk_loader.gd](scripts/async_chunk_loader.gd) - Background world streaming system using threaded resource loading.
- [multimesh_foliage_manager.gd](scripts/multimesh_foliage_manager.gd) - Server-side GPU batching for thousands of landscape entities.
- [hlod_configurator.gd](scripts/hlod_visibility_config.gd) - Distance-based mesh swapping and imposter management using VisibilityRange.
- [hlod_visibility_config.gd](scripts/hlod_visibility_config.gd) - Distance-based geometry swapping using VisibilityRange (HLOD).
- [binary_save_manager.gd](scripts/binary_save_manager.gd) - High-performance serialization for large-scale world persistence.
- [chunk_limited_pathfinder.gd](scripts/chunk_limited_pathfinder.gd) - NavigationServer-level query limits to optimize AI in dense worlds.
- [server_prop_spawner.gd](scripts/server_prop_spawner.gd) - Extreme optimization using RenderingServer RIDs to bypass SceneTree.
- [dynamic_lod_adjuster.gd](scripts/dynamic_lod_adjuster.gd) - Real-time adaptive performance scaling for global mesh LOD.
- [group_weather_broadcaster.gd](scripts/group_weather_broadcaster.gd) - Efficient decoupled environmental updates using SceneTree grouping.
- [landscape_height_query.gd](scripts/landscape_height_query.gd) - Nodeless physics floor-height queries for large-scale landscapes.

---

## Core Loop
1.  **Traverse**: Player moves across vast distances (foot, vehicle, mount).
2.  **Discover**: Player finds Points of Interest (POIs) dynamically.
3.  **Quest**: Player accepts tasks that require travel.
4.  **Progress**: World state changes based on player actions.
5.  **Immerse**: Dynamic weather, day/night cycles affect gameplay.

## Skill Chain

| Phase | Skills | Purpose |
|-------|--------|---------|
| 1. Tera | `godot-3d-world-building`, `shaders` | Large scale terrain, tri-planar mapping |
| 2. Opti | `level-of-detail`, `multithreading` | HLOD, background loading, occlusion |
| 3. Data | `godot-save-load-systems` | Saving state of thousands of objects |
| 4. Nav | `godot-navigation-pathfinding` | AI pathfinding on large dynamic maps |
| 5. Core | `floating-origin` | Preventing precision jitter at 10,000+ units |

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

## Godot-Specific Tips

*   **VisibilityRange**: Use specific `visibility_range_begin` and `end` on MeshInstance3D to handle LODs without a dedicated LOD node.
*   **Thread**: Use `Thread.new()` for loading chunks to prevent frame stutters.
*   **OcclusionCulling**: Bake occlusion for large cities. For open fields, simple distance culling is often enough.

## Common Pitfalls

1.  **The "Empty" World**: huge map, nothing to do. **Fix**: Density > Size. Smaller, denser maps are better than vast empty deserts.
2.  **Save File Bloat**: Save file is 500MB. **Fix**: Only save *changes* (Delta compression). If a rock hasn't moved, don't save it.
3.  **Physics at Distance**: Physics break far away. **Fix**: Disable physics processing for chunks > 2 units away. Use simple "simulation" for distant logic.


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


- Master Skill: [godot-master](../godot-master/SKILL.md)
