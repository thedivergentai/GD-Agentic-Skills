---
name: godot-3d-lighting
description: "Expert patterns for Godot 3D lighting including DirectionalLight3D shadow cascades, OmniLight3D attenuation, SpotLight3D projectors, VoxelGI vs SDFGI, and LightmapGI baking. Use when implementing realistic 3D lighting, shadow optimization, global illumination, or light probes. Trigger keywords: DirectionalLight3D, OmniLight3D, SpotLight3D, shadow_enabled, directional_shadow_mode, directional_shadow_split, omni_range, omni_attenuation, spot_range, spot_angle, VoxelGI, SDFGI, LightmapGI, ReflectionProbe, Environment, WorldEnvironment."
---

# 3D Lighting

Expert guidance for realistic 3D lighting with shadows and global illumination.

## NEVER Do

- **NEVER use VoxelGI without setting a proper extents** — Unbound VoxelGI tanks performance. Always set `size` to tightly fit your scene.
- **NEVER enable shadows on every light** — Each shadow-casting light is expensive. Use shadows sparingly: 1-2 DirectionalLights, ~3-5 OmniLights max.
- **NEVER forget directional_shadow_mode** — Default is ORTHOGONAL. For large outdoor scenes, use PARALLEL_4_SPLITS for better shadow quality at distance.
- **NEVER use LightmapGI for fully dynamic scenes** — Lightmaps are baked. Moving geometry won't receive updated lighting. Use VoxelGI or SDFGI instead.
- **NEVER set omni_range too large** — Light attenuation is quadratic. A range of 500 affects 785,000 sq units. Keep range as small as visually acceptable.
- **NEVER hide a Light node using the Visible property to exclude it from a Lightmap bake** — Hiding a light has no effect on the baker. You must change the light's Bake Mode to Disabled.
- **NEVER use VoxelGI with paper-thin walls** — VoxelGI evaluates lighting using a 3D grid. Thin walls (less than one voxel thick) will cause severe light leaking. Seal your geometry or place hidden thick MeshInstance3D blocks around the exterior.
- **NEVER leave shadow bias at default for cascades** — Default bias often causes Peter Panning or light leaking at split transitions. Tune bias per-light based on your scene's scale.
- **NEVER bake LightmapGI without a Denoiser** — Godot's baked lightmaps are noisy by default. Use OIDN or JNLM (in Project Settings) for professional results.
- **NEVER use real-time SDFGI on Mobile/Compatibility renderers** — It is a Forward+ exclusive feature. Use fake GI bounce lights for lower-end platforms.
- **NEVER use 'Update Continuity' in ReflectionProbes for performance** — Keep ReflectionProbes on 'Update Once' and trigger manual updates only when necessary.
- **NEVER overflow the clustered shadow atlas** — WHY: Forward+ packs Omni/Spot shadows into a shared atlas. Too many shadowed positional lights → atlas thrash, flickering, or silent quality collapse. Cap shadowed Omni (~3–5) and Spot (~2–4); use `light_lod_optimizer.gd` / distance fade before raising atlas size.
- **NEVER stack dozens of overlapping shadowed Omni/Spot in one cluster cell** — WHY: Clustered light iteration cost scales with overlapping lights per tile. Prefer non-shadowed fills, tighter `omni_range`/`spot_range`, and `distance_fade_*` so far lights leave the cluster.

---

## Godot 4.7: AreaLight3D

- **AreaLight3D** provides rectangular area lights with soft shadows — prefer over emissive-material + GI workarounds for screens, glowing panels, and billboards.
- **HDR output** is supported on all major platforms; enable in Project Settings → Rendering → Viewport for true HDR display chain.
- **NEVER** use emissive-only fake panels when AreaLight3D gives correct falloff and shadow softness in Forward+.

## Available Scripts

> **MANDATORY**: Read the appropriate script before implementing the corresponding pattern.

