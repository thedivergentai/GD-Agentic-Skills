---
name: godot-3d-materials
description: "Expert patterns for Godot 3D PBR materials using StandardMaterial3D including albedo, metallic/roughness workflows, normal maps, ORM texture packing, transparency modes, and shader conversion. Use when creating realistic 3D surfaces, PBR workflows, or material optimization. Trigger keywords: StandardMaterial3D, BaseMaterial3D, albedo_texture, metallic, metallic_texture, roughness, roughness_texture, normal_texture, normal_enabled, orm_texture, transparency, alpha_scissor, alpha_hash, cull_mode, ShaderMaterial, shader parameters."
---

# 3D Materials

Expert guidance for PBR materials and StandardMaterial3D in Godot.

## NEVER Do

- **NEVER use separate metallic/roughness/AO textures** — Use ORM packing (1 RGB texture with Occlusion/Roughness/Metallic channels) to save texture slots and memory.
- **NEVER forget to enable normal_enabled** — Normal maps don't work unless you set `normal_enabled = true`. Silent failure is common.
- **NEVER use TRANSPARENCY_ALPHA for cutout materials** — Use TRANSPARENCY_ALPHA_SCISSOR or TRANSPARENCY_ALPHA_HASH instead. Full alpha blending is expensive and causes sorting issues.
- **NEVER set metallic = 0.5** — Materials are either metallic (1.0) or dielectric (0.0). Values between are physically incorrect except for rust/dirt transitions.
- **NEVER use emission without HDR** — Emission values > 1.0 only work with HDR rendering enabled in Project Settings.
- **NEVER use transparent materials for large environmental surfaces** — Transparent objects cannot rely on the Z-buffer for early fragment rejection, resulting in massive overdraw. If only a tiny part of a mesh is transparent, split the mesh into two surfaces: one opaque, one transparent.
- **NEVER create hundreds of slightly varied StandardMaterial3D resources if performance is dropping** — Godot minimizes GPU state changes by automatically reusing the underlying shader for materials that share the exact same configuration flags (checkboxes). Try to group your material configurations.
- **NEVER attempt to fix Z-fighting strictly by moving objects further apart** — Floating-point precision degrades over distance. To fix flickering textures, increase your Camera3D's `Near` plane property and decrease the `Far` property to compress the precision range.
- **NEVER use unique Material resources per MeshInstance3D** — This breaks draw call batching. Use 'Instance Uniforms' to vary parameters while keeping a single shared material.
- **NEVER mutate a shared Material `.tres` / surface material at runtime** — Call `duplicate(true)` or enable **Local To Scene**, then assign the unique instance before tweaking parameters. **MANDATORY** use [`material_fx.gd`](../scripts/3d_materials_material_fx.gd) `ensure_unique_override()` / overlay helpers for flash/dissolve.
- **NEVER use Decals on dynamic moving actors without a Cull Mask** — Bullet holes should not stick to the player's face as they walk over them. Mask out character layers.

---

## Godot 4.7: Materials

- **AreaLight3D** pairs with emissive materials for physically correct rectangular emitters.
- `Texture2D.get_format()` unified on base class for portable compressed textures.

## Available Scripts

> **MANDATORY**: Read the appropriate script before implementing the corresponding pattern.

### Workflow router (MANDATORY / Do NOT Load)
| Task | Load | Do NOT Load |
|------|------|-------------|
| StandardMaterial3D / ORM / transparency | `pbr_orm_packer.gd`, `transparency_sorting_fix.gd`, `material_batcher.gd`, `material_fx.gd` | `triplanar_world*.gdshader`, `vertex_wind_sway.gdshader` |
| UV-less terrain / cliffs | `triplanar_world.gdshader` or `triplanar_world_projection.gdshader` + `pbr_material_builder.gd` | Wind sway unless foliage |
| Foliage wind | `vertex_wind_sway.gdshader` | Triplanar unless rock/terrain also needed |
| Runtime damage / dissolve | **MANDATORY** `material_fx.gd` | Editing shared imported materials |
| Instance color/health / texture-array variants | **MANDATORY** `instance_uniform_batching.gdshader` | Per-mesh unique StandardMaterial3D copies; body texture-array samples |
| HLOD / distant material simplify | `material_batcher.gd` (`setup_lod_materials`) | Alpha-blend distance fade (use Pixel Dither) |
| Organic SSS / rim / clearcoat | `organic_material.gd`, `subsurface_scattering_setup.gd` | SSS recipes on Mobile/Compatibility |

