class_name ProceduralWalker2D extends Node2D

@onready var skeleton: Skeleton2D = $Skeleton2D
@onready var ik_target_left_foot: Marker2D = $IKTargets/LeftFootTarget
@onready var floor_raycast: RayCast2D = $RayCasts/LeftFootRay

func _ready() -> void:
    # Ensure modification stack is enabled
    var mod_stack: SkeletonModificationStack2D = skeleton.get_modification_stack()
    if mod_stack:
        mod_stack.enabled = true
        mod_stack.enable_all_modifications(true)

func _physics_process(_delta: float) -> void:
    floor_raycast.force_raycast_update()
    
    if floor_raycast.is_colliding():
        # Move IK target to the exact collision point
        ik_target_left_foot.global_position = floor_raycast.get_collision_point()
    else:
        # Fallback to resting position
        ik_target_left_foot.position = Vector2(0, 50)
