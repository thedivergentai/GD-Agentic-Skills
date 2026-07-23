# wave_spawner.gd
# [GDSKILLS] godot-game-loop-waves
# EXPORT_REFERENCE: wave_spawner.gd

extends Marker3D

@export var spawn_radius: float = 0.0

func get_spawn_position() -> Vector3:
	if spawn_radius <= 0.0:
		return global_position
	
	var offset = Vector3(
		randf_range(-spawn_radius, spawn_radius),
		0,
		randf_range(-spawn_radius, spawn_radius)
	)
	return global_position + offset
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_marker3d.html
# - https://docs.godotengine.org/en/stable/tutorials/math/random_number_generation.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — editor Markers as spawn portals
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-tower-defense/SKILL.md — lane spawn points
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-game-loop-waves/SKILL.md
# =============================================================================
