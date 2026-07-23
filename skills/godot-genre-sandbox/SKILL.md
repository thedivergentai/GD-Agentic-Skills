---
name: godot-genre-sandbox
description: "Expert blueprint for sandbox games (Minecraft, Terraria, Garry's Mod) with physics-based interactions, cellular automata, emergent gameplay, and creative tools. Use when building open-world creation games with voxels, element systems, player-created structures, or procedural worlds. Keywords voxel, sandbox, cellular automata, MultiMesh, chunk management, emergent behavior, creative mode."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Genre: Sandbox

Physical simulation, emergent play, and player creativity define this genre.

## NEVER Do (Expert Anti-Patterns)

### Performance & Scalability
- NEVER use individual `RigidBody` nodes for every block; strictly use **Static Colliders** for the world and reserve physics for dynamic props.
- NEVER simulate the entire world every frame; strictly process **"Dirty" chunks** with active changes. Sleeping chunks must consume zero CPU.
- NEVER update `MultiMesh` buffers every frame; strictly **batch changes** and only rebuild the buffer when a modification completes (e.g., player stops painting).
- NEVER use standard Godot `Nodes` for every grid cell; strictly use **PackedInt32Arrays** or typed Dictionaries to keep RAM overhead minimal.
- NEVER raycast against every individual voxel for placement; strictly use **Grid Quantization** (`floor(pos/size)`) for direct O(1) cell calculation.
- NEVER render every block face in a chunk; strictly generate an `ArrayMesh` that only pushes **visible exterior faces** to the GPU (Culling/Greedy Meshing).

### Data & Persistence
- NEVER save raw arrays of every block transform; strictly use **Run-Length Encoding (RLE)** (e.g., "Air x 50,000") to compress uniform spaces.
- NEVER load massive terrain chunks synchronously; strictly use `ResourceLoader.load_threaded_request()` to prevent frame stutter.
- NEVER use standard text `.tscn` files for voxel datasets; strictly use **binary `.res` files** for 10x faster parsing.
- NEVER ignore **Floating-Point Precision limits** (32,768 units); strictly implement floating-origin shifting for massive worlds.

### Systems & Architecture
- NEVER hardcode element interactions (`if water and fire`); strictly use a **Property System** where interactions emerge from material attributes (flammability, density).
- NEVER trust client-side placement in multiplayer; strictly require the **Server to validate** bounds and resources.
- NEVER manipulate the SceneTree from background generation threads; strictly use `call_deferred()` or Mutex locks for safety.
- NEVER leave orphaned chunks in memory; strictly track loaded regions and call `queue_free()` on discarded branches.

---

## 🛠 Expert Components (scripts/)

> **MANDATORY / Do NOT Load by path**
> - **2D falling-sand / CA only**: load `cellular_automata_liquid.gd` + property/tool patterns below. **Do NOT Load** `voxel_chunk_*.gd`, `voxel_world.gd`, or greedy-mesh paths.
> - **3D voxel / chunk worlds**: load `voxel_world.gd` → `voxel_chunk_manager.gd` → **MANDATORY** `voxel_chunk_mesher.gd` for exterior-face meshes. **Do NOT Load** 2D CA liquid unless you also run a 2D element layer.
> - **Placement / multiplayer validation**: load `dynamic_placement_validator.gd` before trusting client dig/place.
> - **Persistence**: load `sandbox_world_serializer.gd` for RLE/binary chunk IO; keep `sandbox_patterns.gd` for async load + floating origin.

### Chunk / voxel (3D)
- [voxel_world.gd](scripts/voxel_world.gd) — Top-level world controller for grid state, tool-based editing, and chunk lifecycle.
- [voxel_chunk_manager.gd](scripts/voxel_chunk_manager.gd) — Chunk lifecycle + `MultiMeshInstance3D` batch updates for medium worlds.
- [voxel_chunk_mesher.gd](scripts/voxel_chunk_mesher.gd) — **MANDATORY** for large worlds: WorkerThreadPool visible-face `ArrayMesh` build + deferred `set_mesh`.

### Elements / tools (2D CA)
- [cellular_automata_liquid.gd](scripts/cellular_automata_liquid.gd) — Liquids/powders via property-based density checks.

### Placement / save / utilities
- [dynamic_placement_validator.gd](scripts/dynamic_placement_validator.gd) — Bounds/resource/server-side placement checks (do not trust client).
- [sandbox_world_serializer.gd](scripts/sandbox_world_serializer.gd) — RLE/binary chunk persistence patterns.
- [sandbox_patterns.gd](scripts/sandbox_patterns.gd) — Async chunk loading, multithreading helpers, floating-origin shift.