### Golden path (pick one — Do NOT Load peers)
| Scene | Load | Do NOT Load |
|-------|------|-------------|
| **Outdoor** Forward+ | `shadow_cascade_tuner.gd` + `sdfgi_probe_manager.gd` (+ `day_night_cycle.gd` if time-of-day) | `fake_gi_bounce.gd`, indoor VoxelGI bake unless hybrid; `environment_blender.gd` / fog unless atmosphere task |
| **Indoor** sealed geometry | **MANDATORY** VoxelGI via `light_probe_manager.gd` + `lighting_manager.gd` + ReflectionProbes | SDFGI on tiny interiors; Mobile fake GI unless targeting Mobile; sky/fog scripts unless zone blend |
| **Mobile / Compatibility** | **MANDATORY** `fake_gi_bounce.gd` + light budgets in `light_lod_optimizer.gd` | Real-time SDFGI (Forward+ only); HDR sky/volumetric body recipes |
| **Lightmap bake / hybrid static** | **MANDATORY** `lightmap_bake_helper.gd` (+ Shadowmasking for outdoor) | Runtime SDFGI as bake substitute; disabling lights via Visible |
| **Sky / Environment blend only** | `environment_blender.gd` | Cascade/GI managers when only tonemap/ambient/sky changes |
| **Volumetric fog / shafts** | `volumetric_fx.gd` (+ `volumetric_fog_zones.gd` for localized density) | Pure light-budget / shadow-atlas tuning tasks |
| **Pure light budget / shadow LOD** | `light_lod_optimizer.gd`, `shadow_bias_tuner.gd` | **Do NOT Load** `environment_blender.gd`, `volumetric_fx.gd`, day-night unless required |

### [day_night_cycle.gd](../scripts/3d_lighting_day_night_cycle.gd)
Dynamic sun position and color based on time-of-day. Handles DirectionalLight3D rotation, color temperature, and intensity curves. Use for outdoor day/night systems.

### [light_probe_manager.gd](../scripts/3d_lighting_light_probe_manager.gd)
VoxelGI and SDFGI management for global illumination setup.

### [lighting_manager.gd](../scripts/3d_lighting_lighting_manager.gd)
Dynamic light pooling and LOD. Manages light culling and shadow toggling based on camera distance. Use for performance optimization with many lights.

### [volumetric_fx.gd](../scripts/3d_lighting_volumetric_fx.gd)
Volumetric fog and god ray configuration. Runtime fog density/color adjustments and light shaft setup. Use for atmospheric effects.

### [shadow_cascade_tuner.gd](../scripts/3d_lighting_shadow_cascade_tuner.gd)
Expert logic for adjusting DirectionalLight3D shadow split distances dynamically based on sun angle and camera tilt.

### [lightmap_bake_helper.gd](../scripts/3d_lighting_lightmap_bake_helper.gd)
Advanced LightmapGI configuration pattern using Shadowmasking mode for hybrid static/dynamic shadowing.

### [sdfgi_probe_manager.gd](../scripts/3d_lighting_sdfgi_probe_manager.gd)
Dynamic quality scaler for real-time Global Illumination (SDFGI). Adjusts cell size and occlusion for performance/quality trade-offs.

### [volumetric_fog_zones.gd](../scripts/3d_lighting_volumetric_fog_zones.gd)
Smoothly transitioning localized fog density for cave entrances or forest clearings using Tweens and Area3D triggers.

### [fake_gi_bounce.gd](../scripts/3d_lighting_fake_gi_bounce.gd)
Efficient 'Mobile-GI' pattern. Simulates light bouncing off the floor using non-shadowed directional fill lights.

### [environment_blender.gd](../scripts/3d_lighting_environment_blender.gd)
Architectural pattern for transitioning WorldEnvironment parameters (Sky, Ambient, Tonemap) during gameplay.

