---
name: godot-adapt-2d-to-3d
description: "Expert patterns for migrating 2D games to 3D including node type conversions, camera systems (third-person, first-person, orbit), physics layer migration, sprite-to-model art pipeline, and control scheme adaptations. Use when porting 2D projects to 3D or adding 3D elements. Trigger keywords: CharacterBody2D to CharacterBody3D, Area2D to Area3D, Camera2D to Camera3D, Vector2 to Vector3, collision_layer migration, sprite to MeshInstance3D, 2D to 3D conversion."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Adapt: 2D to 3D

Expert guidance for migrating 2D games into the third dimension.

## NEVER Do

- **NEVER directly replace Vector2 with Vector3(x, y, 0)** — This creates a "flat 3D" game with no depth gameplay. Add Z-axis movement or camera rotation to justify 3D.
- **NEVER keep 2D collision layers** — 2D and 3D physics use separate layer systems. You must reconfigure collision_layer/collision_mask for 3D nodes.
- **NEVER forget to add lighting** — 3D without lights is pitch black (unless using unlit materials). Add at least one DirectionalLight3D.
- **NEVER use Camera2D follow logic in 3D** — Camera3D needs spring arm or look-at logic. Direct position copying causes clipping and disorientation.
- **NEVER assume same performance** — 3D is 5-10x more demanding. Budget for lower draw calls, smaller viewport resolution on mobile.
- **NEVER use the rotation property for complex 3D logic** — 3D rotation uses Euler angles. Interpolating Euler angles causes unpredictable paths and Gimbal Lock. Always use `Quaternion` for 3D rotation interpolation or the `Basis` matrix for directional vectors.
- **NEVER ignore metric scaling** — 3D physics and lighting assume 1 unit = 1 meter. Scaling models inside the engine introduces precision errors. Export assets from DCCs at the correct metric scale.
- **NEVER disable physics interpolation when using custom camera follow scripts** — Updating camera position in `_process` to follow a body moving in `_physics_process` causes jitter. Use `Node3D.get_global_transform_interpolated()` for smooth transforms.

---

## Available Scripts

> **MANDATORY**: Load migration scripts before pasting camera/movement recipes.

### [spring_arm_camera_setup.gd](../scripts/adapt_2d_to_3d_spring_arm_camera_setup.gd)
**MANDATORY** third-person SpringArm3D + Camera3D. Do not parent Camera3D bare to the body.

### [characterbody3d_migration_movement.gd](../scripts/adapt_2d_to_3d_characterbody3d_migration_movement.gd)
**MANDATORY** camera-relative CharacterBody3D movement for 2D→3D ports.

### [physics_layer_migration_checklist.gd](../scripts/adapt_2d_to_3d_physics_layer_migration_checklist.gd)
**MANDATORY** checklist: 3D Physics layer names are separate from 2D — mirror names, then apply bits.

### [sprite_plane.gd](../scripts/adapt_2d_to_3d_sprite_plane.gd)
Sprite3D billboard configuration and world-to-screen projection for placing 2D UI over 3D objects.

### [vector_mapping.gd](../scripts/adapt_2d_to_3d_vector_mapping.gd)
Vector2↔Vector3 mapping helpers (Y-up vs Z-forward pitfalls).

### [crisp_projected_ui.gd](../scripts/adapt_2d_to_3d_crisp_projected_ui.gd)
Diegetic / projected UI sharpness patterns.

### [adapt_2d_to_3d_patterns.gd](../scripts/adapt_2d_to_3d_adapt_2d_to_3d_patterns.gd)
Billboards, mouse→3D rays, CanvasLayer overlay helpers.

> **Do NOT Load** lighting deep-dives here — route to [godot-3d-lighting](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-lighting/SKILL.md). Add a DirectionalLight3D + ambient only; GI/cascades live there.

---

## Node Conversion Matrix

| 2D Node | 3D Equivalent | Notes |
|---------|---------------|-------|
| CharacterBody2D | CharacterBody3D | **MANDATORY** `characterbody3d_migration_movement.gd` |
| RigidBody2D | RigidBody3D | Gravity `Vector3(0, -9.8, 0)` |
| StaticBody2D | StaticBody3D | Shape3D resources (no auto-convert) |
| Area2D | Area3D | Same trigger idea; new layers |
| Sprite2D | MeshInstance3D / Sprite3D | Billboard vs mesh art choice |
| Camera2D | Camera3D | **MANDATORY** `spring_arm_camera_setup.gd` |
| CollisionShape2D | CollisionShape3D | Re-author shapes |
| RayCast2D | RayCast3D | `target_position` is Vector3 |

