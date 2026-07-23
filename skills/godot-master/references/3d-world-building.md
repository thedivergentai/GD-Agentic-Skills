---
name: godot-3d-world-building
description: "Expert patterns for 3D level design using GridMap with MeshLibrary, CSG constructive solid geometry, occlusion, and runtime GridMap builders. Use when building 3D levels, modular tilesets, or BSP-style geometry. For sky/fog/Environment recipes, route to godot-3d-lighting. Trigger keywords: GridMap, MeshLibrary, set_cell_item, get_cell_item, map_to_local, local_to_map, CSGCombiner3D, CSGBox3D, CSGSphere3D, CSGPolygon3D, OccluderInstance3D, bake CSG."
---

# 3D World Building

Expert guidance for level design with GridMaps, CSG bake, and occlusion — not lighting/atmosphere authorship.

## NEVER Do

- **NEVER forget to bake GridMap navigation** — GridMaps don't auto-generate navigation meshes. Use EditorPlugin or manual NavigationRegion3D.
- **NEVER use CSG for final game geometry** — CSG is for prototyping. Convert to static meshes for performance (use "Bake CSG Mesh" in editor).
- **NEVER scale GridMap cell size after placing tiles** — Changing `cell_size` doesn't update existing tiles, causing misalignment. Set it once at the start.
- **NEVER ship a MeshLibrary item without verifying collision** — Call `mesh_library.get_item_shapes(tile_index)` (or inspect the source scene StaticBody3D + CollisionShape3D) before convert; empty shapes spawn visual-only geometry players fall through.
- **NEVER bake CSG before the combiner has a settled frame** — Extract meshes only after `await get_tree().process_frame` (see [safe_csg_baking.gd](../scripts/3d_world_building_safe_csg_baking.gd)); baking mid-recompute yields empty or stale ArrayMesh data. Order: finish boolean edits → wait one frame → bake → delete CSG → add collision.
- **NEVER animate CSG nodes during gameplay** — Moving a CSG node within another forces the CPU to recalculate the boolean geometry, causing significant performance drops.
- **NEVER place generic logic nodes in a GridMap** — GridMap is highly optimized only for meshes, navigation, and collision. Use proxy tiles + scripts for spawns/triggers.
- **NEVER use non-manifold meshes in CSG** — Custom CSGMesh3D assets must be manifold (closed, no self-intersections). Non-manifold meshes break the CSG algorithm.

---

## Godot 4.7: 3D Editor Workflow

- **Path3D** supports snap-to-colliders for path point placement on geometry.
- **3D vertex snapping** with vertex/origin base setting (editor B key workflow).
- `EditorSceneFormatImporter` uses **ImportFlags** enum for import constants.

## Available Scripts

> **MANDATORY**: Read the appropriate script before implementing the corresponding pattern.
> **Do NOT Load** lighting/sky/fog scripts or deep Environment tutorials here — route to [godot-3d-lighting](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-lighting/SKILL.md).

### [collision_gen.gd](../scripts/3d_world_building_collision_gen.gd)
Automatic collision shape generation from meshes. Use when importing models without collision or for procedural geometry.

### [gridmap_runtime_builder.gd](../scripts/3d_world_building_gridmap_runtime_builder.gd)
**Sole streaming / runtime GridMap entry** — batch tile placement, chunk-style rebuilds, and auto-navigation baking. Prefer this over ad-hoc WorldStreamer stubs.

### [csg_bake_tool.gd](../scripts/3d_world_building_csg_bake_tool.gd)
EditorScript to bake CSG geometry to static meshes with proper materials and collision. Use when finalizing level prototypes.

### [safe_csg_baking.gd](../scripts/3d_world_building_safe_csg_baking.gd)
Expert technique for safe CSG baking. Awaits the end of the frame before extracting baked meshes to avoid empty data.

### [lod_manager.gd](../scripts/3d_world_building_lod_manager.gd)
Level-of-detail switching based on camera distance. Manages mesh swapping and visibility for large outdoor scenes.

