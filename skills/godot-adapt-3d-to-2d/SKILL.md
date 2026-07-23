---
name: godot-adapt-3d-to-2d
description: "Expert patterns for simplifying 3D games to 2D including dimension reduction strategies, 2.5D fake-depth, isometric ports, camera flattening, physics conversion, 3D-to-sprite art pipeline, and control simplification. Use when porting 3D to 2D, building 2.5D / isometric / fake-depth gameplay, creating 2D versions for mobile, or prototyping. Trigger keywords: CharacterBody3D to CharacterBody2D, Camera3D to Camera2D, Vector3 to Vector2, flatten Z-axis, 2.5D, isometric, fake depth, Y-sort, simulated Z, orthogonal projection, 3D to sprite conversion, performance optimization."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Adapt: 3D to 2D

Expert guidance for simplifying 3D games into 2D (or 2.5D).

## NEVER Do

- **NEVER remove Z-axis without gameplay compensation** — Blindly flattening 3D to 2D removes spatial strategy. Add other depth mechanics (layers, jump height variations).
- **NEVER keep 3D collision shapes** — Use simpler 2D shapes (CapsuleShape2D, RectangleShape2D). 3D shapes don't convert automatically.
- **NEVER use orthographic Camera3D as "2D mode"** — WHY: You still pay 3D transform/lighting costs and miss CanvasItem batching. Use Camera2D + 2D nodes ([`ortho_simulation.gd`](scripts/ortho_simulation.gd) only for simulated height).
- **NEVER assume automatic performance gain** — Poorly optimized 2D (too many draw calls, large sprite sheets) can be slower than optimized 3D.
- **NEVER forget to adjust gravity** — 3D gravity is Vector3(0, -9.8, 0). 2D gravity is float (980 pixels/s²). Scale appropriately.
- **NEVER treat ground and air hits as the same Area2D overlap** — In 2.5D, a ground slash must not hit jumping targets. WHY: 2D physics has no Z. Use [`hitbox_depth_manager.gd`](scripts/hitbox_depth_manager.gd) height AABB checks.
- **NEVER fight Y-sort with per-sprite `z_index` spam** — WHY: Ownership of sort order belongs on the Y-sorted parent. Use [`depth_sorting_y_sort.gd`](scripts/depth_sorting_y_sort.gd); manual z_index drifts every frame.

---

## Available Scripts

> **MANDATORY**: Read the appropriate script before implementing the corresponding pattern.

### Strategy router (MANDATORY / Do NOT Load)
| Strategy | Load | Do NOT Load |
|----------|------|-------------|
| True 2D (drop Z) | `jump_z_axis_sim.gd` only if platformer height remains; else CharacterBody2D patterns | `ortho_simulation.gd`, iso math, fake shadows |
| 2.5D / fake depth | **MANDATORY** `ortho_simulation.gd` + `jump_z_axis_sim.gd` + `hitbox_depth_manager.gd` + `depth_sorting_y_sort.gd` (+ `parallax_depth_camera.gd` / `fake_3d_shadows.gd`) | Manual `z_index = int(y)` spam; ortho Camera3D as 2D |
| Isometric stay | **MANDATORY** `isometric_math_core.gd` + `depth_sorting_y_sort.gd` | Cartesian-only velocity samples; Camera3D ortho fake |
| Bake 3D→sprites | **MANDATORY** `model_to_sprite_bake.gd` (+ `billboard_sprite_manager.gd` for Doom-style) | Blender bake recipes in body |
| Node/physics convert only | Decision tree + gravity/collision notes below | Strategy code samples; Dimensional Patcher regex without review |

### [ortho_simulation.gd](scripts/ortho_simulation.gd)
Simulates 3D Z-axis height in 2D top-down games. Handles vertical velocity, gravity, sprite offset, and shadow scaling.

### [projection_utils.gd](scripts/projection_utils.gd)
Projects 3D world positions to 2D screen space for nameplates, healthbars, and targeting. Handles behind-camera detection and distance-based scaling.

### [isometric_math_core.gd](scripts/isometric_math_core.gd)
Expert utility generating translating between 2D Cartesian and True Isometric screenspace projection matrices without using 2D Node transforms.

### [depth_sorting_y_sort.gd](scripts/depth_sorting_y_sort.gd)
Expert dynamic Z-index Y-Sort script for fake 3D sorting isolated trees matching CanvasItem `_update_sorting()`.

### [jump_z_axis_sim.gd](scripts/jump_z_axis_sim.gd)
Complete CharacterBody2D snippet separating structural physical ground movement (X,Y) from a mathematically simulated jumping height (Z) in a topdown game.

