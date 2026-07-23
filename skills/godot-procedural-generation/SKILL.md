---
name: godot-procedural-generation
description: "Expert blueprint for procedural content generation (dungeons, terrain, loot, levels) using FastNoiseLite, random walks, BSP trees, Wave Function Collapse, and seeded randomization. Use when creating roguelikes, sandbox games, or dynamic content. Keywords procedural, generation, FastNoiseLite, Perlin noise, BSP, drunkard walk, Wave Function Collapse, seeding."
---

# Procedural Generation

Seeded algorithms, noise functions, and constraint propagation define replayable content generation. **Do not paste inline algorithm tutorials** — load the MANDATORY scripts below.

## NEVER Do in Procedural Generation

- **NEVER generate chunks on the Main Thread** — Proc-gen is CPU intensive and causes frame-rate spikes. Use `WorkerThreadPool` or a background `Thread` to keep the UI responsive.
- **NEVER query `FastNoiseLite` every frame** — Sampling noise per frame (especially in `_process`) is a massive waste. Generate your map into an `Image` or `Array` once and sample from memory [NoiseSampling].
- **NEVER use `randi()` for reproducible seeds** — Always store and reuse a specific `seed` within your random number generator (`RandomNumberGenerator.new()`) to ensure consistent world generation.
- **NEVER use pure randomness for object placement** — Pure random (white noise) causes clumping and overlapping. Use **Poisson Disk Sampling** or **Jittered Grids** for natural-looking distributions.
- **NEVER forget to bound your loops** — Procedural loops (like WFC or Cellular Automata) can easily enter infinite states if constraints are impossible. Always include a `max_iterations` safety break.
- **NEVER instantiate nodes directly from proc-gen threads** — You cannot touch the SceneTree from a worker thread. Generate the *data* in the thread, then notify the Main Thread to handle `add_child()`.
- **NEVER use complex WFC for simple layouts** — Wave Function Collapse is powerful but overkill for simple paths. Use **Drunkard's Walk** or **BSP** for lightweight structured layouts.
- **NEVER rely on `TileMap.set_cell()` for large-scale updates** — Updating 10,000 cells individually is slow. Prepare a `TileMapPattern` and use `set_pattern()` or `set_cells_terrain_connect()` for batch updates.
- **NEVER forget to bake Navigation at the end** — Procedurally generated worlds need their navmeshes rebaked at runtime or the AI will walk into walls.
- **NEVER ignore data serialization** — If you generate a world, you must be able to save the *seed* and any *player modifications*. Don't try to save the entire raw chunk state if avoidable.

---

## Golden Path (MANDATORY)

Every generator starts here — seed isolation, async data, main-thread commit:

1. **Seed & RNG** — **MANDATORY** [proc_gen_seed_history.gd](scripts/proc_gen_seed_history.gd): one `RandomNumberGenerator` per level/chunk; persist `seed` + `state` for shareable runs.
2. **Async chunks** — **MANDATORY** [multi_threaded_chunk_gen.gd](scripts/multi_threaded_chunk_gen.gd): `WorkerThreadPool.add_task` → compute data off-thread → `call_deferred("_finalize_chunk")` for SceneTree/node work.
3. **Validate → bake nav** — after tiles/meshes land on the main thread, rebake `NavigationRegion` (see [godot-navigation-pathfinding](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md)).

```gdscript
var rng := RandomNumberGenerator.new()

func begin_generation(run_seed: int) -> void:
    rng.seed = run_seed
    WorkerThreadPool.add_task(_build_data.bind(run_seed))

func _build_data(seed: int) -> Dictionary:
    var local_rng := RandomNumberGenerator.new()
    local_rng.seed = seed
    var noise := FastNoiseLite.new()
    noise.seed = seed
    return {"heights": noise.get_image(64, 64)}

func _ready() -> void:
    # Worker returns here — safe for nodes
    pass

func _finalize_from_worker(data: Dictionary) -> void:
    # add_child / set_pattern / create_trimesh_collision — main thread only
    pass
```

> **Do NOT Load** the full `scripts/` folder. Open only the script that matches your algorithm row below.

## Algorithm Decision Tree

