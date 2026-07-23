class_name FogManager extends Node2D

## Grid-based Fog of War masker for TileMapLayer.
## Efficiently clears "fog" tiles based on FOV results.

@export var fog_layer: TileMapLayer
@export var fog_atlas_coord := Vector2i(0, 0) # Coordinate of the black tile in tileset
@export var fog_source_id := 0

func initialize_fog(region: Rect2i) -> void:
	if not fog_layer: return
	for x in range(region.position.x, region.end.x):
		for y in range(region.position.y, region.end.y):
			fog_layer.set_cell(Vector2i(x, y), fog_source_id, fog_atlas_coord)

func reveal_cells(visible_cells: Array[Vector2i]) -> void:
	if not fog_layer: return
	for cell in visible_cells:
		# Setting source_id to -1 removes the cell (erases fog)
		fog_layer.set_cell(cell, -1)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_tilemaplayer.html
# - https://docs.godotengine.org/en/stable/tutorials/2d/using_tilemaps.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tilemap-mastery/SKILL.md — fog layer clears from FOV cell sets
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — tile fog vs GPU mask tradeoffs
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-roguelike/SKILL.md
# =============================================================================