## Architecture Patterns

### 1. Element System (Property-Based Emergence)
Model material properties, not behaviors. Interactions emerge from overlapping properties.

```gdscript
# element_data.gd
class_name ElementData extends Resource

enum Type { SOLID, LIQUID, GAS, POWDER }
@export var id: String = "air"
@export var type: Type = Type.GAS
@export var density: float = 0.0      # For liquid flow direction
@export var flammable: float = 0.0    # 0-1: Chance to ignite
@export var ignition_temp: float = 400.0
@export var conductivity: float = 0.0  # For electricity/heat
@export var hardness: float = 1.0     # Mining time multiplier

# EDGE CASE: What if two elements have same density but different types?
# SOLUTION: Use secondary sort (type enum priority: SOLID > LIQUID > POWDER > GAS)
func should_swap_with(other: ElementData) -> bool:
    if density == other.density:
        return type > other.type  # Enum comparison: SOLID(0) > GAS(3)
    return density > other.density
```

### 2. Cellular Automata Grid (Falling Sand Simulation)
Update order matters. Top-down prevents "teleporting" godot-particles.

```gdscript
# world_grid.gd
var grid: Dictionary = {}  # Vector2i -> ElementData
var dirty_cells: Array[Vector2i] = []

func _physics_process(_delta: float) -> void:
    # CRITICAL: Sort top-to-bottom to prevent double-moves
    dirty_cells.sort_custom(func(a, b): return a.y < b.y)
    
    for pos in dirty_cells:
        simulate_cell(pos)
    dirty_cells.clear()

func simulate_cell(pos: Vector2i) -> void:
    var cell = grid.get(pos)
    if not cell: return
    
    match cell.type:
        ElementData.Type.LIQUID, ElementData.Type.POWDER:
            # Try down, then down-left, then down-right
            var targets = [pos + Vector2i.DOWN, 
                           pos + Vector2i(- 1, 1), 
                           pos + Vector2i(1, 1)]
            for target in targets:
                var neighbor = grid.get(target)
                if neighbor and cell.should_swap_with(neighbor):
                    swap_cells(pos, target)
                    mark_dirty(target)
                    return
        
        ElementData.Type.GAS:
            # Gases rise (inverse of liquids)
            var targets = [pos + Vector2i.UP,
                           pos + Vector2i(-1, -1),
                           pos + Vector2i(1, -1)]
            # Same swap logic...

# EDGE CASE: What if multiple godot-particles want to move into same cell?
# SOLUTION: Only mark target dirty, don't double-swap. Next frame resolves conflicts.
```

### 3. Tool System (Strategy Pattern)
Decouple input from world modification.

```gdscript
# tool_base.gd
class_name Tool extends Resource
func use(world_pos: Vector2, world: WorldGrid) -> void: pass

# tool_brush.gd
extends Tool
@export var element: ElementData
@export var radius: int = 1

func use(world_pos: Vector2, world: WorldGrid) -> void:
    var grid_pos = Vector2i(floor(world_pos.x), floor(world_pos.y))
    
    # Circle brush pattern
    for x in range(-radius, radius + 1):
        for y in range(-radius, radius + 1):
            if x*x + y*y <= radius*radius:  # Circle boundary
                var target = grid_pos + Vector2i(x, y)
                world.set_cell(target, element)

# FALLBACK: If element placement fails (e.g., occupied by indestructible block)?
# Check world.can_place(target) before set_cell(), show visual feedback.
```

### 4. Chunk-Based Rendering (3D Voxels) — MultiMesh vs ArrayMesh

**MANDATORY**: For exterior-face / greedy-style chunk meshes, read and adapt [voxel_chunk_mesher.gd](scripts/voxel_chunk_mesher.gd) (WorkerThreadPool + `SurfaceTool` + `call_deferred("set_mesh")`). Do **not** inline incomplete mesher stubs in project code.

| World scale | Render path | Load |
|-------------|-------------|------|
| Small (<100k blocks) | Single `MeshInstance3D` + `SurfaceTool` | Mesher patterns only |
| Medium (100k–1M) | Chunked **`MultiMeshInstance3D`** (one mesh, many instances; batch buffer on edit complete) | **MANDATORY** [voxel_chunk_manager.gd](scripts/voxel_chunk_manager.gd) |
| Large (>1M) / editable terrain | Chunked **`ArrayMesh`** with **visible-face / greedy** quads + LOD; optional `RenderingServer` instance RIDs | **MANDATORY** [voxel_chunk_mesher.gd](scripts/voxel_chunk_mesher.gd) + manager |