> Pure StandardMaterial3D albedo/ORM/transparency work: **Do NOT Load** triplanar, wind, or texture-array shaders.

### [material_fx.gd](../scripts/3d_materials_material_fx.gd)
**MANDATORY** for runtime FX. `ensure_unique_override()` / overlay flash / scissor dissolve — never tween shared `.tres` materials.

### [pbr_material_builder.gd](../scripts/3d_materials_pbr_material_builder.gd)
Runtime PBR material creation with ORM textures and triplanar mapping.

### [organic_material.gd](../scripts/3d_materials_organic_material.gd)
Subsurface scattering and rim lighting setup for organic surfaces (skin, leaves). Use for realistic character or vegetation materials.

### [triplanar_world.gdshader](../scripts/3d_materials_triplanar_world.gdshader)
Triplanar projection shader for terrain without UV mapping. Blends textures based on surface normals. Use for cliffs, caves, or procedural terrain.

### [pbr_orm_packer.gd](../scripts/3d_materials_pbr_orm_packer.gd)
Expert PBR resource utility. Packs Ambient Occlusion, Roughness, and Metallic into a single ORM texture to optimize VRAM and draw calls.

### [vertex_wind_sway.gdshader](../scripts/3d_materials_vertex_wind_sway.gdshader)
High-performance GPU-driven foliage animation. Uses vertex world coordinates and vertex color weight painting to simulate wind without skeletons.

### [triplanar_world_projection.gdshader](../scripts/3d_materials_triplanar_world_projection.gdshader)
UV-less environment mapping. Projects textures along X/Y/Z axes for organic blending over complex rocks and terrain.

### [subsurface_scattering_setup.gd](../scripts/3d_materials_subsurface_scattering_setup.gd)
Configuring realistic organic materials. Covers Skin Mode, Transmittance, and depth scattering settings for Forward+ rendering.

### [instance_uniform_batching.gdshader](../scripts/3d_materials_instance_uniform_batching.gdshader)
Architecture pattern for high-speed batching. Allows 10,000 meshes to share one material while maintaining unique colors or health states via instance uniforms.

### [decal_placer_expert.gd](../scripts/3d_materials_decal_placer_expert.gd)
Dynamic 3D decal system with cull masking and life-cycle management for impact effects.

### [transparency_sorting_fix.gd](../scripts/3d_materials_transparency_sorting_fix.gd)
Solving visual artifacts using Alpha Hash and Depth Prepass strategies.

### [shader_state_manager.gd](../scripts/3d_materials_shader_state_manager.gd)
Clean pattern for toggling shader-based visual states (Frozen, Burned) on multiple entities.

### [depth_precision_fix.gd](../scripts/3d_materials_depth_precision_fix.gd)
Camera-side fix for Z-fighting and texture flickering in large-scale worlds.

### [material_batcher.gd](../scripts/3d_materials_material_batcher.gd)
Global override system to ensure environmental meshes draw in optimized, state-locked batches.

---

## StandardMaterial3D Checklist (script-first)

1. Pack AO/Roughness/Metallic → **MANDATORY** [`pbr_orm_packer.gd`](../scripts/3d_materials_pbr_orm_packer.gd); set `orm_texture` (never three separate maps).
2. Enable `normal_enabled` before assigning `normal_texture` (silent no-op otherwise).
3. Pick transparency from the matrix below — not docs-default ALPHA for cutouts.
4. Organic skin/leaves → [`organic_material.gd`](../scripts/3d_materials_organic_material.gd) + [`subsurface_scattering_setup.gd`](../scripts/3d_materials_subsurface_scattering_setup.gd) (Forward+ only for real SSS).
5. Runtime flash/dissolve → **MANDATORY** [`material_fx.gd`](../scripts/3d_materials_material_fx.gd) `ensure_unique_override()` first.
6. Shared-mesh tint/variant → [`instance_uniform_batching.gdshader`](../scripts/3d_materials_instance_uniform_batching.gdshader); never unique `.tres` per instance.
7. Distant LOD simplify / Pixel Dither fade → [`material_batcher.gd`](../scripts/3d_materials_material_batcher.gd) `setup_lod_materials()`.
8. Check Forward+ vs Mobile feature matrix before enabling SSS/clearcoat/anisotropy.

