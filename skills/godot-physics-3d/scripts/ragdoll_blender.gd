class_name RagdollBlender extends Node3D
## Handles the transition between skeletal animation and physics ragdolls.

@export var bone_simulator: PhysicalBoneSimulator3D

func kill_character() -> void:
    # Start physics simulation override.
    bone_simulator.physical_bones_start_simulation()
    bone_simulator.influence = 1.0

func revive_character() -> void:
    # 1. Ensure an animation (e.g., "get_up") is playing as the target.
    
    # 2. Smoothly transition control from Physics to Animation.
    var tween: Tween = create_tween()
    tween.tween_property(bone_simulator, "influence", 0.0, 1.5)\
        .set_trans(Tween.TRANS_SINE)\
        .set_ease(Tween.EASE_IN_OUT)
        
    # 3. Stop simulation once the blend finishes to save CPU resources.
    tween.tween_callback(bone_simulator.physical_bones_stop_simulation)