### [shadow_bias_tuner.gd](../scripts/3d_lighting_shadow_bias_tuner.gd)
Optimization script for correcting 'Peter Panning' and 'Shadow Acne' on high-fidelity directional lights.

### [light_lod_optimizer.gd](../scripts/3d_lighting_light_lod_optimizer.gd)
Distance-based shadow and visibility culling for OmniLight3D nodes in dense environments.

### [reflection_probe_manager.gd](../scripts/3d_lighting_reflection_probe_manager.gd)
Performance-aware ReflectionProbe handling using manual 'Update Once' triggers for large environmental changes.

### [spotlight_projector_setup.gd](../scripts/3d_lighting_spotlight_projector_setup.gd)
High-detail lighting using Projector textures to fake complex shadow patterns (grates, glass ripples).

---

## DirectionalLight3D (Sun/Moon)

### Shadow Cascades

```gdscript
# For outdoor scenes with camera moving from near to far
extends DirectionalLight3D

func _ready() -> void:
    shadow_enabled = true
    directional_shadow_mode = SHADOW_PARALLEL_4_SPLITS
    
    # Split distances (in meters from camera)
    directional_shadow_split_1 = 10.0   # First cascade: 0-10m
    directional_shadow_split_2 = 50.0   # Second: 10-50m
    directional_shadow_split_3 = 200.0  # Third: 50-200m
    # Fourth cascade: 200m - max shadow distance
    
    directional_shadow_max_distance = 500.0
    
    # Quality vs performance
    directional_shadow_blend_splits = true  # Smooth transitions
```

### Day/Night Cycle

**MANDATORY** [`day_night_cycle.gd`](../scripts/3d_lighting_day_night_cycle.gd) — do not re-inline sun energy/color recipes here.


---

## OmniLight3D (Point Light)

Keep `omni_range` tight; prefer quadratic attenuation. Flicker/campfire loops belong in scene scripts — not this body. Shadowed Omni count is a hard budget (see NEVER).

---

## SpotLight3D (Flashlight/Headlights)

**MANDATORY** [`spotlight_projector_setup.gd`](../scripts/3d_lighting_spotlight_projector_setup.gd) for range/angle/projector cookies and camera-follow flashlights. Do not paste Spot setup here.

---

## Global Illumination (script-first)

Use the golden-path table above. Body decision only:

| Path | Script | When |
|------|--------|------|
| Indoor / sealed | **MANDATORY** [`light_probe_manager.gd`](../scripts/3d_lighting_light_probe_manager.gd) (+ [`lighting_manager.gd`](../scripts/3d_lighting_lighting_manager.gd)) | Tight VoxelGI extents per room; never paper-thin walls |
| Outdoor Forward+ | **MANDATORY** [`sdfgi_probe_manager.gd`](../scripts/3d_lighting_sdfgi_probe_manager.gd) | Real-time GI; **Do NOT Load** on Mobile/Compatibility |
| Static / Mobile bake | **MANDATORY** [`lightmap_bake_helper.gd`](../scripts/3d_lighting_lightmap_bake_helper.gd) | LightmapGI + Shadowmasking; bake mode ≠ Visible hide |
| No GI budget | **MANDATORY** [`fake_gi_bounce.gd`](../scripts/3d_lighting_fake_gi_bounce.gd) | Fill lights only |

Do not re-inline VoxelGI/SDFGI/Lightmap property setup here.

---

## Environment & Sky

Sky/ambient/tonemap transitions → **MANDATORY** [`environment_blender.gd`](../scripts/3d_lighting_environment_blender.gd). Volumetric fog / shafts → **MANDATORY** [`volumetric_fx.gd`](../scripts/3d_lighting_volumetric_fx.gd) (+ [`volumetric_fog_zones.gd`](../scripts/3d_lighting_volumetric_fog_zones.gd) for caves/forests).

**Do NOT Load** these for pure light-budget / shadow-atlas / cascade tuning — stay on `light_lod_optimizer.gd` / `shadow_cascade_tuner.gd`.

