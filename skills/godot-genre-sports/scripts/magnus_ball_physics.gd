extends RigidBody3D
class_name MagnusBallPhysics

## Expert Physical Ball (Godot 4.7).
## Implements realistic bounce, friction, and the Magnus Effect (spin-lift).

@export var magnus_coefficient: float = 0.5

func _physics_process(delta: float) -> void:
	# Magnus Effect: Force perpendicular to both velocity and spin
	var spin = angular_velocity
	var velocity = linear_velocity
	
	# Expert Pattern: Cross product determines lift direction
	var magnus_force = spin.cross(velocity) * magnus_coefficient
	
	# Apply central force to simulate aerodynamic lift/curve
	apply_central_force(magnus_force)

## [SKILL NOTICE]: Use 'PhysicsMaterial' on the RigidBody3D for 
## friction and bounce. Use 'Magnus Effect' for realistic curve balls.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_rigidbody3d.html
# - https://docs.godotengine.org/en/stable/classes/class_physicsmaterial.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md — spin/force application on RigidBody3D
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-sports/SKILL.md
# =============================================================================