### [occlusion_setup.gd](../scripts/3d_world_building_occlusion_setup.gd)
OccluderInstance3D configuration for manual occlusion culling. Use for indoor levels with many rooms.

---

## Golden Path (GridMap / CSG / Occlusion)

1. **MeshLibrary** — Source scene: MeshInstance3D + StaticBody3D/CollisionShape3D → Convert To MeshLibrary → verify `get_item_shapes()`.
2. **GridMap** — Set `cell_size` once, place cells, bake NavigationRegion3D. Runtime rebuilds: **MANDATORY** [gridmap_runtime_builder.gd](../scripts/3d_world_building_gridmap_runtime_builder.gd).
3. **CSG greybox** — Prototype with CSGCombiner3D → **MANDATORY** [safe_csg_baking.gd](../scripts/3d_world_building_safe_csg_baking.gd) / [csg_bake_tool.gd](../scripts/3d_world_building_csg_bake_tool.gd) → delete live CSG.
4. **Occlusion / LOD** — Indoor rooms: [occlusion_setup.gd](../scripts/3d_world_building_occlusion_setup.gd). Distance swaps: [lod_manager.gd](../scripts/3d_world_building_lod_manager.gd).
5. **Sky / fog / WorldEnvironment** — Out of scope; use peer **godot-3d-lighting** (keep only a DirectionalLight3D present if volumetric fog is enabled elsewhere).

---

## GridMap Fundamentals

### Setup (compact)

```gdscript
extends GridMap

func _ready() -> void:
    mesh_library = load("res://tilesets/dungeon_library.tres")
    cell_size = Vector3(2, 2, 2)  # Set once; never after tiles exist
```

Cell API: `set_cell_item(pos, index[, orientation])`, `get_cell_item`, `INVALID_CELL_ITEM`, `local_to_map` / `map_to_local`. For batch/runtime placement and nav bake, load [gridmap_runtime_builder.gd](../scripts/3d_world_building_gridmap_runtime_builder.gd) — do not paste a custom chunk streamer.

### Collision verification

```gdscript
var shapes := mesh_library.get_item_shapes(tile_index)
if shapes.is_empty():
    push_error("Tile %d has no collision — fix MeshLibrary source scene" % tile_index)
```

---

## CSG Bake Order

1. Finish boolean edits under `CSGCombiner3D`.
2. `await get_tree().process_frame` (WHY: CSG dirty flags settle one frame late).
3. Bake to MeshInstance3D + collision via scripts above; remove CSG from exported scenes.
4. Never animate CSG at runtime.

Brush types (Box/Cylinder/Sphere/Polygon) are editor greybox tools only — not shipping geometry.

---

## Streaming Decision

| Need | Action |
|------|--------|
| Runtime GridMap tiles / chunk rebuild + nav bake | **MANDATORY** [gridmap_runtime_builder.gd](../scripts/3d_world_building_gridmap_runtime_builder.gd) |
| Large open-world scene streaming | Peer [godot-genre-open-world](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-open-world/SKILL.md) |
| Ad-hoc WorldStreamer inline stub | **Cut** — do not reintroduce incomplete load-from-file TODOs |

---

## Expert Techniques

### Spatially Partitioning MultiMeshes
Partition dense props into regional `MultiMeshInstance3D` nodes so frustum/occlusion can cull whole clusters (single MultiMesh AABB draws everything).

### GridMap Logic Proxies
Use invisible proxy tile IDs for spawns/triggers; at `_ready`, `get_used_cells_by_item`, instantiate logic scenes, clear proxy cells. Keep logic off the GridMap itself.

### Interior-Mapping
For city-scale fake interiors, use a spatial shader on window planes — peer [godot-shaders-basics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md). Do not paste full shader recipes here.

