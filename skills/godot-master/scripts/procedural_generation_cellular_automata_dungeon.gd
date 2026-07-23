# cellular_automata_dungeon.gd
# Smooth cave generation using Cellular Automata (4/5 rule)
extends Node

@export var width := 60
@export var height := 40
@export var fill_percent := 45

var map: Array = []
var rng := RandomNumberGenerator.new()

func generate_caves(seed: int = 0) -> Array:
	rng.seed = seed
	_random_fill()
	for i in range(5):
		_smooth_map()
	return map

func _smooth_map() -> void:
	var new_map = map.duplicate(true)
	for x in range(1, width - 1):
		for y in range(1, height - 1):
			var neighbors := _get_neighbor_count(x, y)
			if neighbors > 4:
				new_map[x][y] = 1 # Wall
			elif neighbors < 4:
				new_map[x][y] = 0 # Floor
	map = new_map

func _get_neighbor_count(grid_x: int, grid_y: int) -> int:
	var count := 0
	for x in range(grid_x - 1, grid_x + 2):
		for y in range(grid_y - 1, grid_y + 2):
			if x != grid_x or y != grid_y:
				count += map[x][y]
	return count

func _random_fill() -> void:
	map.clear()
	for x in range(width):
		map.append([])
		for y in range(height):
			map[x].append(1 if rng.randi() % 100 < fill_percent else 0)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/math/random_number_generation.html
# - https://docs.godotengine.org/en/stable/tutorials/2d/using_tilemaps.html
# - https://docs.godotengine.org/en/stable/classes/class_randomnumbergenerator.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tilemap-mastery/SKILL.md — paint CA walls/floors with terrain autotile
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-sandbox/SKILL.md — cellular automata sandboxes reuse the same grid rules
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-procedural-generation/SKILL.md
# =============================================================================
