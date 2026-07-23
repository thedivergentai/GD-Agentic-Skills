extends Node
class_name RecoilSystem

## Three-layer recoil: visual kick, learnable pattern offset, spread bloom. Recover on _process with lerp.

var visual_recoil: Vector2 = Vector2.ZERO
var pattern_offset: Vector2 = Vector2.ZERO
var spread_bloom: float = 0.0

@export var recoil_pattern: Array[Vector2] = []
var pattern_index: int = 0


func apply_recoil(base_recoil: Vector2, max_spread: float) -> void:
	visual_recoil.y += base_recoil.y * randf_range(0.8, 1.2)
	visual_recoil.x += base_recoil.x * randf_range(-1.0, 1.0)
	if pattern_index < recoil_pattern.size():
		pattern_offset += recoil_pattern[pattern_index]
		pattern_index += 1
	spread_bloom = minf(spread_bloom + 0.5, max_spread)


func recover_recoil(delta: float, recovery_speed: float) -> void:
	visual_recoil = visual_recoil.lerp(Vector2.ZERO, recovery_speed * delta)
	pattern_offset = pattern_offset.lerp(Vector2.ZERO, recovery_speed * delta)
	spread_bloom = lerpf(spread_bloom, 0.0, recovery_speed * delta)
	if visual_recoil.length() < 0.01:
		pattern_index = 0


func get_spread_direction(base_direction: Vector3) -> Vector3:
	var spread_angle := deg_to_rad(spread_bloom)
	var random_offset := Vector2(
		randf_range(-spread_angle, spread_angle),
		randf_range(-spread_angle, spread_angle)
	)
	return base_direction.rotated(Vector3.UP, random_offset.x).rotated(Vector3.RIGHT, random_offset.y)
# ---
# GDSkills research links (agents)
# Related:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter-fps/scripts/procedural_recoil_handler.gd — camera pivot kick
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — spray pattern vs TTK bands
# ---