### Edge Cases
- **No collision**: empty `get_item_shapes` → fix MeshLibrary source.
- **CSG z-fight**: tiny offset on subtraction brushes before bake.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Using GridMaps](https://docs.godotengine.org/en/stable/tutorials/3d/using_gridmaps.html) — MeshLibrary workflow, cell placement, and when GridMap is the right modular level tool.
- [MeshLibrary](https://docs.godotengine.org/en/stable/classes/class_meshlibrary.html) — item meshes, names, and collision shapes that GridMap instances at runtime.
- [CSG tools](https://docs.godotengine.org/en/stable/tutorials/3d/csg_tools.html) — boolean prototyping with CSGCombiner3D/primitives and the bake-to-mesh handoff.
- [Environment and post-processing](https://docs.godotengine.org/en/stable/tutorials/3d/environment_and_post_processing.html) — WorldEnvironment, Sky, ProceduralSkyMaterial/PanoramaSkyMaterial, and fog modes.
- [Volumetric fog and fog volumes](https://docs.godotengine.org/en/stable/tutorials/3d/volumetric_fog.html) — scattering setup, density/albedo, and why lights are required for visible volumetric fog.
- [Occlusion culling](https://docs.godotengine.org/en/stable/tutorials/3d/occlusion_culling.html) — OccluderInstance3D placement and CPU cost tradeoffs for indoor rooms.
- [Mesh level of detail (LOD)](https://docs.godotengine.org/en/stable/tutorials/3d/mesh_lod.html) — importer auto-LOD versus manual mesh swaps for large outdoor levels.
- [Visibility ranges](https://docs.godotengine.org/en/stable/tutorials/3d/visibility_ranges.html) — GeometryInstance3D distance fade/hysteresis used by LOD managers.
- [Collision shapes (3D)](https://docs.godotengine.org/en/stable/tutorials/physics/collision_shapes_3d.html) — convex/trimesh/primitive choices for MeshLibrary items and baked CSG.
- [Navigation introduction (3D)](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_introduction_3d.html) — NavigationRegion3D baking GridMaps never auto-generate.
- [Background loading](https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html) — ResourceLoader threaded chunk streaming without hitch spikes.
- [Using MultiMesh](https://docs.godotengine.org/en/stable/tutorials/performance/using_multimesh.html) — instancing dense props and why spatial MultiMesh partitions restore culling.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — scene tree, resources, and import basics before MeshLibrary conversion and WorldEnvironment setup.
- [godot-physics-3d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md) — StaticBody3D/CollisionShape3D patterns that must land in MeshLibrary source scenes or players fall through tiles.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — typed GridMap/CSG scripting, signals, and await/process_frame patterns used in bake and runtime builders.

#### Complements
- [godot-3d-lighting](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-lighting/SKILL.md) — DirectionalLight3D and GI that volumetric fog scatters; pair env with real light setup.
- [godot-3d-materials](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-materials/SKILL.md) — StandardMaterial3D/ORM on tiles and baked CSG meshes after greybox.
- [godot-navigation-pathfinding](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md) — bake and update NavigationMesh from GridMap geometry after cell edits.
- [godot-shaders-basics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md) — interior-mapping and other spatial tricks for fake building interiors at city scale.
- [godot-camera-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md) — camera distance drives visibility ranges, LOD swaps, and chunk load radii.
- [godot-scene-management](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md) — scene packing and threaded load queues for stutter-free world streaming.
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — draw-call budgets, occlusion strategy, and MultiMesh partitioning for large levels.

#### Downstream / consumers
- [godot-procedural-generation](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-procedural-generation/SKILL.md) — dungeon/terrain generators that write cells into GridMap as the placement backend.
- [godot-genre-open-world](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-open-world/SKILL.md) — chunk streaming, floating origin, and HLOD built on these world-building primitives.
- [godot-genre-sandbox](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-sandbox/SKILL.md) — player-driven building and editable voxel/grid worlds that reuse GridMap/CSG bake flows.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — library router and mirrored module entry for cross-skill discovery.
