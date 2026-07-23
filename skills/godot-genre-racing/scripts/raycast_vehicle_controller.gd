extends RigidBody3D
class_name RaycastVehicleController

## Expert Raycast Vehicle (Godot 4.7).
## Manual suspension and friction for crisp arcade feel.

@export var spring_stiffness: float = 30.0
@export var spring_damping: float = 2.0
@export var spring_rest_length: float = 0.5
@export var tire_grip: float = 2.0

@onready var wheels: Array[RayCast3D] = [$W1, $W2, $W3, $W4]

func _physics_process(delta: float) -> void:
	for wheel in wheels:
		if wheel.is_colliding():
			var depth = spring_rest_length - wheel.get_collision_point().distance_to(wheel.global_position)
			var spring_force = (depth * spring_stiffness)
			
			# Apply upward force at wheel position
			apply_force(Vector3.UP * spring_force, wheel.position)
			
			# Lateral Friction (Grip)
			var lateral_vel = global_transform.basis.x.dot(get_velocity_at_local_point(wheel.position))
			apply_force(-global_transform.basis.x * lateral_vel * tire_grip, wheel.position)

## [SKILL NOTICE]: Avoid 'VehicleBody3D' for arcade feel. Manually 
## calculate suspension via RayCast3D and apply forces to a RigidBody3D.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/rigid_body.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md — RigidBody3D custom suspension forces
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md — wheel ray recipes
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-racing/SKILL.md
# =============================================================================
