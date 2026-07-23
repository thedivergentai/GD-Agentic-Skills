extends Node3D
class_name DynamicPlacementValidator

## Expert Grid Placement (Godot 4.7).
## Low-level physics intersection check for obstruction validation.

@export var grid_size: float = 2.0
@export var ghost_shape: Shape3D

func get_grid_pos(raw_pos: Vector3) -> Vector3:
	return raw_pos.snapped(Vector3.ONE * grid_size)

func is_spot_clear(pos: Vector3) -> bool:
	var space = get_world_3d().direct_space_state
	var query = PhysicsShapeQueryParameters3D.new()
	query.shape = ghost_shape
	query.transform = Transform3D(Basis(), pos)
	
	# Expert Pattern: Query physics server directly for instant results
	var results = space.intersect_shape(query, 1)
	return results.is_empty()

## [SKILL NOTICE]: Use 'intersect_shape()' on the physics space state 
## for instant placement validation. Avoid using Area3D signals for this.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html
# - https://docs.godotengine.org/en/stable/classes/class_physicsdirectspacestate3d.html
# - https://docs.godotengine.org/en/stable/classes/class_physicsshapequeryparameters3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md — shape queries for obstruction checks
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md — direct space state picking patterns
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-sandbox/SKILL.md
# =============================================================================