---

## ReflectionProbe

For localized reflections (mirrors, shiny floors):

```gdscript
# reflection_probe.gd
extends ReflectionProbe

func _ready() -> void:
    # Capture area
    size = Vector3(10, 5, 10)
    
    # Quality
    resolution = ReflectionProbe.RESOLUTION_512
    
    # Update mode
    update_mode = ReflectionProbe.UPDATE_ONCE  # Bake once
    # or UPDATE_ALWAYS for dynamic reflections (expensive)
```

---

## Performance Optimization

### Light Budgets

```gdscript
# Recommended limits:
# - DirectionalLight3D with shadows: 1-2
# - OmniLight3D with shadows: 3-5
# - SpotLight3D with shadows: 2-4
# - OmniLight3D without shadows: 20-30
# - SpotLight3D without shadows: 15-20

# Disable shadows on minor lights
@onready var candle_lights: Array = [$Candle1, $Candle2, $Candle3]

func _ready() -> void:
    for light in candle_lights:
        light.shadow_enabled = false  # Save performance
```

### Per-Light Shadow Distance

```gdscript
# Disable shadows for distant lights
extends OmniLight3D

@export var shadow_max_distance := 50.0

func _process(delta: float) -> void:
    var camera := get_viewport().get_camera_3d()
    if camera:
        var dist := global_position.distance_to(camera.global_position)
        shadow_enabled = (dist < shadow_max_distance)
```

---

## Edge Cases

### Shadows Through Floors

```gdscript
# Problem: Thin floors let shadows through
# Solution: Increase shadow bias

extends DirectionalLight3D

func _ready() -> void:
    shadow_enabled = true
    shadow_bias = 0.1  # Increase if shadows bleed through
    shadow_normal_bias = 2.0
```

### Light Leaking in Indoor Scenes

```gdscript
# Problem: VoxelGI light bleeds through walls
# Solution: Place VoxelGI nodes per-room, don't overlap

# Also: Ensure walls have proper thickness (not paper-thin)
```



---

## Expert Techniques & Optimizations

### 1. Shadowmasking for Large Outdoor Scenes
Rendering real-time shadows for distant objects is too expensive. Use **Shadowmasking** by setting a DirectionalLight3D to the `Dynamic` bake mode while baking a `LightmapGI`. This bakes distant shadows into a texture while allowing dynamic objects to cast real-time shadows up close, preventing "double shadowing" artifacts.

### 2. Fake Global Illumination
If you cannot afford GI at all (e.g., strict mobile constraints), fake it! Duplicate your main `DirectionalLight3D`, rotate it 180 degrees (pointing up from the ground), turn Shadows OFF, set Specular to 0.0, and reduce Energy to 10-40%. This cheaply simulates bounced floor lighting.

### 3. Simulating PCSS (Contact-Hardening Shadows)
Godot's OmniLight3D scaling can simulate Percentage-Closer Soft Shadows (blurrier shadows further from the caster).

```gdscript
extends OmniLight3D

func _ready() -> void:
    # Simulates area lights and Percentage-Closer Soft Shadows (PCSS).
    # Note: High performance cost. Keep the number of lights with light_size > 0.0 low.
    light_size = 0.5
    shadow_enabled = true
    
    # Distance fade culls the light and shadow completely when out of range,
    # preventing the clustered renderer from choking on too many overlapping PCSS lights.
    distance_fade_enabled = true
    distance_fade_begin = 20.0
    distance_fade_length = 5.0
```

---

## Expert Pattern: Light-Volume-Trigger

Smoothly transition between lighting environments (e.g., entering a dark cave from a bright desert) using `Area3D` triggers and `Tween`-driven `Camera3D` overrides.

