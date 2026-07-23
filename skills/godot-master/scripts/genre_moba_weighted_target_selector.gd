extends Area3D

## Expert MOBA Targeting (Godot 4.7).
## Group-weighted priority selection.

func get_best_target() -> Node3D:
	var targets = get_overlapping_bodies()
	if targets.is_empty(): return null
	
	targets.sort_custom(func(a, b):
		var r_a = _get_rank(a)
		var r_b = _get_rank(b)
		if r_a != r_b: return r_a < r_b
		# Tie-breaker: Closest squared distance
		return global_position.distance_squared_to(a.global_position) < \
			   global_position.distance_squared_to(b.global_position)
	)
	return targets[0]

func _get_rank(body: Node) -> int:
	if body.is_in_group("hero"): return 1
	if body.is_in_group("minion"): return 2
	if body.is_in_group("tower"): return 3
	return 99

## [SKILL NOTICE]: Use 'distance_squared_to' for sorting. 
## It avoids expensive square root math, crucial for MOBA loops.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — aggro/target ranking
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — priority weight tuning
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-moba/SKILL.md
# =============================================================================