| Layout / content need | Algorithm | Script (MANDATORY when chosen) |
|-----------------------|-----------|--------------------------------|
| Winding tunnels, rivers, simple paths | Drunkard's Walk | **MANDATORY** [drunknard_walk_path.gd](scripts/drunknard_walk_path.gd) |
| Structured rooms + hallways | BSP | **MANDATORY** [bsp_tree_rooms.gd](scripts/bsp_tree_rooms.gd) |
| Organic caves / smooth terrain | Cellular Automata (4/5) | **MANDATORY** [cellular_automata_dungeon.gd](scripts/cellular_automata_dungeon.gd) |
| Heightmaps, biomes, infinite terrain | FastNoiseLite → Image | **MANDATORY** [fast_noise_noise2d_master.gd](scripts/fast_noise_noise2d_master.gd) |
| Trees, rocks, spawns (no clumping) | Poisson Disk | **MANDATORY** [poisson_disk_sampling_2d.gd](scripts/poisson_disk_sampling_2d.gd) |
| Tile adjacency / city blocks | Wave Function Collapse | **MANDATORY** [wave_function_collapse_lite.gd](scripts/wave_function_collapse_lite.gd) (lite) or [wfc_level_generator.gd](scripts/wfc_level_generator.gd) (full rules) |
| Room graph before geometry | AStar graph layout | **MANDATORY** [proc_gen_graph_layout.gd](scripts/proc_gen_graph_layout.gd) |
| 3D voxel / smooth terrain mesh | Marching Cubes base | **MANDATORY** [proc_gen_marching_cubes_base.gd](scripts/proc_gen_marching_cubes_base.gd) |
| Infinite chunked 3D terrain | ArrayMesh + LOD chunks | **MANDATORY** [mesh_gen_infinite_terrain.gd](scripts/mesh_gen_infinite_terrain.gd) |
| Plants / branching structures | L-System | **MANDATORY** [l_system_tree_gen.gd](scripts/l_system_tree_gen.gd) |
| Contour / metaball maps (2D) | Marching Squares | **MANDATORY** [marching_squares_metaballs.gd](scripts/marching_squares_metaballs.gd) |

**Routing hints:** Simple path → drunkard; rectangular rooms → BSP; constraint tiles → WFC lite; open-world chunks → noise + `multi_threaded_chunk_gen.gd`. For roguelike run orchestration, hand off to [godot-genre-roguelike](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-roguelike/SKILL.md).

## Available Scripts

### Core (always start here)
- [proc_gen_seed_history.gd](scripts/proc_gen_seed_history.gd) — **MANDATORY** seeded `RandomNumberGenerator` with push/pop state history
- [multi_threaded_chunk_gen.gd](scripts/multi_threaded_chunk_gen.gd) — **MANDATORY** WorkerThreadPool → `call_deferred` chunk finalize pattern

### 2D layout & placement
- [drunknard_walk_path.gd](scripts/drunknard_walk_path.gd) — **MANDATORY** for tunnels/paths (pass local RNG, never global `randi()`)
- [bsp_tree_rooms.gd](scripts/bsp_tree_rooms.gd) — **MANDATORY** for structured floor plans
- [cellular_automata_dungeon.gd](scripts/cellular_automata_dungeon.gd) — **MANDATORY** for organic caves
- [poisson_disk_sampling_2d.gd](scripts/poisson_disk_sampling_2d.gd) — **MANDATORY** for blue-noise prop/enemy placement
- [wave_function_collapse_lite.gd](scripts/wave_function_collapse_lite.gd) — **MANDATORY** lite WFC with entropy + `max_iterations`
- [wfc_level_generator.gd](scripts/wfc_level_generator.gd) — full WFC with tile-library adjacency rules
- [proc_gen_graph_layout.gd](scripts/proc_gen_graph_layout.gd) — graph-before-geometry via AStar2D/3D

### Noise & 3D
- [fast_noise_noise2d_master.gd](scripts/fast_noise_noise2d_master.gd) — **MANDATORY** FastNoiseLite → Image heightmaps
- [mesh_gen_infinite_terrain.gd](scripts/mesh_gen_infinite_terrain.gd) — runtime ArrayMesh terrain with LOD potential
- [proc_gen_marching_cubes_base.gd](scripts/proc_gen_marching_cubes_base.gd) — 3D mesh from voxel data
- [marching_squares_metaballs.gd](scripts/marching_squares_metaballs.gd) — 2D contour extraction
- [l_system_tree_gen.gd](scripts/l_system_tree_gen.gd) — procedural plant/tree grammar

## Godot 4.7: Procedural 3D

- **Path3D snap-to-colliders** for spline-based road/river generation on terrain colliders.

## Expert Procedural Patterns

