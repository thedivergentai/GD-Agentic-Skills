# Cutout And Skeletal

## Cutout Animation (Bone2D Skeleton)

For complex skeletal animation, use Bone2D instead of manual Sprite2D parenting:

### Skeleton Setup

```
Player (Node2D)
  └─ Skeleton2D
      ├─ Bone2D (Root - Torso)
      │   ├─ Sprite2D (Body)
      │   └─ Bone2D (Head)
      │       └─ Sprite2D (Head)
      ├─ Bone2D (ArmLeft)
      │   └─ Sprite2D (Arm)
      └─ Bone2D (ArmRight)
          └─ Sprite2D (Arm)
```

### AnimationPlayer Tracks

```gdscript
# Key bone rotations in AnimationPlayer
# Tracks:
# - "Skeleton2D/Bone2D:rotation"
# - "Skeleton2D/Bone2D/Bone2D2:rotation" (head)
# - "Skeleton2D/Bone2D3:rotation" (arm left)
```

**Why Bone2D over manual parenting?**
- Forward Kinematics (FK) and Inverse Kinematics (IK) support
- Easier to rig and weight paint
- Better integration with animation retargeting

---

## Expert Pattern: Skeletal-IK-2D (Procedural Foot Placement)

For procedural limb positioning (e.g., planting feet on slopes), use Godot's built-in 2D skeletal modification system. The `SkeletonModification2DTwoBoneIK` is the elite choice for limbs as it is more lightweight than full FABRIK solvers.

### Setup
1. Add a `SkeletonModificationStack2D` to your `Skeleton2D`.
2. Add a `SkeletonModification2DTwoBoneIK` to the stack.
3. Assign the target bones (e.g., UpperLeg and LowerLeg).
4. Point the `target_nodepath` to a `Marker2D` (IK Target).

```gdscript
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
```

---
