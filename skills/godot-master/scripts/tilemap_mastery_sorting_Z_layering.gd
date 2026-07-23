# sorting_Z_layering.gd
# Handling Y-sorting and Z-index layering for 2.5D [129]
extends TileMapLayer

# In Godot 4, TileMapLayer nodes can participate in Y-sorting.

func _ready() -> void:
	# Enable Y-sorting so children (players) correctly appear 
	# behind/in-front of trees or walls.
	y_sort_enabled = true
	
	# For multi-layered buildings:
	# Layer 1 (Ground): Z-Index 0
	# Layer 2 (Roof): Z-Index 10 + Y-Sort Disabled (always on top)
	
	# Runtime Z-Index modification for 'entering building' visuals
	z_index = -5 if is_underground else 0
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/2d/canvas_layers.html
# - https://docs.godotengine.org/en/stable/classes/class_tilemaplayer.html
# - https://docs.godotengine.org/en/stable/classes/class_tiledata.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-3d-to-2d/SKILL.md — Y-sort / isometric depth with multi-floor TileMapLayers
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md — camera height/floor swaps that change visible z layers
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tilemap-mastery/SKILL.md
# =============================================================================