```gdscript
class_name LightVolumeTrigger extends Area3D

@export var interior_environment: Environment
@export var transition_duration: float = 2.0

func _ready() -> void:
    body_entered.connect(_on_body_entered)
    body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D) -> void:
    if body.is_in_group("player"):
        var camera := get_viewport().get_camera_3d()
        # Duplicate to avoid modifying the original resource
        if not camera.environment:
            camera.environment = interior_environment.duplicate()
            
        var tween := create_tween().set_parallel(true)
        # Interpolate key properties for visual adaptation
        tween.tween_property(camera.environment, "tonemap_exposure", interior_environment.tonemap_exposure, transition_duration)
        tween.tween_property(camera.environment, "ambient_light_energy", interior_environment.ambient_light_energy, transition_duration)

func _on_body_exited(body: Node3D) -> void:
    if not body.is_in_group("player"):
        return
    var camera := get_viewport().get_camera_3d()
    if camera == null or camera.environment == null:
        return
    var world_env := get_tree().get_first_node_in_group("world_environment") as WorldEnvironment
    var target := world_env.environment if world_env and world_env.environment else Environment.new()
    var tween := create_tween().set_parallel(true)
    tween.tween_property(camera.environment, "tonemap_exposure", target.tonemap_exposure, transition_duration)
    tween.tween_property(camera.environment, "ambient_light_energy", target.ambient_light_energy, transition_duration)
    tween.chain().tween_callback(func():
        # Return to WorldEnvironment ownership when blend completes
        camera.environment = null
    )
```

> [!TIP]
> Place a `ReflectionProbe` inside the interior with `interior = true`. Godot will automatically blend this with the exterior environment as the player transitions.

---

## Expert Pattern: Interior-Mapping (Fake-Rooms)

Fake interior depth on window quads is a custom spatial-shader specialty — implement in a project shader or route to `godot-shaders-basics`. Do not keep incomplete ray-box stubs in this skill body.

---

## Expert Pattern: Lighting-Quality-Settings

Manage complex lighting features (Shadows, SDFGI, Fog) at runtime using the `RenderingServer` API for direct engine control.

