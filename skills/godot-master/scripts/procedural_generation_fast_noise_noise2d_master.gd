# fast_noise_noise2d_master.gd
# Advanced usage of FastNoiseLite for terrain and heightmaps
extends Node

# EXPERT NOTE: Noise generation is expensive. Generate noise maps
# into a typed Array or Image rather than querying 'get_noise_2d' per tile.

var noise := FastNoiseLite.new()
var rng := RandomNumberGenerator.new()

func configure(seed: int, frequency: float = 0.01) -> void:
	rng.seed = seed
	noise.seed = seed
	noise.frequency = frequency
	noise.noise_type = FastNoiseLite.TYPE_PERLIN

func generate_heightmap(width: int, height: int) -> Image:
	return noise.get_image(width, height)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_fastnoiselite.html
# - https://docs.godotengine.org/en/stable/classes/class_noise.html
# - https://docs.godotengine.org/en/stable/classes/class_image.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tilemap-mastery/SKILL.md — sample height/biome Image into TileMapLayer cells
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md — drive GridMap / terrain meshes from noise maps
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-procedural-generation/SKILL.md
# =============================================================================