### Forward+ vs Mobile (material features)

| Feature | Forward+ | Mobile / Compatibility | WHY |
|---------|----------|------------------------|-----|
| Subsurface scattering / Skin Mode | Full | Limited / often unavailable | SSS needs Forward+ lighting path; fake with rim + transmittance bake on Mobile |
| Clearcoat | Yes | Often stripped / approximate | Extra specular lobe cost; drop on distant LOD and Mobile |
| Anisotropy | Yes | Prefer off | Flowmap + anisotropic BRDF burns mobile fragment budget |
| Alpha Hash / Pixel Dither fade | Yes | Prefer Alpha Scissor or opaque dither | Hash noise + overdraw hurts tile GPUs |
| Instance uniforms (batching) | Yes | Yes (prefer this) | Keeps one material; avoids unique-resource draw breaks |

---

## Transparency Modes

### Decision Matrix

| Mode | Use Case | Performance | Sorting Issues |
|------|----------|-------------|---------------|
| ALPHA_SCISSOR | Foliage, chain-link fence | Fast | No |
| ALPHA_HASH | Dithered fade, LOD transitions | Fast | Noisy |
| ALPHA | Glass, water, godot-particles | Slow | Yes (render order) |

### Alpha Scissor (Cutout)

```gdscript
# For leaves, grass, fences
mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
mat.alpha_scissor_threshold = 0.5  # Pixels < 0.5 alpha = discarded
mat.albedo_texture = load("res://leaf.png")  # Must  have alpha channel

# Enable backface culling for performance
mat.cull_mode = BaseMaterial3D.CULL_BACK
```

### Alpha Hash (Dithered)

```gdscript
# For smooth fade-outs without sorting issues
mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_HASH
mat.alpha_hash_scale = 1.0  # Dither pattern scale

# Animate fade
var tween := create_tween()
tween.tween_property(mat, "albedo_color:a", 0.0, 1.0)
```

### Alpha Blend (Full Transparency)

```gdscript
# For glass, water (expensive)
mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
mat.blend_mode = BaseMaterial3D.BLEND_MODE_MIX

# Disable depth writing for correct blending
mat.depth_draw_mode = BaseMaterial3D.DEPTH_DRAW_DISABLED
mat.cull_mode = BaseMaterial3D.CULL_DISABLED  # Show both sides
```

---

## Texture Channel Packing

**MANDATORY** [`pbr_orm_packer.gd`](../scripts/3d_materials_pbr_orm_packer.gd) for R=AO / G=Roughness / B=Metallic. Do not inline packing recipes here. Custom channel remaps only when an imported atlas already disagrees with ORM layout.

---

## Shader Conversion

### When to Convert to ShaderMaterial

- Need custom effects (dissolve, vertex displacement)
- StandardMaterial3D limitations hit
- Shader optimizations (remove unused features)

### Conversion Workflow

```gdscript
# 1. Create StandardMaterial3D with all settings
var std_mat := StandardMaterial3D.new()
std_mat.albedo_color = Color.RED
std_mat.metallic = 1.0
std_mat.roughness = 0.2

# 2. Convert to ShaderMaterial
var shader_mat := ShaderMaterial.new()
shader_mat.shader = load("res://custom_shader.gdshader")

# 3. Transfer parameters manually
shader_mat.set_shader_parameter("albedo", std_mat.albedo_color)
shader_mat.set_shader_parameter("metallic", std_mat.metallic)
shader_mat.set_shader_parameter("roughness", std_mat.roughness)
```

---

## Material Variants (Godot 4.0+)

### Efficient Material Reuse

```gdscript
# Base material (shared)
var base_red_metal := StandardMaterial3D.new()
base_red_metal.albedo_color = Color.RED
base_red_metal.metallic = 1.0

# Variant 1: Rough
var rough_variant := base_red_metal.duplicate()
rough_variant.roughness = 0.8

# Variant 2: Smooth
var smooth_variant := base_red_metal.duplicate()
smooth_variant.roughness = 0.1

# Note: Use resource_local_to_scene for per-instance tweaks
```

