# Procedural Algorithm Recipes (load on demand)

> **MANDATORY** when implementing drunkard walk, BSP, noise biomes, WFC lite, or loot tables beyond the Golden Path scripts. All heavy work off-thread; SceneTree commits on main thread only.

## Drunkard's walk (organic caves)

```gdscript
func generate_dungeon(width: int, height: int, fill_percent: float = 0.4) -> Array:
    var grid: Array = []
    for y in height:
        grid.append(Array().duplicate(width))  # 1 = wall
    var x := width / 2
    var y := height / 2
    var floor_tiles := 0
    var target := int(width * height * fill_percent)
    var rng := RandomNumberGenerator.new()
    while floor_tiles < target:
        if grid[y][x] == 1:
            grid[y][x] = 0
            floor_tiles += 1
        match rng.randi() % 4:
            0: x = clampi(x + 1, 0, width - 1)
            1: x = clampi(x - 1, 0, width - 1)
            2: y = clampi(y + 1, 0, height - 1)
            3: y = clampi(y - 1, 0, height - 1)
    return grid
```

See [drunknard_walk_path.gd](../scripts/drunknard_walk_path.gd).

## Perlin / FastNoiseLite biomes

```gdscript
var noise := FastNoiseLite.new()
noise.seed = run_seed
noise.frequency = 0.05
# Prefer noise.get_image() once — never sample per frame in _process
```

See [fast_noise_noise2d_master.gd](../scripts/fast_noise_noise2d_master.gd).

## BSP room split

Full `BSPRoom.split()` recursion — [bsp_tree_rooms.gd](../scripts/bsp_tree_rooms.gd). Validate `min_size` before split to avoid degenerate leaves.

## Random loot tables

```gdscript
func roll_rarity(rng: RandomNumberGenerator) -> String:
    var roll := rng.randf()
    if roll < 0.6: return "common"
    if roll < 0.85: return "uncommon"
    if roll < 0.95: return "rare"
    return "legendary"
```

Pair with [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) for `ItemData` resources.

## WFC lite loop

Always cap iterations — impossible adjacency rules can spin forever. See [wave_function_collapse_lite.gd](../scripts/wave_function_collapse_lite.gd).

## Expert: graph-before-geometry

Build room graph with `AStar2D` first — validate reachability before spawning tiles. [proc_gen_graph_layout.gd](../scripts/proc_gen_graph_layout.gd).

## Expert: marching cubes / ArrayMesh

Vertices/normals in worker thread → `add_surface_from_arrays` on main thread → `create_trimesh_collision()` only for active chunk. [proc_gen_marching_cubes_base.gd](../scripts/proc_gen_marching_cubes_base.gd).

## Serialization contract

Persist **seed** + player deltas — not full chunk arrays unless required. [proc_gen_seed_history.gd](../scripts/proc_gen_seed_history.gd).

## Godot 4.7

Path3D snap-to-colliders for spline roads/rivers on terrain colliders.
