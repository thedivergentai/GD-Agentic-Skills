---
name: godot-tilemap-mastery
description: "Expert blueprint for TileMapLayer and TileSet systems for efficient 2D level design. Covers terrain autotiling, physics layers, custom data, navigation integration, and runtime manipulation. Use when building grid-based levels OR implementing destructible tiles. Keywords TileMapLayer, TileSet, terrain, autotiling, atlas, physics layer, custom data."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# TileMap Mastery

TileMapLayer routing + trade-offs — not TileSet editor Steps 1–3 tutorials (see Official Docs).

## NEVER Do in TileMaps

- **NEVER call `set_cell()` in huge loops without batching** — Prefer terrain connect, patterns, or chunk batchers.
- **NEVER forget `source_id` in `set_cell`** — Wrong overload → crash or silent miss.
- **NEVER mix world coords with tile coords** — Always `local_to_map` / `map_to_local`.
- **NEVER hand-paint organic blobs when terrains exist** — Use terrain sets + `set_cells_terrain_connect`.
- **NEVER put dynamic actors in the TileMap** — Enemies/pickups are nodes; tiles are geometry / destructible cells.
- **NEVER spam `get_cell_tile_data()` every physics frame** — Cache metadata ([fast_metadata_cache.gd](../scripts/tilemap_mastery_fast_metadata_cache.gd)).

---

## Decision Tree: How to Write Cells

| Goal | Prefer | Script | Trade-off |
|------|--------|--------|-----------|
| Organic ground / roads / rivers | **Terrain autotile** | [terrain_autotile.gd](../scripts/tilemap_mastery_terrain_autotile.gd) / [terrain_path_painter.gd](../scripts/tilemap_mastery_terrain_path_painter.gd) | Setup cost in TileSet; fastest designer iteration |
| Prefab rooms / houses / stamps | **TileMapPattern** | [tile_pattern_stamper.gd](../scripts/tilemap_mastery_tile_pattern_stamper.gd) | Great for procgen pieces; less flexible per-cell |
| Sparse / precise edits | **`set_cell`** | — | Fine for few cells; bad for thousands/frame |
| Huge streaming worlds | **Chunks** | [tilemap_chunking.gd](../scripts/tilemap_mastery_tilemap_chunking.gd) / [procedural_chunk_batcher.gd](../scripts/tilemap_mastery_procedural_chunk_batcher.gd) / [tilemap_data_manager.gd](../scripts/tilemap_mastery_tilemap_data_manager.gd) | Indirection + load boundaries |
| Destructible dig/break | Custom data HP | [destructible_tile_logic.gd](../scripts/tilemap_mastery_destructible_tile_logic.gd) | Must refresh nav/physics after edits |
| Gameplay queries (friction/hazard) | Custom data + cache | [gameplay_data_query.gd](../scripts/tilemap_mastery_gameplay_data_query.gd) / [fast_metadata_cache.gd](../scripts/tilemap_mastery_fast_metadata_cache.gd) | Cache invalidation on set_cell |
| Nav after edits | Runtime nav fix | [nav_mesh_teleport_fix.gd](../scripts/tilemap_mastery_nav_mesh_teleport_fix.gd) | Costly if every cell; batch rebuilds |
| One-way / physics layers | TileSet physics | [physics_shape_interaction.gd](../scripts/tilemap_mastery_physics_shape_interaction.gd) | Align with CharacterBody masks |
| Iso / multi-floor sort | Y-sort layers | [sorting_Z_layering.gd](../scripts/tilemap_mastery_sorting_Z_layering.gd) | Parent + all layers need y_sort |
| Legacy TileMap → layers | Migration | [tilemap_layer_v43_upgrade.gd](../scripts/tilemap_mastery_tilemap_layer_v43_upgrade.gd) | One-time upgrade aid |

Editor atlas/physics paint setup: Official Documentation in Reference — **Do NOT** reload Steps 1–3 / flood_fill tutorials from this skill body.

## Available Scripts (single index + MANDATORY triggers)

| Task | MANDATORY script(s) |
|------|---------------------|
| Serialize / large world data | [tilemap_data_manager.gd](../scripts/tilemap_mastery_tilemap_data_manager.gd) |
| Runtime terrain paths | [terrain_path_painter.gd](../scripts/tilemap_mastery_terrain_path_painter.gd) / [terrain_autotile.gd](../scripts/tilemap_mastery_terrain_autotile.gd) |
| Destructible tiles | [destructible_tile_logic.gd](../scripts/tilemap_mastery_destructible_tile_logic.gd) |
| Custom data gameplay reads | [gameplay_data_query.gd](../scripts/tilemap_mastery_gameplay_data_query.gd) (+ [fast_metadata_cache.gd](../scripts/tilemap_mastery_fast_metadata_cache.gd) if hot) |
| Procedural bulk place | [procedural_chunk_batcher.gd](../scripts/tilemap_mastery_procedural_chunk_batcher.gd) |
| Chunk stream in/out | [tilemap_chunking.gd](../scripts/tilemap_mastery_tilemap_chunking.gd) |
| Pattern stamp prefabs | [tile_pattern_stamper.gd](../scripts/tilemap_mastery_tile_pattern_stamper.gd) |
| Nav repair after edits | [nav_mesh_teleport_fix.gd](../scripts/tilemap_mastery_nav_mesh_teleport_fix.gd) |
| One-way / physics layer ops | [physics_shape_interaction.gd](../scripts/tilemap_mastery_physics_shape_interaction.gd) |
| Y-sort / Z layering | [sorting_Z_layering.gd](../scripts/tilemap_mastery_sorting_Z_layering.gd) |
| 4.3+ multi-layer upgrade | [tilemap_layer_v43_upgrade.gd](../scripts/tilemap_mastery_tilemap_layer_v43_upgrade.gd) |

