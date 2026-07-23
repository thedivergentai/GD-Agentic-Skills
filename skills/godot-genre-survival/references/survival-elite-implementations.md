# Survival Elite Implementations (load on demand)

> **MANDATORY** when starting base-building snap placement or biome/noise world work — not for first-pass needs/inventory/crafting (use `scripts/` catalog).

## When to open this file
- GridMap snap base-building beyond `SurvivalPatterns.place_if_empty`
- AStar reroute when structures block threat AI
- FastNoiseLite biome sampling at scale (pair with `SurvivalPatterns.generate_noise_chunk_async`)

## Do NOT Load
- Hunger/thirst wiring — use `status_depletion_manager.gd`
- Bag/stack basics — use `inventory_data.gd`; weight caps → godot-inventory-system (Do NOT re-teach grid drag/drop here)
- Full procedural terrain pipeline — MANDATORY-link godot-procedural-generation when noise maps exceed chunk helpers

---

## 1. Grid-Map-Snap (Base-Building)

Use `GridMap` octants. **MANDATORY:** `SurvivalPatterns.place_if_empty` / `get_snapped_pos` rather than freeform MeshInstance walls.

## 2. AStar-Path-Avoidance

When structures place, mark `AStarGrid2D` cells solid so threat AI reroutes immediately (pair with godot-ai-navigation).

## 3. FastNoiseLite Biomes

Sample noise gradients → biome ids; keep generation off the main thread via `SurvivalPatterns.generate_noise_chunk_async` for large maps.
