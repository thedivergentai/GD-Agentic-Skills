class_name SportsCharacter extends CharacterBody3D

@onready var anim_tree: AnimationTree = $AnimationTree

func _physics_process(_delta: float) -> void:
    # Extract root motion from the current animation state
    var root_motion := anim_tree.get_root_motion_position()
    # Apply to velocity for physics-synced movement
    velocity = (global_transform.basis * root_motion) / _delta
    move_and_slide()