## Expert Trade-offs (routing only)

- **Isometric Y-sort:** enable `y_sort_enabled` on parent and each TileMapLayer; tune `y_sort_origin` on tall tiles — see [sorting_Z_layering.gd](../scripts/tilemap_mastery_sorting_Z_layering.gd).
- **Procgen:** stamp patterns or batch terrain; avoid per-cell `set_cell` storms — [tile_pattern_stamper.gd](../scripts/tilemap_mastery_tile_pattern_stamper.gd) / [procedural_chunk_batcher.gd](../scripts/tilemap_mastery_procedural_chunk_batcher.gd).
- **Diff / save deltas:** compare `get_used_cells()` source_id/atlas between layers; persist deltas via [tilemap_data_manager.gd](../scripts/tilemap_mastery_tilemap_data_manager.gd) rather than full maps when possible.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Using TileMaps](https://docs.godotengine.org/en/stable/tutorials/2d/using_tilemaps.html) — TileMapLayer workflow, layers, runtime `set_cell` / terrain painting, and when multiple layers beat a single legacy TileMap.
- [Using TileSets](https://docs.godotengine.org/en/stable/tutorials/2d/using_tilesets.html) — atlas sources, terrains, physics/navigation/custom data layers painted in the TileSet editor.
- [TileMapLayer](https://docs.godotengine.org/en/stable/classes/class_tilemaplayer.html) — cell APIs, terrain connect, patterns, coordinate conversion, and runtime tile-data updates.
- [TileSet](https://docs.godotengine.org/en/stable/classes/class_tileset.html) — physics/terrain/custom-data layer definitions shared by every TileMapLayer that references the resource.
- [TileSetAtlasSource](https://docs.godotengine.org/en/stable/classes/class_tilesetatlassource.html) — atlas grid, alternatives, and per-tile TileData that drive collision and metadata.
- [TileData](https://docs.godotengine.org/en/stable/classes/class_tiledata.html) — custom data, physics polygons, navigation polygons, and `y_sort_origin` used at query time.
- [TileMapPattern](https://docs.godotengine.org/en/stable/classes/class_tilemappattern.html) — capture/stamp multi-tile prefabs without per-cell `set_cell` loops.
- [Collision shapes (2D)](https://docs.godotengine.org/en/stable/tutorials/physics/collision_shapes_2d.html) — shape choices and one-way collision patterns that TileSet physics layers expose to CharacterBody2D.
- [Navigation introduction (2D)](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_introduction_2d.html) — how tile navigation polygons feed NavigationRegion2D / NavigationAgent2D after edits.
- [Canvas layers](https://docs.godotengine.org/en/stable/tutorials/2d/canvas_layers.html) — z-index / CanvasLayer separation for ground, decoration, and roof TileMapLayers.
- [Background loading](https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html) — threaded ResourceLoader patterns for streaming chunk TileSets / tilemap scenes without hitch spikes.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — scene tree, resources, and import layout before authoring TileSet atlases and multi-layer level scenes.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — typed Vector2i APIs, caching patterns, and signal-up/call-down structure used in runtime tile managers.
- [godot-2d-physics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md) — collision layers/masks and StaticBody2D-equivalent behavior that TileMapLayer physics layers participate in.

#### Complements
- [godot-characterbody-2d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md) — `move_and_slide` against tile colliders, one-way platforms, and floor/wall queries over TileMapLayer geometry.
- [godot-navigation-pathfinding](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md) — NavigationAgent2D / region updates when destructible or procedural tiles change walkable polygons.
- [godot-camera-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md) — Camera2D limits and follow radii that drive chunk load/unload around the player.
- [godot-adapt-3d-to-2d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-3d-to-2d/SKILL.md) — isometric / Y-sort depth tricks that pair with `TILE_SHAPE_ISOMETRIC` and multi-floor TileMapLayers.
- [godot-scene-management](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md) — packing and swapping chunk scenes so large tile worlds stream without orphaned layers.
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — batching, cache budgets, and profiler checks when `set_cell` / custom-data queries dominate frame time.

#### Downstream / consumers
- [godot-procedural-generation](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-procedural-generation/SKILL.md) — noise/BSP/WFC generators that write cells via terrain connect, patterns, or chunk batchers.
- [godot-genre-platformer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-platformer/SKILL.md) — precision platformer levels built from TileSet physics, one-ways, and hazard custom data.
- [godot-genre-metroidvania](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-metroidvania/SKILL.md) — interconnected room grids, ability gates, and map revelation layered on TileMapLayer chunks.
- [godot-genre-sandbox](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-sandbox/SKILL.md) — diggable/buildable 2D worlds that treat TileMapLayer as the editable terrain backend.
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — simulate hazard density, destructible HP, and traversal cost encoded in tile custom data before shipping maps.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — library router and mirrored module entry for cross-skill discovery.
