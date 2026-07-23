class_name OrganicEnemyMovement extends PathFollow2D

@export var move_speed: float = 150.0

func _physics_process(delta: float) -> void:
    # Use 'progress' (Godot 4) to advance along the Curve2D
    progress += move_speed * delta
    
    if progress_ratio >= 1.0:
        # Reached the core
        queue_free()