---

## Migration Steps (script-first)

1. **Physics layers** — **MANDATORY** [`physics_layer_migration_checklist.gd`](../scripts/adapt_2d_to_3d_physics_layer_migration_checklist.gd). Project Settings → Layer Names → **3D Physics**.
2. **Camera** — **MANDATORY** [`spring_arm_camera_setup.gd`](../scripts/adapt_2d_to_3d_spring_arm_camera_setup.gd). Never copy Camera2D follow onto Camera3D.
3. **Movement** — **MANDATORY** [`characterbody3d_migration_movement.gd`](../scripts/adapt_2d_to_3d_characterbody3d_migration_movement.gd). Camera-relative XZ; jump on Y.

---

## Art Pipeline: Sprites → 3D Models

### Option 1: Billboard Sprites (2.5D)

```gdscript
# Use Sprite3D for quick conversion
extends Sprite3D

func _ready() -> void:
    texture = load("res://sprites/character.png")
    billboard = BaseMaterial3D.BILLBOARD_ENABLED  # Always face camera
    pixel_size = 0.01  # Scale sprite in 3D space
```

### Option 2: Quad Meshes (Floating Sprites)

```gdscript
# Create textured quads
var mesh_instance := MeshInstance3D.new()
var quad := QuadMesh.new()
quad.size = Vector2(1, 1)
mesh_instance.mesh = quad

var material := StandardMaterial3D.new()
material.albedo_texture = load("res://sprites/character.png")
material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
material.cull_mode = BaseMaterial3D.CULL_DISABLED  # Show both sides
mesh_instance.material_override = material
```

### Option 3: Full 3D Models (Blender/Asset Library)

```gdscript
# Import .glb, .fbx models
var character := load("res://models/character.glb").instantiate()
add_child(character)

# Access animations
var anim_player := character.get_node("AnimationPlayer")
anim_player.play("idle")
```

---

## Lighting Considerations

Minimum: one `DirectionalLight3D` + `WorldEnvironment` ambient so the scene is not black. **Do NOT Load** cascade/GI/bake tutorials in this skill — [godot-3d-lighting](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-lighting/SKILL.md).

---

## UI Adaptation

```gdscript
# ✅ GOOD: Keep 2D UI overlay
# Scene structure:
# Main (Node3D)
#   ├─ WorldEnvironment
#   ├─ DirectionalLight3D
#   ├─ Player (CharacterBody3D)
#   └─ CanvasLayer  # 2D UI on top of 3D world
#       └─ Control (HUD)

# UI remains 2D (Control nodes, Sprite2D for HUD elements)
```

---

## Performance Budgeting (profiler gates)

Speculative "2D vs 3D budget" tables lie. Gate on measured data:

1. **Open Profiler / Debugger → Monitors** after the port runs on target hardware.
2. **Draw calls / primitives** — if MeshInstance count explodes, add Mesh LOD / Visibility Ranges before guessing vertex caps.
3. **Shadow cost** — lower `directional_shadow_max_distance` and shadowed Omni/Spot count until frame time recovers (tune in godot-3d-lighting).
4. **LOD procedure** — set `visibility_range_*` on distant GeometryInstance3D; unlit/simplified materials past the near band.
5. **Fail gate** — ship only when 95th-percentile frame time meets the platform target (e.g. ≤16.6 ms for 60 FPS), not when a spreadsheet says "50–100 draw calls".

---

## Input Scheme Changes

### 2D → 3D Input Mapping

```gdscript
# 2D: left/right for horizontal movement
Input.get_axis("left", "right")

# 3D: Add forward/back, use get_vector()
var input := Input.get_vector("left", "right", "forward", "back")
# Returns Vector2(horizontal, vertical) for 3D movement

# Configure in Project Settings → Input Map:
# forward: W, Up Arrow
# back: S, Down Arrow
# left: A, Left Arrow
# right: D, Right Arrow

# Mouse look (lock cursor)
func _ready() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
    if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
        rotate_camera(event.relative)
```

---

## Edge Cases

### Physics Not Working

```gdscript
# Problem: Forgot to set collision layers for 3D
# Solution: Reconfigure layers

var body := CharacterBody3D.new()
body.collision_layer = 0b0001  # What AM I?
body.collision_mask = 0b0110   # What do I DETECT?
```

