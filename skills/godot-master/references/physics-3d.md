---
name: godot-physics-3d
description: "Expert patterns for Godot 3D physics (Jolt/PhysX), including Ragdolls, PhysicalBones, Joint3D constraints, RayCasting optimizations, and collision layers. Use for rigid body simulations, character physics, or complex interactions. Trigger keywords: RigidBody3D, PhysicalBone3D, Jolt, Ragdoll, Skeleton3D, Joint3D, PinJoint3D, HingeJoint3D, Generic6DOFJoint3D, RayCast3D, PhysicsDirectSpaceState3D."
---

# 3D Physics (Jolt/Native)

Expert guidance for high-performance 3D physics and ragdolls.

## NEVER Do

- **NEVER move `PhysicsBody3D` nodes in `_process()`** — Use `_physics_process()`. Moving bodies outside the physics step causes visual jitter and unreliable collision detection [12, 13].
- **NEVER scale collision shapes directly** — Scaling physics shapes causes instability, inaccurate normals, and jitter. Use the `shape` properties (height, radius, size) instead.
- **NEVER modify `RigidBody3D` transforms directly** — This ignores the physics solver. Use `apply_impulse()`, `apply_torque()`, or the `_integrate_forces()` callback for safe manipulation [17].
- **NEVER use `RigidBody3D` for platformer player controllers** — RigidBody is for objects driven by physics. For refined movement, use `CharacterBody3D` with `move_and_slide()` [move_and_slide].
- **NEVER leave Continuous CD (CCD) enabled for static meshes** — It adds heavy CPU cost. Reserve it for high-speed small objects (bullets) to prevent them from passing through walls.
- **NEVER use `PhysicsServer3D` RIDs without manual cleanup** — RIDs are not garbage collected. If you create bodies via the server, you MUST call `free_rid()` when done to avoid memory leaks.
- **NEVER use `RayCast3D` for precise ground detection on stairs** — A single ray is too thin. Use `ShapeCast3D` with a cylinder or sphere shape to detect walkable steps reliably [Stair Logic].
- **NEVER rely on `VehicleBody3D` for non-racing arcade vehicles** — It's a complex sim. For arcade hovercraft or simple cars, a custom `CharacterBody3D` with Raycasts is often easier to tune.
- **NEVER forget to set `collision_layer` and `collision_mask` properly** — If everything is on layer 1, performance will tank from redundant checks. Categorize your world.
- **NEVER use `Area3D` for high-frequency blocking** — Areas are for detection. For walls/barriers, use `StaticBody3D` to ensure immediate, robust containment.

---

## Godot 4.7: Jolt Physics Behavior

- **WorldBoundaryShape3D** (Jolt): `plane.d` sign convention flipped vs 4.6 — flip sign to match prior behavior.
- **SoftBody3D** (Jolt): mass defaults to 1 kg total (not per-point); retune `linear_stiffness` and `damping_coefficient`.
- **Area3D** now reports overlaps with **SoftBody3D** — adjust layers/masks to avoid unwanted overlap signals.

## Available Scripts

### [physics_server_3d_bullets.gd](../scripts/physics_3d_physics_server_3d_bullets.gd)
Direct `PhysicsServer3D` RID management for thousands of high-speed 3D projectiles.

### [ray_query_3d_vision.gd](../scripts/physics_3d_ray_query_3d_vision.gd)
Expert line-of-sight and AI vision logic using low-level space state interrupts.

### [shapecast_3d_ground_check.gd](../scripts/physics_3d_shapecast_3d_ground_check.gd)
Robust stair and ledge detection using `ShapeCast3D` for 3D CharacterBody stability.

### [physics_ccd_3d_projectile.gd](../scripts/physics_3d_physics_ccd_3d_projectile.gd)
Continuous Collision Detection configuration and sub-stepping logic for anti-tunneling.

### [physics_layers_3d_config.gd](../scripts/physics_3d_physics_layers_3d_config.gd)
Clean collision matrix architecture for 3D using named bitmask layers and masks.

### [custom_gravity_well_3d.gd](../scripts/physics_3d_custom_gravity_well_3d.gd)
Planet-style gravity wells and zero-G zones implemented via priority Area3D nodes.

### [soft_body_3d_interaction.gd](../scripts/physics_3d_soft_body_3d_interaction.gd)
Managing high-performance SoftBody3D flags, cloaks, and foliage attachments.

### [joint_3d_breakage_logic.gd](../scripts/physics_3d_joint_3d_breakage_logic.gd)
Dynamic joint stress monitoring and procedural snaps for destructible 3D objects.

### [kinematic_3d_stairs_logic.gd](../scripts/physics_3d_kinematic_3d_stairs_logic.gd)
Advanced procedural stair-stepping and snapping for professional 3D character controllers.

### [vehicle_simulation_tuning.gd](../scripts/physics_3d_vehicle_simulation_tuning.gd)
Tuning `VehicleBody3D` and `VehicleWheel3D` for high-speed drifting and arcade feel.

### [ragdoll_manager.gd](../scripts/physics_3d_ragdoll_manager.gd)
Expert manager for transitioning Skeleton3D from animation to physical simulation (death effect). Handles impulse application and cleanup.

### [raycast_visualizer.gd](../scripts/physics_3d_raycast_visualizer.gd)
Debug tool to visualize hit points and normals of RayCast3D in game.

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
# simple_ragdoll.gd
extends Skeleton3D

func start_ragdoll() -> void:
    physical_bones_start_simulation()
    
func stop_ragdoll() -> void:
    physical_bones_stop_simulation()
```


### 4. Custom Physics Constraint Solver (intersect_ray)
For building custom constraints like hover mechanics or custom suspensions, query the physics space directly using `PhysicsDirectSpaceState3D`. Access the space state only during the `_physics_process()` callback to avoid lock errors.

```gdscript
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
```

### 5. Jolt Settings (Vehicle Suspensions)
Jolt Physics is the recommended engine for high-stability 3D physics in Godot 4.x. For vehicle suspensions, tune `suspension_stiffness` and `suspension_travel` to balance stability and realism.

```gdscript
class_name VehicleSuspensionTuner extends VehicleBody3D
## Dynamically tunes Jolt-powered vehicle suspensions.

@export var wheels: Array[VehicleWheel3D] = []

func _ready() -> void:
    # Ensure the engine is using Jolt for maximum stability.
    var engine_name: String = ProjectSettings.get_setting("physics/3d/physics_engine")
    if engine_name != "Jolt Physics":
        push_warning("Vehicle physics requires Jolt Physics for maximum stability.")
        
    _configure_offroad_suspension()

func _configure_offroad_suspension() -> void:
    for wheel in wheels:
        # Values < 50 for off-road, 50-100 for race cars.
        wheel.suspension_stiffness = 35.0 
        wheel.suspension_travel = 0.25 
        wheel.damping_compression = 0.83 
        wheel.damping_relaxation = 0.88 
        wheel.wheel_friction_slip = 10.5 
```

### 6. Ragdoll Blending (Revival Interpolation)
Transitioning from a ragdoll back to an animated state involves manipulating the `influence` property of the `PhysicalBoneSimulator3D`. Use a `Tween` to smoothly interpolate influence from 1.0 (physics) to 0.0 (animation).

```gdscript
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
```

## Reference
- Master Skill: [godot-master](../SKILL.md)
