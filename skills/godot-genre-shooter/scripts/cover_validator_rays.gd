extends Node3D
class_name CoverValidatorRays

## Expert Cover Detection (Godot 4.7).
## Uses a cluster of RayCasts to detect cover height and peeking.

@onready var ray_low: RayCast3D = $RayLow
@onready var ray_high: RayCast3D = $RayHigh
@onready var ray_left: RayCast3D = $RayLeft
@onready var ray_right: RayCast3D = $RayRight

enum CoverState { NONE, HALF, FULL }

func get_cover_state() -> CoverState:
	if not ray_low.is_colliding(): return CoverState.NONE
	if ray_high.is_colliding(): return CoverState.FULL
	return CoverState.HALF

func can_peek_side() -> int:
	# Returns -1 (Left), 1 (Right), or 0 (None)
	if not ray_left.is_colliding(): return -1
	if not ray_right.is_colliding(): return 1
	return 0

## [SKILL NOTICE]: Cluster multiple RayCast3D nodes to detect 
## environmental context (like cover height) in a single physics frame.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_raycast3d.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md — multi-ray cover height / peek clusters
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-stealth/SKILL.md — cover state used beside detection loops
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter/SKILL.md
# =============================================================================