---

## Performance Optimization

### Material Batching

```gdscript
# ✅ GOOD: Reuse materials across meshes
const SHARED_STONE := preload("res://materials/stone.tres")

func _ready() -> void:
    for wall in get_tree().get_nodes_in_group("stone_walls"):
        wall.material_override = SHARED_STONE
    # All walls batched in single draw call

# ❌ BAD: Unique material per mesh
func _ready() -> void:
    for wall in get_tree().get_nodes_in_group("stone_walls"):
        var mat := StandardMaterial3D.new()  # New material!
        mat.albedo_color = Color(0.5, 0.5, 0.5)
        wall.material_override = mat
    # Each wall is separate draw call
```

### Texture Atlasing

```gdscript
# Combine multiple materials into one texture atlas
# Then use UV offsets to select regions

# material_atlas.gd
extends StandardMaterial3D

func set_atlas_region(tile_x: int, tile_y: int, tiles_per_row: int) -> void:
    var tile_size := 1.0 / tiles_per_row
    uv1_offset = Vector3(tile_x * tile_size, tile_y * tile_size, 0)
    uv1_scale = Vector3(tile_size, tile_size, 1)
```

---

## Edge Cases

### Normal Maps Not Working

```gdscript
# Problem: Forgot to enable
mat.normal_enabled = true  # REQUIRED

# Problem: Wrong texture import settings
# In Import tab: Texture → Normal Map = true
```

### Texture Seams on Models

```gdscript
# Problem: Mipmaps causing seams
# Solution: Disable mipmaps for tightly-packed UVs
# Import → Mipmaps → Generate = false
```

### Material Looks Flat

```gdscript
# Problem: Missing normal map or roughness variation
# Solution: Add normal map + roughness texture

mat.normal_enabled = true
mat.normal_texture = load("res://normal.png")
mat.roughness_texture = load("res://roughness.png")
```

---

## Expert Techniques & Optimizations

### 1. LOD Transitions using Pixel Dither
When utilizing Hierarchical Level of Detail (HLOD) or Visibility Ranges to fade objects out at a distance, standard alpha blending causes severe performance hits due to overlapping transparent bounds. Instead, configure the **Distance Fade** mode on your material to **Pixel Dither**. This provides a perceptually smooth fade while remaining entirely within the high-performance opaque pipeline.

### 2. Stencil Buffers (Godot 4.5+)
Use the Stencil Buffer directly in `StandardMaterial3D`. This allows you to easily render outlines or X-ray effects for objects hidden behind walls without needing to write custom shaders for basic effects.

### 3. AR Shadow Overlay Shader
If you are developing an AR game, you might want virtual shadows to appear on real-world camera feeds. Instead of standard blending, use Godot's built-in `shadow_to_opacity` render mode in a spatial shader.

```shader
shader_type spatial;
// shadow_to_opacity makes the material invisible when lit, 
// but opaque (dark) when it receives a shadow from another 3D object.
render_mode blend_mix, depth_draw_opaque, cull_back, shadow_to_opacity;

void fragment() {
    // The surface color is black; opacity will be driven by incoming shadows
    ALBEDO = vec3(0.0, 0.0, 0.0);
}
```

---

## Expert Pattern: Material-Texture-Array (Instanced Variation)

**MANDATORY** [`instance_uniform_batching.gdshader`](../scripts/3d_materials_instance_uniform_batching.gdshader) for per-instance color/health **and** texture-array index variants. Set `texture_index` via `GeometryInstance3D.set_instance_shader_parameter` — never unique materials per tree/crowd variant.

---

## Expert Pattern: Dissolve-Shader-Integration (Alpha Scissor)

Use Alpha Scissor for performant dissolves (keeps shadows, avoids alpha sort). **MANDATORY** [`material_fx.gd`](../scripts/3d_materials_material_fx.gd) `dissolve_scissor()` — it duplicates the override first.

---

## Expert Pattern: Material-LOD-System (HLOD)

