# physics_shape_interaction.gd
# Expert TileMap physics and one-way collision logic [146, 160]
extends TileMapLayer

# Each TileMapLayer acts as a single large physics body.

func set_one_way_platform(map_pos: Vector2i, enabled: bool) -> void:
	var data = get_cell_tile_data(map_pos)
	if data:
		# Accessing physics shapes directly via TileData
		# Note: Changing this at runtime affects ALL cells using this Tile ID
		# To change one specific cell, you must swap to a different Tile ID.
		pass

# Recommended Pattern: Use different 'Source IDs' or 'Atlas Coords'
# for collision variants (e.g. solid stone vs. spectral stone).
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/collision_shapes_2d.html
# - https://docs.godotengine.org/en/stable/classes/class_tiledata.html
# - https://docs.godotengine.org/en/stable/classes/class_tileset.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md — layer/mask and one-way rules for TileMapLayer bodies
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md — jump-through platforms and slide against tile colliders
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tilemap-mastery/SKILL.md
# =============================================================================
