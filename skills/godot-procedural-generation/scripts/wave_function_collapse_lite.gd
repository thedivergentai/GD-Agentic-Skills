# wave_function_collapse_lite.gd
# Procedural tile arrangement using WFC principles
extends Node

@export var grid_width: int = 10
@export var grid_height: int = 10
@export var max_iterations: int = 1000

var rng := RandomNumberGenerator.new()
var _possibilities: Array = [] # 2D: each cell holds Array of tile ids
var _collapsed: Array = [] # 2D: bool
var _iterations: int = 0

func initialize(seed: int, tile_ids: Array) -> void:
	rng.seed = seed
	_iterations = 0
	_possibilities.clear()
	_collapsed.clear()
	for y in grid_height:
		var row_p: Array = []
		var row_c: Array = []
		for x in grid_width:
			row_p.append(tile_ids.duplicate())
			row_c.append(false)
		_possibilities.append(row_p)
		_collapsed.append(row_c)

func iterate() -> bool:
	if _iterations >= max_iterations:
		return false
	_iterations += 1
	var pos := find_lowest_entropy()
	if pos.x < 0:
		return false
	if not collapse(pos.x, pos.y):
		return false
	propagate(pos.x, pos.y)
	return true

func find_lowest_entropy() -> Vector2i:
	var best := Vector2i(-1, -1)
	var best_count := 999999
	for y in grid_height:
		for x in grid_width:
			if _collapsed[y][x]:
				continue
			var count: int = _possibilities[y][x].size()
			if count < best_count:
				best_count = count
				best = Vector2i(x, y)
	return best

func collapse(x: int, y: int) -> bool:
	var opts: Array = _possibilities[y][x]
	if opts.is_empty():
		return false
	var chosen = opts[rng.randi() % opts.size()]
	_possibilities[y][x] = [chosen]
	_collapsed[y][x] = true
	return true

func propagate(x: int, y: int) -> void:
	var chosen = _possibilities[y][x][0]
	var neighbors := [
		Vector2i(x + 1, y), Vector2i(x - 1, y),
		Vector2i(x, y + 1), Vector2i(x, y - 1),
	]
	for n in neighbors:
		if n.x < 0 or n.x >= grid_width or n.y < 0 or n.y >= grid_height:
			continue
		if _collapsed[n.y][n.x]:
			continue
		var opts: Array = _possibilities[n.y][n.x]
		opts.erase(chosen)
		if opts.is_empty():
			opts.append(chosen)

func get_collapsed_grid() -> Array:
	var grid: Array = []
	for y in grid_height:
		var row: Array = []
		for x in grid_width:
			if _collapsed[y][x] and not _possibilities[y][x].is_empty():
				row.append(_possibilities[y][x][0])
			else:
				row.append(null)
		grid.append(row)
	return grid
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/2d/using_tilemaps.html
# - https://docs.godotengine.org/en/stable/classes/class_tilemappattern.html
# - https://docs.godotengine.org/en/stable/tutorials/math/random_number_generation.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — adjacency rule Resources per tile
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tilemap-mastery/SKILL.md — commit collapsed cells via set_pattern
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-procedural-generation/SKILL.md
# =============================================================================
