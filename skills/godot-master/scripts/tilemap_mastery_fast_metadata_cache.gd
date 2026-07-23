# fast_metadata_cache.gd
# Optimizing Custom Data lookups for massive levels [22, 181]
extends TileMapLayer

# PROBLEM: get_cell_tile_data() can be slow if called thousands of times per frame.
# SOLUTION: Cache semantic metadata in a Dictionary.

var _hazard_cache: Dictionary = {} # Vector2i -> bool

func rebuild_hazard_cache() -> void:
	_hazard_cache.clear()
	for cell in get_used_cells():
		var data = get_cell_tile_data(cell)
		if data and data.get_custom_data("is_lava"):
			_hazard_cache[cell] = true

func is_cell_hazardous(map_pos: Vector2i) -> bool:
	return _hazard_cache.get(map_pos, false)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_tiledata.html
# - https://docs.godotengine.org/en/stable/classes/class_tilemaplayer.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/general_optimization.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — cache custom-data lookups outside _physics_process hot paths
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — Dictionary cache invalidation patterns for tile metadata
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tilemap-mastery/SKILL.md
# =============================================================================
