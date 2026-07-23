# nav_mesh_teleport_fix.gd
# Runtime Navigation updates for dynamic TileMap shifts [214]
extends TileMapLayer

# Godot 4 TileMapLayers can automatically bake navigation.

func update_nav_for_hole(map_pos: Vector2i) -> void:
	# Erasing a cell with a 'Navigation Layer' configured 
	# automatically updates the NavigationServer2D mesh.
	erase_cell(map_pos)
	
	# If results aren't immediate, force a sync:
	# NavigationServer2D.process_frame()
	
	print("Navigation path re-evaluating for hole at: ", map_pos)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_introduction_2d.html
# - https://docs.godotengine.org/en/stable/classes/class_tilemaplayer.html
# - https://docs.godotengine.org/en/stable/classes/class_navigationregion2d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md — agent repath after runtime tile erase / teleport holes
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-sandbox/SKILL.md — dynamic diggable floors that invalidate nav polygons
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tilemap-mastery/SKILL.md
# =============================================================================
