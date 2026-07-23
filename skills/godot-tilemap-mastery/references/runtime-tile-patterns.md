# Runtime TileMapLayer patterns

## Basic cell API

```gdscript
set_cell(Vector2i(0, 0), source_id, atlas_coords)
var atlas_coords := get_cell_atlas_coords(Vector2i(0, 0))
erase_cell(Vector2i(0, 0))
```

Always `local_to_map(global_pos)` — never pass world coords directly.

## Flood fill

BFS over neighbors; compare `get_cell_atlas_coords` before writing.

## Terrain connect

```gdscript
set_cells_terrain_connect([Vector2i(x, y)], terrain_set, terrain, false)
```

Prefer over per-cell `set_cell` for organic shapes.

## Multi-layer scene tree

Ground / decoration / collision as sibling `TileMapLayer` nodes with distinct `z_index` and physics layers.

## Custom data reads

```gdscript
func get_tile_damage(tile_pos: Vector2i) -> int:
    var tile_data := get_cell_tile_data(tile_pos)
    if tile_data:
        return tile_data.get_custom_data("damage_per_second")
    return 0
```

Cache hot reads — [fast_metadata_cache.gd](../scripts/fast_metadata_cache.gd).

## Destructible / highlight

See [destructible_tile_logic.gd](../scripts/destructible_tile_logic.gd). After erase: refresh nav ([nav_mesh_teleport_fix.gd](../scripts/nav_mesh_teleport_fix.gd)).

## Chunking

`CHUNK_SIZE` grids as child TileMapLayers; load/unload by player chunk — [tilemap_chunking.gd](../scripts/tilemap_chunking.gd).