### Camera Clipping Through Walls

Use **MANDATORY** [`spring_arm_camera_setup.gd`](../scripts/adapt_2d_to_3d_spring_arm_camera_setup.gd) — set `spring_arm.collision_mask` to the World layer so the boom retracts instead of clipping.

### Player Falling Through Floor

```gdscript
# Problem: StaticBody3D floor has no CollisionShape3D
# Solution: Add collision

var floor_collision := CollisionShape3D.new()
var box_shape := BoxShape3D.new()
box_shape.size = Vector3(100, 1, 100)
floor_collision.shape = box_shape
floor.add_child(floor_collision)
```

---

## Decision Tree: When to Go 3D

| Factor | Stay 2D | Go 3D |
|--------|---------|-------|
| **Gameplay** | Platformer, top-down, no depth needed | Exploration, first-person, 3D space combat |
| **Art budget** | Pixel art, limited resources | 3D models available or necessary |
| **Performance target** | Mobile, web, low-end | Desktop, console, high-end mobile |
| **Development time** | Limited | Have time for 3D learning curve |
| **Team skills** | 2D artists only | 3D artists or asset library |



---

## Expert Techniques & Optimizations

### 1. Vector Math over Euler Angles
When moving a 3D character, rely heavily on `Transform3D` basis vectors rather than calculating trigonometric angles. To move forward locally, extract the negative Z-axis of your transform's basis: `velocity = transform.basis.z * speed`.

### 2. Understanding Coordinate Discrepancies
In 2D, the Y-axis points down. In 3D, Godot uses a right-handed system where Y-axis points UP, and forward is -Z. Translating 2D jumps to 3D requires inverting the Y velocity logic (e.g., `velocity.y = JUMP_SPEED` instead of `-JUMP_SPEED`).

### 3. 2.5D Navigation (Camera-Projected Paths)
For 2.5D games where actors move on a 3D floor but are displayed as 2D sprites, query the `NavigationServer3D` directly and project the resulting `PackedVector3Array` into 2D screen space (or a flattened gameplay plane) using `Camera3D.unproject_position`.

```gdscript
class_name NavigationBridge2D5D extends Node

## Projects 3D NavigationServer paths to 2D screenspace for 2.5D movement.
static func query_2_5d_path(camera: Camera3D, map_rid: RID, start_2d: Vector2, target_2d: Vector2) -> PackedVector2Array:
    # 1. Project 2D screen points to the 3D ground plane (Y=0).
    var start_3d := camera.project_position(start_2d, 0.0)
    var target_3d := camera.project_position(target_2d, 0.0)
    
    # 2. Query optimized 3D path.
    var path_3d := NavigationServer3D.map_get_path(map_rid, start_3d, target_3d, true)
    
    # 3. Project 3D world points back to 2D screenspace coordinates for the sprite.
    var path_2d := PackedVector2Array()
    for point in path_3d:
        path_2d.append(camera.unproject_position(point))
        
    return path_2d
```

### 4. Shader-Based Billboarding (Massive Crowd Rendering)
To render millions of instances, use `MultiMeshInstance3D` paired with a custom Visual Shader. Use `VisualShaderNodeBillboard` with `BILLBOARD_TYPE_FIXED_Y` to ensure sprites stay upright on flat terrain.

```gdscript
class_name MassiveCrowdManager extends MultiMeshInstance3D
## Efficiently manages millions of camera-facing instances via GPU hardware.

func _ready() -> void:
    # 1. Configure the MultiMesh for 3D transforms.
    multimesh = MultiMesh.new()
    multimesh.transform_format = MultiMesh.TRANSFORM_3D
    multimesh.instance_count = 10000
    
    # 2. Build a ShaderMaterial using VisualShaderNodeBillboard.
    var material := ShaderMaterial.new()
    # Note: Logic assumes billboard_type=BILLBOARD_TYPE_FIXED_Y and keep_scale=true.
    multimesh.mesh = QuadMesh.new()
    multimesh.mesh.surface_set_material(0, material)
    
    # 3. Populate transforms. The GPU handles orientation.
    for i in range(multimesh.instance_count):
        var pos := Vector3(randf() * 100, 0, randf() * 100)
        multimesh.set_instance_transform(i, Transform3D(Basis(), pos))
```

### 5. Lighting Migration