```gdscript
class_name LightingQualityManager extends Node

func apply_low_quality_profile(env_rid: RID) -> void:
    # 1. SDFGI Optimization
    # Huge performance gain: Render GI buffers at half resolution
    RenderingServer.gi_set_use_half_resolution(true)
    RenderingServer.environment_set_sdfgi_ray_count(RenderingServer.ENV_SDFGI_RAY_COUNT_4)
    RenderingServer.environment_set_sdfgi_frames_to_converge(RenderingServer.ENV_SDFGI_CONVERGE_IN_30_FRAMES)
    
    # 2. Shadow Optimization
    # Reduce global directional shadow atlas
    RenderingServer.directional_shadow_atlas_set_size(2048, true)
    RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_VERY_LOW)
    # Reduce positional (Omni/Spot) shadows for current viewport
    get_viewport().positional_shadow_atlas_size = 1024
    
    # 3. Volumetric Fog
    # Disable or heavily reduce fog detail
    RenderingServer.environment_set_volumetric_fog(env_rid, false, 0.01, Color.WHITE, Color.BLACK, 0.0, 0.2, 64.0, 2.0, 1.0, true, 0.9, 0.0, 1.0)
```

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Introduction to lights and shadows](https://docs.godotengine.org/en/stable/tutorials/3d/lights_and_shadows.html) — Directional/Omni/Spot roles, shadow atlas budgets, cascades, projectors, and bias tradeoffs.
- [Introduction to global illumination](https://docs.godotengine.org/en/stable/tutorials/3d/global_illumination/introduction_to_global_illumination.html) — Decision matrix for LightmapGI vs VoxelGI vs SDFGI vs probes before committing bake or runtime cost.
- [Using SDFGI](https://docs.godotengine.org/en/stable/tutorials/3d/global_illumination/using_sdfgi.html) — Forward+-only real-time GI cascades, occlusion, and quality knobs used by outdoor/open scenes.
- [Using VoxelGI](https://docs.godotengine.org/en/stable/tutorials/3d/global_illumination/using_voxel_gi.html) — Bounded indoor GI, subdivision, leak causes (thin walls), and per-room bake workflow.
- [Using LightmapGI](https://docs.godotengine.org/en/stable/tutorials/3d/global_illumination/using_lightmap_gi.html) — Static bake modes, denoiser, shadowmasks, and when baked lighting cannot serve dynamic geometry.
- [Reflection probes](https://docs.godotengine.org/en/stable/tutorials/3d/global_illumination/reflection_probes.html) — Localized specular capture, Update Once vs Always, and interior blending with environments.
- [Faking global illumination](https://docs.godotengine.org/en/stable/tutorials/3d/global_illumination/faking_global_illumination.html) — Fill-light / bounce approximations for Mobile and Compatibility when SDFGI is unavailable.
- [Environment and post-processing](https://docs.godotengine.org/en/stable/tutorials/3d/environment_and_post_processing.html) — WorldEnvironment sky, ambient, tonemap, and camera overrides for light-volume transitions.
- [Volumetric fog and fog volumes](https://docs.godotengine.org/en/stable/tutorials/3d/volumetric_fog.html) — Global volumetric fog plus FogVolume density zones for shafts and localized atmosphere.
- [Physical light and camera units](https://docs.godotengine.org/en/stable/tutorials/3d/physical_light_and_camera_units.html) — Lux/EV-style energy when matching real-world day/night and exposure chains.
- [Optimizing 3D performance](https://docs.godotengine.org/en/stable/tutorials/performance/optimizing_3d_performance.html) — Shadow/GI/light-count budgets after local LOD and cascade tuning still miss frame time.
- [AreaLight3D](https://docs.godotengine.org/en/stable/classes/class_arealight3d.html) — Rectangular soft area lights for panels/screens instead of emissive-only fakes in Forward+.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Renderer choice (Forward+/Mobile/Compatibility), shadow atlas, and GI project settings gate which lighting features exist.
- [godot-3d-materials](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-materials/SKILL.md) — Albedo/roughness/metallic/emission and `gi_mode` decide how surfaces receive bounced and baked light.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — Typed node scripts, Tweens, and Resource ownership patterns used by managers and environment blends.

#### Complements
- [godot-shaders-basics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md) — Custom spatial/fog/sky shaders and interior-mapping tricks that extend Environment lighting without more real lights.
- [godot-camera-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md) — Camera `environment` overrides and exposure pairing for cave/interior light-volume transitions.
- [godot-3d-world-building](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md) — Scene scale, sealed interiors, and GridMap/static layout that make VoxelGI/LightmapGI bake cleanly.
- [godot-particles](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md) — Dust/smoke/embers read correctly only when fog density and light energy are co-authored.
- [godot-tweening](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md) — Smooth Environment, fog, and light-energy transitions instead of hard cuts at Area3D boundaries.
- [godot-physics-3d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md) — Area3D body enter/exit triggers that drive light-volume and fog-zone blends.
- [godot-adapt-desktop-to-mobile](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-desktop-to-mobile/SKILL.md) — Strip SDFGI/heavy shadows and swap to fake bounce GI when targeting Mobile/Compatibility.

#### Downstream / consumers
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — Escalate here when cascade splits, probe counts, or volumetric fog still dominate the profiler.
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — Simulate visibility/readability under day-night or darkness budgets when lighting changes combat, stealth, or horror difficulty.
- [godot-genre-horror](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-horror/SKILL.md) — Consumes sparse lights, fog, and ReflectionProbe interiors for tension-first atmospheres.
- [godot-debugging-profiling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md) — Use debugger/monitor views to prove shadow atlas and GI cost before cutting features blindly.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry; open when discovering which Domain Skill owns a cross-cutting lighting concern.
