# bsp_tree_rooms.gd
# Binary Space Partitioning for structured floor plans
extends Node

class RoomNode:
	var x: int; var y: int; var w: int; var h: int
	var left: RoomNode; var right: RoomNode
	
	func split():
		# Logic to split vertically or horizontally 
		# until min_room_size is reached.
		pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/math/random_number_generation.html
# - https://docs.godotengine.org/en/stable/classes/class_astar2d.html
# - https://docs.godotengine.org/en/stable/tutorials/2d/using_tilemaps.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-roguelike/SKILL.md — structured floor plans for run-based dungeons
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tilemap-mastery/SKILL.md — place rooms then batch hallway floors
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-procedural-generation/SKILL.md
# =============================================================================
