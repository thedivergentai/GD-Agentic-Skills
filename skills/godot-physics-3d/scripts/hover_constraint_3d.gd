class_name HoverConstraint3D extends RigidBody3D
## Custom physics constraint using low-level raycasting.

@export var hover_height: float = 2.0
@export var hover_force: float = 80.0

func _physics_process(_delta: float) -> void:
    # Safely retrieve the physics space state during the physics tick.
    var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
    
    # Define the ray vector using global coordinates.
    var from_pos: Vector3 = global_position
    var to_pos: Vector3 = global_position + (Vector3.DOWN * 10.0)
    
    # Create the query parameter using the static factory method.
    var query := PhysicsRayQueryParameters3D.create(from_pos, to_pos)
    
    # Exclude this rigid body by its server RID for optimal performance.
    query.exclude = [get_rid()]
    
    # Execute the raycast query.
    var result: Dictionary = space_state.intersect_ray(query)
    
    # Resolve the custom constraint.
    if result and not result.is_empty():
        var hit_position: Vector3 = result.position
        var distance: float = global_position.distance_to(hit_position)
        
        if distance < hover_height:
            # Apply a restorative central force to simulate a spring constraint.
            var force_magnitude: float = hover_force * (hover_height - distance)
            apply_central_force(Vector3.UP * force_magnitude)
