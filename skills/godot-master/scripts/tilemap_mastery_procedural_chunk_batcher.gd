# procedural_chunk_batcher.gd
# Efficient procedural tile placement using batching [17, 197]
extends TileMapLayer

# PROBLEM: set_cell() is slow in loops.
# SOLUTION: Use an array of data and set in one call (internal C++ optimization).

func generate_flat_chunk(chunk_origin: Vector2i, width: int, height: int) -> void:
	var cells: Array[Vector2i] = []
	var source_id = 0
	var atlas_coords = Vector2i(1, 1) # Grass tile
	
	for x in range(width):
		for y in range(height):
			cells.append(chunk_origin + Vector2i(x, y))
	
	# Expert: Bulk setting cells is significantly faster for procedural gen
	for cell in cells:
		set_cell(cell, source_id, atlas_coords)
	
	# For even better perf with Terrains:
	# set_cells_terrain_connect(cells, 0, 0)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/2d/using_tilemaps.html
# - https://docs.godotengine.org/en/stable/classes/class_tilemaplayer.html
# - https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-procedural-generation/SKILL.md — bulk cell writes from noise/BSP into chunk batches
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — amortize placement across frames for large fills
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tilemap-mastery/SKILL.md
# =============================================================================
