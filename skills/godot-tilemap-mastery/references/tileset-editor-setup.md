# TileSet editor setup (Steps 1–3)

Official Docs own the full walkthrough — this is the expert checklist agents forget.

## Step 1: TileSet resource

1. Add `TileMapLayer`
2. Inspector → TileSet → New TileSet
3. Open bottom TileSet editor

## Step 2: Atlas

1. **+ → Atlas** → pick tile sheet
2. Set separation / texture region size (e.g. 16×16)

## Step 3: Physics / navigation / custom data

Per-tile paint collision polygons, navigation polygons, and custom data layers (HP, friction, hazard).

```gdscript
# Each tile can expose:
# - Physics Layer collision
# - Terrain autotile membership
# - Custom Data (int/float/StringName)
```

**Do NOT** hand-paint organic blobs when terrain sets exist — use `set_cells_terrain_connect`.
