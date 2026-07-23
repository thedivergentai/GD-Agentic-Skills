# tile_pattern_stamper.gd
# Using TileMapPatterns for complex, multi-tile stamps
extends TileMapLayer

# Patterns allow you to copy/paste chunks of tiles efficiently.

func stamp_house(origin: Vector2i, pattern: TileMapPattern) -> void:
	# Patterns preserve Source IDs, Atlas Coords, and Alternative IDs
	set_pattern(origin, pattern)

func copy_area_to_pattern(rect: Rect2i) -> TileMapPattern:
	# Captures a region for later use (e.g., custom level editor)
	return get_pattern(get_used_cells_by_id().filter(func(c): return rect.has_point(c)))
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_tilemappattern.html
# - https://docs.godotengine.org/en/stable/classes/class_tilemaplayer.html
# - https://docs.godotengine.org/en/stable/tutorials/2d/using_tilemaps.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-procedural-generation/SKILL.md — stamp prefab rooms/structures instead of cell loops
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-metroidvania/SKILL.md — reusable room prefabs stamped into connected maps
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tilemap-mastery/SKILL.md
# =============================================================================
