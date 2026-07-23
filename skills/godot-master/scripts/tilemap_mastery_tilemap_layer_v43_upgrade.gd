# tilemap_layer_v43_upgrade.gd
# Handling multiple TileMapLayer nodes (Godot 4.3+ standard)
extends Node2D

# In 4.3+, the single TileMap node with 'Layers' is deprecated. 
# Use multiple TileMapLayer children for better performance and flexibility.

func get_combined_used_rect() -> Rect2:
	var total_rect = Rect2()
	for child in get_children():
		if child is TileMapLayer:
			var layer_rect = child.get_used_rect()
			# Convert map to world
			var world_rect = Rect2(child.map_to_local(layer_rect.position), layer_rect.size * 16) # Assume 16px
			total_rect = total_rect.merge(world_rect)
	return total_rect
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/2d/using_tilemaps.html
# - https://docs.godotengine.org/en/stable/classes/class_tilemaplayer.html
# - https://docs.godotengine.org/en/stable/classes/class_tilemap.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — scene migration when splitting legacy TileMap into layers
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — reparent layer nodes without breaking packed levels
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tilemap-mastery/SKILL.md
# =============================================================================