### [parallax_depth_camera.gd](scripts/parallax_depth_camera.gd)
Fake Depth Camera applying varying offset algorithms to completely disparate CanvasLayers based on an index to simulate 3D camera translation panning.

### [hitbox_depth_manager.gd](scripts/hitbox_depth_manager.gd)
Area2D derived class that requires explicit custom Z-height overlap (1D AABB collision) prior to validating 2D triggers to stop incorrect "ground vs air" collision in 2.5D.

### [fake_3d_shadows.gd](scripts/fake_3d_shadows.gd)
Sprite2D shadow simulator exploiting Godot 4.x `Transform2D` matrix skew shear to project and angle shadows away from a simulated 3D sun direction on a 2D floor.

### [billboard_sprite_manager.gd](scripts/billboard_sprite_manager.gd)
8-directional FPS Doom-style sprite controller isolating the simulated 3D relative angle between a moving 2D CharacterBody and a Camera2D viewpoint.

### [nav_region_flattening.gd](scripts/nav_region_flattening.gd)
Topdown 2D pathfinding workaround allowing "aerial" units to cross walls by leveraging multiple tiered 2D Navigation Layers instead of proper 3D verticality.

### [ortho_to_perspective_fx.gd](scripts/ortho_to_perspective_fx.gd)
Screen space CanvasItem warp Shader simulating a Mode 7 / tabletop perspective pitch. Maps top screen coordinates via division pinching.

### [2d_lighting_normals.gd](scripts/2d_lighting_normals.gd)
Automatic programmatic generation of `CanvasTexture` combining base albedo and baked normal maps at runtime so Sprites correctly react to 2D PointLIGHTs like 3D geometry.

### [model_to_sprite_bake.gd](scripts/model_to_sprite_bake.gd)
**MANDATORY** for automated 3D→sprite angle baking via SubViewport. Keep body as strategy router.


---

## Dimension Reduction Strategies

Pick one row from the strategy router above — do not paste conversion tutorials in-scene.

| Strategy | Intent | Scripts |
|----------|--------|---------|
| True 2D | Drop Z; `Vector2` velocity; Camera2D | Peer `godot-characterbody-2d` / `godot-camera-systems` |
| 2.5D / fake depth | Simulated height + Y-sort ownership + ground-vs-air hitboxes | `ortho_simulation.gd`, `jump_z_axis_sim.gd`, `hitbox_depth_manager.gd`, `depth_sorting_y_sort.gd` |
| Isometric stay | 2D physics + iso projection | **MANDATORY** `isometric_math_core.gd` |

Gravity scale: 3D `9.8` m/s² → 2D `~980` px/s² when 1 m ≈ 100 px. Collisions: CapsuleShape3D → CapsuleShape2D (see Physics Adjustments). Camera: Camera3D/SpringArm → Camera2D — **NEVER** ortho Camera3D as “2D mode”.

---

## Art Pipeline: 3D Models → Sprites

**MANDATORY** when baking multi-angle sprites from GLB/scenes: [`model_to_sprite_bake.gd`](scripts/model_to_sprite_bake.gd) (`@tool` SubViewport baker).
Manual Blender export stays outside this skill. Strategy choice stays in the decision tree below — do not re-inline bake recipes in the body.

---

## Physics Adjustments

### Gravity Scaling

```gdscript
# 3D gravity (m/s²): 9.8
# 2D gravity (pixels/s²): Scale to pixel units

# If 1 meter = 100 pixels:
const GRAVITY_2D = 9.8 * 100  # = 980 pixels/s²

# Adjust jump velocity proportionally:
# 3D jump: 4.5 m/s
# 2D jump: -450 pixels/s
```

### Collision Simplification

```gdscript
# 3D: CapsuleShape3D (16 segments, expensive)
var shape_3d := CapsuleShape3D.new()
shape_3d.radius = 0.5
shape_3d.height = 2.0

# 2D: CapsuleShape2D (much simpler)
var shape_2d := CapsuleShape2D.new()
shape_2d.radius = 16  # pixels
shape_2d.height = 64
```

---

## Control Simplification

### 3D Free Movement → 2D Restricted

```gdscript
# 3D: Full 3D movement with camera-relative controls
var input_3d := Input.get_vector("left", "right", "forward", "back")
var camera_basis := camera.global_transform.basis
var direction := (camera_basis * Vector3(input_3d.x, 0, input_3d.y)).normalized()

# 2D: Simple 4-direction (or 8-direction with diagonals)
var input_2d := Input.get_vector("left", "right", "up", "down")
velocity = input_2d.normalized() * SPEED
```

