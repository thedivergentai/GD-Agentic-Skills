# Expert TileMap architectures

## Isometric Y-sort

`TILE_SHAPE_ISOMETRIC` + `y_sort_enabled` on parent **and** each `TileMapLayer`. Tune `y_sort_origin` on tall `TileData`.

See [sorting_Z_layering.gd](../scripts/sorting_Z_layering.gd).

## TileMapPattern stamping

Capture with `get_pattern(coords)`; stamp with `set_pattern(position, pattern)` — [tile_pattern_stamper.gd](../scripts/tile_pattern_stamper.gd).

> [!CAUTION]
> Pattern stamp beats thousands of `set_cell` calls and preserves source_id/atlas/alternative.

## Layer diff / save deltas

Iterate `get_used_cells()` on source vs target; sync differing `source_id` / atlas / alternative — persist deltas via [tilemap_data_manager.gd](../scripts/tilemap_data_manager.gd).

## Navigation

Paint nav polygons in TileSet; after runtime edits batch-rebuild regions — do not rebuild every single cell.
