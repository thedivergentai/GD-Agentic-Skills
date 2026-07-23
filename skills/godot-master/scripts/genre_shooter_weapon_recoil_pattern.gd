class_name WeaponRecoilPattern
extends Resource
## Inspector-editable spray curve for learnable recoil (CS-style).

@export var spray_points: Array[Vector2] = []
@export var horizontal_variance: float = 0.1
@export var vertical_variance: float = 0.1

func get_recoil_at(shot_index: int) -> Vector2:
	if spray_points.is_empty():
		return Vector2.ZERO
	var base := spray_points[shot_index % spray_points.size()]
	return base + Vector2(
		randf_range(-horizontal_variance, horizontal_variance),
		randf_range(-vertical_variance, vertical_variance)
	)

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_resource.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — WeaponData resources
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter-fps/SKILL.md — FPS recoil polish
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter/SKILL.md
# =============================================================================
