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
