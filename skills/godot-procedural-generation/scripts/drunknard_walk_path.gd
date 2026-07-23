# drunknard_walk_path.gd
# Simple path generation for dungeons or rivers
extends Node

var rng := RandomNumberGenerator.new()

func generate_path(start: Vector2i, steps: int, seed: int = 0) -> Array[Vector2i]:
	rng.seed = seed
	var current := start
	var path: Array[Vector2i] = [start]
	var directions := [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]

	for i in range(steps):
		var dir := directions[rng.randi() % directions.size()]
		current += dir
		if not path.has(current):
			path.append(current)

	return path
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/math/random_number_generation.html
# - https://docs.godotengine.org/en/stable/classes/class_randomnumbergenerator.html
# - https://docs.godotengine.org/en/stable/tutorials/2d/using_tilemaps.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tilemap-mastery/SKILL.md — carve walk cells into floors/rivers
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-roguelike/SKILL.md — lightweight tunnel layouts for early floors
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-procedural-generation/SKILL.md
# =============================================================================
