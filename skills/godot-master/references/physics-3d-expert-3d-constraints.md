# Expert 3D physics constraints

> Hover springs, Jolt vehicle suspension, ragdoll blend-back. Scripts: `hover_constraint_3d.gd`, `vehicle_simulation_tuning.gd`, `ragdoll_blender.gd`.

## Core Architecture

### 1. Layers & Masks (3D)
Same as 2D:
- **Layer**: What object IS.
- **Mask**: What object HITS.

### 2. Physical Bones (Ragdolls)
Godot uses `PhysicalBone3D` nodes attached to `Skeleton3D` bones.
To setup:
1. Select Skeleton3D.
2. Click "Create Physical Skeleton" in top menu.
3. This generates `PhysicalBone3D` nodes.

### 3. Jolt Joints
Use `Generic6DOFJoint3D` for almost everything. It covers hinge, slider, and ball-socket needs with simpler configuration than specific nodes.

---

## Ragdoll Implementation

```gdscript

### 4. Custom Physics Constraint Solver (intersect_ray)
For building custom constraints like hover mechanics or custom suspensions, query the physics space directly using `PhysicsDirectSpaceState3D`. Access the space state only during the `_physics_process()` callback to avoid lock errors.

```gdscript
class_name HoverConstraint3D extends RigidBody3D

### 5. Jolt Settings (Vehicle Suspensions)
Jolt Physics is the recommended engine for high-stability 3D physics in Godot 4.x. For vehicle suspensions, tune `suspension_stiffness` and `suspension_travel` to balance stability and realism.

```gdscript
class_name VehicleSuspensionTuner extends VehicleBody3D

### 6. Ragdoll Blending (Revival Interpolation)
Transitioning from a ragdoll back to an animated state involves manipulating the `influence` property of the `PhysicalBoneSimulator3D`. Use a `Tween` to smoothly interpolate influence from 1.0 (physics) to 0.0 (animation).

```gdscript
class_name RagdollBlender extends Node3D