Mesh LOD is automatic; material shading is not. **MANDATORY** [`material_batcher.gd`](../scripts/3d_materials_material_batcher.gd) `setup_lod_materials()` for visibility-range swaps, feature strip on distant materials, and Pixel Dither distance fade (not alpha blend).

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API;
> load Related Skills when routing work to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Standard Material 3D and ORM Material 3D](https://docs.godotengine.org/en/stable/tutorials/3d/standard_material_3d.html) — Primary PBR tutorial for albedo/metallic/roughness, ORM packing, transparency modes, and feature flags on StandardMaterial3D.
- [BaseMaterial3D](https://docs.godotengine.org/en/stable/classes/class_basematerial3d.html) — Shared API for transparency enums, texture channels, cull/depth draw, distance fade, and subsurface scattering controls.
- [StandardMaterial3D](https://docs.godotengine.org/en/stable/classes/class_standardmaterial3d.html) — Concrete material class used throughout this skill’s builders, FX helpers, and presets.
- [ORMMaterial3D](https://docs.godotengine.org/en/stable/classes/class_ormmaterial3d.html) — Dedicated ORM-packed material path when Occlusion/Roughness/Metallic already live in one RGB texture.
- [Using decals](https://docs.godotengine.org/en/stable/tutorials/3d/using_decals.html) — Projector decals, cull masks, and performance limits for bullet holes and detail without unique materials.
- [Importing images](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_images.html) — Correct normal-map and channel import settings so PBR maps are not treated as color data.
- [Visibility ranges (HLOD)](https://docs.godotengine.org/en/stable/tutorials/3d/visibility_ranges.html) — Distance swap / fade modes that pair with simplified distant materials and Pixel Dither distance fade.
- [Spatial shader](https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/spatial_shader.html) — Built-ins for triplanar, wind sway, `instance uniform`, and `shadow_to_opacity` when StandardMaterial3D is not enough.
- [Your first 3D shader](https://docs.godotengine.org/en/stable/tutorials/shaders/your_first_shader/your_first_3d_shader.html) — Conversion path from StandardMaterial3D settings into a writable spatial ShaderMaterial.
- [GeometryInstance3D](https://docs.godotengine.org/en/stable/classes/class_geometryinstance3d.html) — `set_instance_shader_parameter`, material overlays/overrides, and visibility-range properties for shared-material batching.
- [GPU optimization](https://docs.godotengine.org/en/stable/tutorials/performance/gpu_optimization.html) — Overdraw, transparency cost, and batching guidance that motivates ORM packing and avoiding unique materials.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Nodes, Resources, and import basics required before authoring reusable `.tres` materials and texture sets.
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — Material/texture Resources, duplication vs sharing, and data-driven presets that keep draw-call batching intact.
- [godot-shaders-basics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md) — Shading language and ShaderMaterial fundamentals before converting StandardMaterial3D or writing triplanar/instance-uniform shaders.

#### Complements
- [godot-3d-lighting](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-lighting/SKILL.md) — Emission energy, HDR, GI, and AreaLight3D interactions that determine how PBR and emissive materials actually read in-scene.
- [godot-3d-world-building](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md) — Applying shared environment materials, decals, and triplanar projection across large level geometry.
- [godot-camera-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md) — Camera3D near/far and framing choices that fix Z-fighting / depth precision issues materials alone cannot solve.
- [godot-particles](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md) — Particle draw modes and alpha pipelines that must stay consistent with material transparency choices (scissor/hash vs blend).
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — Draw-call batching, MultiMesh, and GPU budgets when scaling unique vs shared materials.
- [godot-debugging-profiling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md) — GPU/overdraw profilers to verify transparency and material-state regressions after material changes.

#### Downstream / consumers
- [godot-genre-open-world](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-open-world/SKILL.md) — Large worlds consume HLOD visibility ranges, dithered distance fade, and shared-material batching patterns from this skill.
- [godot-procedural-generation](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-procedural-generation/SKILL.md) — Procedural meshes and terrains typically need triplanar / world-projection materials when UVs are absent or unstable.
- [godot-adapt-2d-to-3d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-2d-to-3d/SKILL.md) — Moving flat art into 3D requires PBR map setup, normal import, and transparency mode choices covered here.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry for cross-skill discovery.