**Rule**: Prefer MultiMesh when every instance shares one mesh and you only need per-instance transforms/colors. Prefer ArrayMesh meshing when adjacent voxels must merge into unique surfaces (greedy faces, UV atlases, per-chunk collision).

## Save System for Sandbox Worlds

```gdscript
# chunk_save_data.gd
class_name ChunkSaveData extends Resource

@export var chunk_coord: Vector2i
@export var rle_data: PackedInt32Array  # [type_id, count, type_id, count...]

# EXPERT TECHNIQUE: Run-Length Encoding
static func encode_chunk(grid: Dictionary, chunk_pos: Vector2i, chunk_size: int) -> ChunkSaveData:
    var data = ChunkSaveData.new()
    data.chunk_coord = chunk_pos
    
    var run_type: int = -1
    var run_count: int = 0
    
    for y in range(chunk_size):
        for x in range(chunk_size):
            var world_pos = chunk_pos * chunk_size + Vector2i(x, y)
            var cell = grid.get(world_pos)
            var type_id = cell.id if cell else 0  # 0 = air
            
            if type_id == run_type:
                run_count += 1
            else:
                if run_count > 0:
                    data.rle_data.append(run_type)
                    data.rle_data.append(run_count)
                run_type = type_id
                run_count = 1
    
    # Flush final run
    if run_count > 0:
        data.rle_data.append(run_type)
        data.rle_data.append(run_count)
    
    return data

# COMPRESSION RESULT: Empty chunk (16×16 = 256 blocks of air)
# Without RLE: 256 integers = 1024 bytes
# With RLE: [0, 256] = 8 bytes (128x compression!)
```

## Physics Joints for Player Creations

```gdscript
# joint_tool.gd
func create_hinge(body_a: RigidBody2D, body_b: RigidBody2D, anchor: Vector2) -> void:
    var joint = PinJoint2D.new()
    joint.global_position = anchor
    joint.node_a = body_a.get_path()
    joint.node_b = body_b.get_path()
    joint.softness = 0.5  # Allows slight flex
    add_child(joint)
    
    # EDGE CASE: What if bodies are deleted while joint exists?
    # Joint will auto-break in Godot 4.x, but orphaned Node leaks memory.
# SOLUTION:
    body_a.tree_exiting.connect(func(): joint.queue_free())
    body_b.tree_exiting.connect(func(): joint.queue_free())

# FALLBACK: Player attaches joint to static geometry?
# Check `body.freeze == false` before creating joint.
```

## Godot-Specific Expert Notes

- **`MultiMeshInstance3D.multimesh.instance_count`**: MUST be set before buffer allocation. Cannot dynamically grow — requires recreation.
- **`RigidBody2D.sleeping`**: Bodies auto-sleep after 2 seconds of no movement. Use `apply_central_impulse(Vector2.ZERO)` to force wake without adding force.
- **`GridMap` vs `MultiMesh`**: GridMap uses MeshLibrary (great for variety), MultiMesh uses single mesh (great for speed). Combine: GridMap for structures, MultiMesh for terrain.
- **Continuous CD**: `continuous_cd` requires convex collision shapes. Use `CapsuleShape2D` for projectiles, NOT `RectangleShape2D`.


---

## 🚀 Elite Technical Implementations (Batch 09)

### 1. Greedy / Visible-Face Meshing
Do not paste placeholder meshers. **MANDATORY** read [voxel_chunk_mesher.gd](scripts/voxel_chunk_mesher.gd) for threaded visible-face generation. Extend that pattern for full greedy quad merging; for MultiMesh vs ArrayMesh choice see §4 above. Extreme draw paths may push committed arrays via `RenderingServer` (see Official Documentation → Using servers) after the mesher owns the surface data.