---

## Performance Gains

### Optimization Techniques

```gdscript
# 1. Use TileMapLayer instead of individual Sprite2D nodes
var tilemap := TileMapLayer.new()
tilemap.tile_set = load("res://tileset.tres")

# 2. Batch sprite rendering
# Use single large sprite sheet instead of individual textures

# 3. Reduce particle count
var godot-particles := GPUParticles2D.new()
godot-particles.amount = 50  # Down from 200 in 3D
```

---

## UI Adaptation

```gdscript
# Most 3D games already use 2D UI (CanvasLayer)
# No changes needed!

# Just verify UI scaling for new aspect ratios
get_viewport().size_changed.connect(_on_viewport_resized)

func _on_viewport_resized() -> void:
    var viewport_size := get_viewport().get_visible_rect().size
    # Adjust UI anchors/margins
```

---

## Edge Cases

### Depth Sorting

**NEVER** drive sort with per-sprite `z_index = int(global_position.y)` — that contradicts Y-sort ownership. **MANDATORY** [`depth_sorting_y_sort.gd`](scripts/depth_sorting_y_sort.gd): enable `y_sort_enabled` on the parent and keep children at default relative z.

### Lost Spatial Audio

```gdscript
# 3D spatial audio (AudioStreamPlayer3D) → 2D panning (AudioStreamPlayer2D)

var audio_2d := AudioStreamPlayer2D.new()
audio_2d.stream = load("res://sounds/footstep.ogg")
audio_2d.max_distance = 1000.0  # 2D range
audio_2d.attenuation = 2.0
add_child(audio_2d)
```

---

## Decision Tree: When to Simplify to 2D

| Factor | Keep 3D | Go 2D |
|--------|---------|-------|
| **Target platform** | Desktop, console | Mobile, web |
| **Art style** | Realistic, immersive | Stylized, retro |
| **Gameplay** | Requires 3D space | Works in 2D plane |
| **Performance** | Have GPU budget | Need 60 FPS on low-end |
| **Team skills** | 3D artists | 2D artists or pixel art |

## Expert Techniques & Optimizations

### 1. Flattened Navigation (3D Navmesh to 2D Grid)
While Godot treats 2D and 3D navigation as separate systems, you can project 3D pathfinding logic onto a 2D grid using `AStarGrid2D`. This is highly optimized for 2D grid-based movement and avoids the overhead of a full 3D navmesh.

```gdscript
class_name GridNavBridge extends Node

var astar_grid: AStarGrid2D

func _ready() -> void:
    astar_grid = AStarGrid2D.new()
    astar_grid.region = Rect2i(0, 0, 100, 100)
    astar_grid.cell_size = Vector2(16, 16)
    astar_grid.update()

## Converts a 3D target position to a 2D grid path.
func get_grid_path_from_3d(start_3d: Vector3, end_3d: Vector3) -> PackedVector2Array:
    var start_map := Vector2i(start_3d.x / 16, start_3d.z / 16)
    var end_map := Vector2i(end_3d.x / 16, end_3d.z / 16)
    
    return astar_grid.get_point_path(start_map, end_map)
```

### 2. Auto-LOD for 2D (Performance Optimization)
Automatic LOD is natively a 3D feature, but you can simulate it in 2D using `VisibleOnScreenEnabler2D`. This node automatically toggles the `process_mode` of target nodes (like high-res sprites or complex AI) when they leave the screen, preserving CPU cycles and GPU fill rate.

```gdscript
# Attach to a complex 2D entity
func setup_2d_lod(target_node: Node2D) -> void:
    var enabler := VisibleOnScreenEnabler2D.new()
    # Define the 'high-detail' rect
    enabler.rect = Rect2(-64, -64, 128, 128) 
    enabler.enable_node_path = target_node.get_path()
    add_child(enabler)
```

### 3. Dimensional Patcher (CharacterBody3D to 2D Regex)
To automate the down-porting of 3D controllers, use a `RegEx` script to map `Vector3` to `Vector2` and replace 3D-specific properties. This is essential for massive porting tasks where manual conversion of movement logic is prone to error.