### 1. 3D Terrain via ArrayMesh (Marching Cubes)
For voxel-like or smooth organic terrain, use `ArrayMesh` to generate geometry from code.
- **Logic**: Calculate vertices, normals, and indices in a worker thread.
- **Commit**: Use `add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)` to create the mesh.
- **Performance**: Use `create_trimesh_collision()` only for the current chunk to keep physics updates fast.

### 2. Graph-Based Dungeon Logic
Don't generate your dungeon geometry first. Build a logical graph using `AStar2D`.
- **Vertices**: Represent "Rooms".
- **Edges**: Represent "Hallways" or "Doors".
- **Benefit**: You can easily run validation (is every room reachable?) before spawning a single mesh.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [FastNoiseLite](https://docs.godotengine.org/en/stable/classes/class_fastnoiselite.html) — seed, frequency, noise type, and `get_image()`/`get_noise_2d()` for heightmaps and biome masks.
- [Random number generation](https://docs.godotengine.org/en/stable/tutorials/math/random_number_generation.html) — why per-generator `RandomNumberGenerator` seeds beat global `randi()` for shareable runs.
- [RandomNumberGenerator](https://docs.godotengine.org/en/stable/classes/class_randomnumbergenerator.html) — `seed`/`state` APIs for deterministic sequences and undoable RNG history.
- [Using multiple threads](https://docs.godotengine.org/en/stable/tutorials/performance/using_multiple_threads.html) — offload chunk/WFC work without freezing the main loop.
- [Thread-safe APIs](https://docs.godotengine.org/en/stable/tutorials/performance/thread_safe_apis.html) — which Godot APIs workers may call; SceneTree/node creation stays on the main thread.
- [WorkerThreadPool](https://docs.godotengine.org/en/stable/classes/class_workerthreadpool.html) — `add_task` + `call_deferred` finalize pattern for async chunk generation.
- [Using ArrayMesh](https://docs.godotengine.org/en/stable/tutorials/3d/procedural_geometry/arraymesh.html) — commit vertex/normal/index arrays for marching-cubes and infinite terrain meshes.
- [Using SurfaceTool](https://docs.godotengine.org/en/stable/tutorials/3d/procedural_geometry/surfacetool.html) — incremental vertex building and normal generation for runtime planes.
- [Using TileMaps](https://docs.godotengine.org/en/stable/tutorials/2d/using_tilemaps.html) — TileMapLayer/pattern batch writes after BSP, CA, WFC, or drunkard-walk grids.
- [Using GridMaps](https://docs.godotengine.org/en/stable/tutorials/3d/using_gridmaps.html) — modular 3D cell placement backend for dungeon/terrain generators.
- [Navigation introduction (3D)](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_introduction_3d.html) — rebake NavigationRegion meshes after procedural geometry lands.
- [AStar2D](https://docs.godotengine.org/en/stable/classes/class_astar2d.html) — room/hallway graph validation before spawning tiles or meshes.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — scenes, resources, and import basics before generators emit TileMaps, GridMaps, or ArrayMeshes.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — typed arrays, `call_deferred`, and WorkerThreadPool task patterns used across every generator script.
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — Resource-backed tile libraries, adjacency rules, and seed configs instead of hard-coded magic tables.

#### Complements
- [godot-tilemap-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tilemap-mastery/SKILL.md) — `set_pattern` / terrain connect batching so large CA/WFC grids do not call `set_cell` per tile.
- [godot-3d-world-building](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md) — GridMap/MeshLibrary/CSG placement backends that consume room graphs and heightmaps.
- [godot-navigation-pathfinding](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md) — runtime navmesh bake after rooms, caves, or terrain chunks finish.
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — budgets for mesh commits, collision trimeshes, and MultiMesh prop scattering after generation.
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — persist seed + player deltas instead of serializing every generated chunk.
- [godot-scene-management](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md) — threaded load/unload of chunk scenes that wrap generated data.
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — sample spawn density, loot tables, and room difficulty against seed distributions before shipping.

#### Downstream / consumers
- [godot-genre-roguelike](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-roguelike/SKILL.md) — run-based dungeon crawlers that consume BSP/WFC/drunkard generators and seeded RNG.
- [godot-genre-sandbox](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-sandbox/SKILL.md) — voxel/chunk worlds and cellular-automata sandboxes built on infinite terrain and CA scripts.
- [godot-genre-open-world](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-open-world/SKILL.md) — chunk streaming and floating-origin layers that wrap multi-threaded chunk gen.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — library router and mirrored module entry for cross-skill discovery.