### 2. VoxelGI (demoted — use docs + lighting skill)
Sandbox chunk lighting is **not** owned by an incomplete `RenderingServer.voxel_gi_allocate_data` stub here. For dynamic GI on procedural volumes, follow [Using VoxelGI](https://docs.godotengine.org/en/stable/tutorials/3d/global_illumination/using_voxel_gi.html) and route implementation detail to [godot-3d-lighting](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-lighting/SKILL.md). Prefer baked/probe strategies from that skill unless you truly need runtime VoxelGI.

### 3. Blueprint-Sharing (Base64/JSON Serialization)
Allow players to share creations via simple strings. Use `JSON` for readable serialization and `DisplayServer` for clipboard integration.

```gdscript
class_name BlueprintManager extends Node

## Exports chunk data to the OS clipboard.
static func export_blueprint_to_clipboard(blueprint_data: Dictionary) -> void:
    var json_string: String = JSON.stringify(blueprint_data)
    DisplayServer.clipboard_set(json_string)

## Imports blueprint from clipboard.
static func import_blueprint_from_clipboard() -> Dictionary:
    var json_string: String = DisplayServer.clipboard_get()
    var parsed_data = JSON.parse_string(json_string)
    return parsed_data if parsed_data is Dictionary else {}
```


## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Using MultiMesh](https://docs.godotengine.org/en/stable/tutorials/performance/using_multimesh.html) — batch voxel/prop instances per chunk and avoid per-frame buffer rebuilds.
- [Using GridMaps](https://docs.godotengine.org/en/stable/tutorials/3d/using_gridmaps.html) — MeshLibrary cell placement when structures need variety beyond a single MultiMesh mesh.
- [ArrayMesh](https://docs.godotengine.org/en/stable/tutorials/3d/procedural_geometry/arraymesh.html) — push greedy-meshed exterior faces as one surface instead of per-block meshes.
- [SurfaceTool](https://docs.godotengine.org/en/stable/tutorials/3d/procedural_geometry/surfacetool.html) — build and index chunk meshes with normals before committing to MeshInstance3D.
- [Background loading](https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html) — ResourceLoader threaded chunk streaming so exploration does not hitch.
- [Saving games](https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html) — persist player-built worlds (groups, JSON/`var_to_str`, binary Resources).
- [Using multiple threads](https://docs.godotengine.org/en/stable/tutorials/performance/using_multiple_threads.html) — WorkerThreadPool meshing/generation with SceneTree mutations deferred.
- [Using servers](https://docs.godotengine.org/en/stable/tutorials/performance/using_servers.html) — RenderingServer mesh/instance RIDs when bypassing the SceneTree for chunk draw.
- [Using VoxelGI](https://docs.godotengine.org/en/stable/tutorials/3d/global_illumination/using_voxel_gi.html) — dynamic GI allocation for large procedural sandbox volumes.
- [Large world coordinates](https://docs.godotengine.org/en/stable/tutorials/physics/large_world_coordinates.html) — precision limits and floating-origin strategies past ~32k units.
- [Ray-casting](https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html) — aim/place/break queries via direct space state instead of per-voxel raycasts.
- [PinJoint2D](https://docs.godotengine.org/en/stable/classes/class_pinjoint2d.html) — hinge-style joints for player-created physics contraptions.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — scene tree, Resources, and import basics before chunk scenes and binary `.res` world data.
- [godot-physics-3d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md) — StaticBody colliders for terrain, RigidBody props, and shape queries used in placement validation.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — typed Dictionaries/Packed arrays, WorkerThreadPool tasks, and deferred SceneTree edits in meshers.

#### Complements
- [godot-3d-world-building](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md) — GridMap/MeshLibrary and bake flows that sandbox building tools often reuse.
- [godot-3d-lighting](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-lighting/SKILL.md) — VoxelGI / probes / bake strategy for procedural volumes (do not invent RenderingServer GI stubs in this skill).
- [godot-procedural-generation](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-procedural-generation/SKILL.md) — noise/dungeon generators that seed voxel chunks before player edits.
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — MultiMesh budgets, dirty-chunk simulation, and draw-call caps at sandbox scale.
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — RLE/binary chunk persistence and migrateable save schemas beyond ad-hoc JSON.
- [godot-raycasting-queries](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md) — PhysicsDirectSpaceState picking and shape intersects for block tools.
- [godot-2d-physics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md) — PinJoint2D/RigidBody2D patterns for 2D sandbox contraptions and falling-sand props.
- [godot-scene-management](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md) — threaded load queues and chunk node lifecycle without orphaned branches.
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — tune crafting costs, element rarity, and economy loops that emerge from sandbox systems.

#### Downstream / consumers
- [godot-genre-open-world](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-open-world/SKILL.md) — streaming, floating origin, and HLOD layered on editable sandbox chunks.
- [godot-genre-survival](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-survival/SKILL.md) — harvesting, needs, and crafting loops that consume destructible voxel/element worlds.
- [godot-multiplayer-networking](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md) — authoritative server placement validation for shared creative worlds.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — library router and mirrored module entry for cross-skill discovery.
