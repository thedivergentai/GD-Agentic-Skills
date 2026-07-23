class_name BodyPartHitbox extends Area3D

enum Part { HEAD, TORSO, LEGS }
@export var part_type: Part

func _on_ball_entered(ball: RigidBody3D) -> void:
    match part_type:
        Part.HEAD:
            apply_header_force(ball)
        Part.TORSO:
            apply_chest_trap(ball)
        Part.LEGS:
            apply_kick_force(ball)