PointLight2D→OmniLight3D conversion is one-shot editor work — keep a project tool if needed. Ongoing lighting quality belongs in godot-3d-lighting.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Introduction to 3D](https://docs.godotengine.org/en/stable/tutorials/3d/introduction_to_3d.html) — Coordinate system, Node3D, and camera basics you must adopt when leaving the CanvasItem/Y-down 2D world.
- [Using transforms](https://docs.godotengine.org/en/stable/tutorials/3d/using_transforms.html) — `Basis`/`Transform3D`/`Quaternion` patterns that replace Euler-angle Camera2D follow and 2D rotation habits.
- [CharacterBody3D](https://docs.godotengine.org/en/stable/classes/class_characterbody3d.html) — Destination `move_and_slide` API after CharacterBody2D → CharacterBody3D conversion (no dedicated 3D tutorial page).
- [Physics introduction](https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html) — Separate 2D/3D layer systems, units (1 unit ≈ 1 m), and gravity vectors that invalidate copied 2D masks.
- [Collision shapes (3D)](https://docs.godotengine.org/en/stable/tutorials/physics/collision_shapes_3d.html) — Shape3D equivalents for BoxShape2D/CapsuleShape2D when rebuilding CollisionShape3D stacks.
- [SpringArm3D](https://docs.godotengine.org/en/stable/tutorials/3d/spring_arm.html) — Third-person boom + occlusion pull-in that must replace direct Camera2D position copying.
- [3D lights and shadows](https://docs.godotengine.org/en/stable/tutorials/3d/lights_and_shadows.html) — Minimum DirectionalLight3D/OmniLight3D setup; 3D scenes are black without lights or unlit materials.
- [Environment and post-processing](https://docs.godotengine.org/en/stable/tutorials/3d/environment_and_post_processing.html) — WorldEnvironment ambient fill so ports are not pitch-black between key lights.
- [Standard Material 3D](https://docs.godotengine.org/en/stable/tutorials/3d/standard_material_3d.html) — Billboard, transparency, and shading modes for Sprite3D/QuadMesh sprite→plane art paths.
- [Using GridMaps](https://docs.godotengine.org/en/stable/tutorials/3d/using_gridmaps.html) — MeshLibrary/GridMap replacement for TileMapLayer-style level layouts in 3D.
- [Importing 3D scenes](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/index.html) — GLB/FBX scale and animation import when leaving the sprite pipeline for real meshes.
- [Physics interpolation introduction](https://docs.godotengine.org/en/stable/tutorials/physics/interpolation/physics_interpolation_introduction.html) — Why camera follow in `_process` needs interpolated transforms after physics-step movement.

### Related Skills

#### Prerequisites
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — Typed Vector2/Vector3 and Transform3D fluency before applying Y→Z mapping helpers.
- [godot-characterbody-2d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md) — Source platformer/top-down movement semantics you are lifting into CharacterBody3D.
- [godot-2d-physics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md) — Existing 2D layer/mask design that must be recreated under the separate 3D physics layer table.
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — `Input.get_vector` plus mouse-capture look so 2D left/right maps become camera-relative XZ.

#### Complements
- [godot-camera-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md) — SpringArm3D / orbit / first-person rigs that replace Camera2D follow after the port.
- [godot-3d-lighting](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-lighting/SKILL.md) — DirectionalLight3D, shadows, and ambient environments required once sprites become lit meshes.
- [godot-3d-materials](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-materials/SKILL.md) — PBR/billboard/alpha materials for QuadMesh and Sprite3D art migration.
- [godot-3d-world-building](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md) — GridMap, collision generation, and LOD after TileMapLayer worlds move to 3D.
- [godot-raycasting-queries](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md) — Mouse→world `PhysicsRayQueryParameters3D` picks used by point-and-click 3D ports.
- [godot-ui-containers](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md) — CanvasLayer HUD that stays 2D while world content becomes Node3D.
- [godot-navigation-pathfinding](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md) — NavigationServer3D paths for 2.5D bridges that still project to screen or gameplay planes.
- [godot-adapt-3d-to-2d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-3d-to-2d/SKILL.md) — Inverse adaptation lattice when deciding to flatten back or keep hybrid 2.5D.

#### Downstream / consumers
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — Escalate when the 3D port blows the old 2D draw-call/vertex budget.
- [godot-platform-mobile](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-mobile/SKILL.md) — Shipping target that forces LOD, shadow distance, and resolution tradeoffs after going 3D.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry; open when discovering which Domain Skill owns a cross-cutting 2D/3D concern.