```gdscript
@tool
extends EditorScript

func _run() -> void:
    var regex = RegEx.new()
    # Pattern to find Vector3 constructors and replace with Vector2
    regex.compile("Vector3\\(([^,]+),\\s*([^,]+),\\s*([^)]+)\\)")
    
    var script_content = "velocity = Vector3(input.x, 0.0, input.y) * speed"
    var result = regex.sub(script_content, "Vector2($1, $3)", true)
    
    # Output: "velocity = Vector2(input.x, input.y) * speed"
    print(result)
```

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Introduction to 2D](https://docs.godotengine.org/en/stable/tutorials/2d/introduction_to_2d.html) — Establishes the CanvasItem/Camera2D pipeline you must switch into when leaving Node3D rendering for real 2D performance.
- [Using CharacterBody2D](https://docs.godotengine.org/en/stable/tutorials/physics/using_character_body_2d.html) — Canonical `move_and_slide` / floor / jump patterns after `CharacterBody3D` → `CharacterBody2D` conversion.
- [Physics introduction](https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html) — Units, layers/masks, and why 3D gravity/`Vector3` assumptions break when gravity becomes a 2D scalar.
- [2D transforms](https://docs.godotengine.org/en/stable/tutorials/2d/2d_transforms.html) — `Transform2D` basis/skew math used for isometric placement and fake projected shadows.
- [2D parallax](https://docs.godotengine.org/en/stable/tutorials/2d/2d_parallax.html) — Layer scroll scales that replace Z-depth when gameplay collapses to a plane.
- [Canvas layers](https://docs.godotengine.org/en/stable/tutorials/2d/canvas_layers.html) — Stacking `CanvasLayer`s for fake-depth cameras without keeping an orthographic `Camera3D`.
- [2D lights and shadows](https://docs.godotengine.org/en/stable/tutorials/2d/2d_lights_and_shadows.html) — Normal-mapped `CanvasTexture` / `Light2D` path that restores 3D-looking lighting on sprites.
- [Navigation introduction (2D)](https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_introduction_2d.html) — 2D nav regions/layers for flattening vertical 3D pathing into tiered 2D agents.
- [Using Viewports](https://docs.godotengine.org/en/stable/tutorials/rendering/viewports.html) — `SubViewport` capture of 3D models into `Sprite2D` textures (runtime or bake pipeline).
- [Camera2D](https://docs.godotengine.org/en/stable/classes/class_camera2d.html) — Zoom, limits, and follow API that should replace “ortho Camera3D as 2D mode.”
- [CanvasItem](https://docs.godotengine.org/en/stable/classes/class_canvasitem.html) — `y_sort_enabled` / `z_index` / `z_as_relative` for depth sorting after losing true Z.
- [General optimization](https://docs.godotengine.org/en/stable/tutorials/performance/general_optimization.html) — Reminds that 2D only wins if draw calls, overdraw, and process cost are actually reduced.

### Related Skills

#### Prerequisites
- [godot-characterbody-2d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md) — Destination movement API for top-down/platformer ports once Z is simulated or removed.
- [godot-2d-physics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md) — `CapsuleShape2D`/`Area2D` collision simplification and layer masks after dropping 3D shapes.
- [godot-camera-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md) — `Camera2D` follow/limits/zoom so ports do not keep a fake ortho `Camera3D`.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — Typed `Vector2`/`Transform2D` math and tooling scripts used throughout dimension-reduction helpers.

#### Complements
- [godot-2d-animation](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-animation/SKILL.md) — Sprite-sheet / `AnimatedSprite2D` pipeline after baking 3D models to directional frames.
- [godot-shaders-basics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md) — CanvasItem shaders for Mode-7 / perspective pitch and other screen-space depth fakes.
- [godot-tilemap-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tilemap-mastery/SKILL.md) — `TileMapLayer` batching that often replaces individual 3D mesh instances in the 2D port.
- [godot-navigation-pathfinding](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md) — Deeper 2D navmesh/`AStarGrid2D` patterns when flattening aerial/vertical routes.
- [godot-audio-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md) — `AudioStreamPlayer3D` → `AudioStreamPlayer2D` panning/attenuation after spatial audio is lost.
- [godot-adapt-2d-to-3d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-2d-to-3d/SKILL.md) — Inverse adaptation lattice when deciding which axis of the port to keep or reverse.

#### Downstream / consumers
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — Escalate when the 2D port still misses frame budgets despite dimensional reduction.
- [godot-platform-mobile](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-mobile/SKILL.md) — Common shipping target that motivates 3D→2D simplification for battery and GPU limits.
- [godot-adapt-desktop-to-mobile](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-desktop-to-mobile/SKILL.md) — Broader desktop→mobile adaptation that often includes this skill’s flatten-to-2D step.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry; open when discovering which Domain Skill owns a cross-cutting 2D/3D concern.
