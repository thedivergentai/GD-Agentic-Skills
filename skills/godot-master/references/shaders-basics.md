---
name: godot-shaders-basics
description: "Expert Godot shader patterns for batch-safe hitflash, alpha-scissor foliage/dissolve, screenspace postFX, depth reconstruction, triplanar, and instance uniforms — not first-shader tutorials. Trigger on draw-call batching breaks, discard vs depth-prepass, foliage shadows, post-process quads, or world-position FX. Keywords: instance uniform, ALPHA_SCISSOR, hint_screen_texture, hint_depth_texture, global uniform, sampler2DArray, canvas_item, spatial, post-processing."
---
## Godot 4.7 Baseline

- Expert patterns target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading from 4.6.
- `LinearToSRGB` visual-shader node no longer clamps to `[0,1]` on Mobile/Forward+.
- Drawable Texture API for custom render targets; `get_format()` lives on **Texture2D** base for `ImageTexture` / `PortableCompressedTexture2D`.
- **NEVER** assume 4.6 defaults without checking 4.7 migration notes.

# Shader Expert Patterns

Batching-safe materials, scissor/dissolve, screenspace FX, and depth reconstruction — Official Docs cover first shaders and built-in glossaries.

## NEVER Do in Shaders

- **NEVER use `discard` unconditionally for optimization** — It prevents the depth prepass from working effectively. A discarded pixel still costs vertex processing; sometimes not rendering the object is better [1].
- **NEVER use `if/else` for dynamic states in high-performance shaders** — GPUs hate branching. Use `mix()`, `step()`, and `smoothstep()` for mathematical, hardware-optimized selection [5, 21].
- **NEVER compare floats exactly** — Hardware precision varies; `if (v == 0.5)` is unreliable. Use `abs(a - b) < epsilon` or `step()`.
- **NEVER use standard Alpha Blending for massive foliage** — It prevents shadows and SSR. Use Alpha Scissor or Alpha Hash (dithering) to enable depth prepass and shadow casting [7].
- **NEVER hardcode `POSITION` to `vec4(VERTEX, 1.0)` for full-screen quads in 4.3+** — Godot 4.3 uses Reversed-Z depth; this will cause clipping. Use `POSITION = vec4(VERTEX.xy, 1.0, 1.0)` [8, 9].
- **NEVER duplicate materials to change one color/value on many enemies** — Use `instance uniform`. This allows unique values for thousands of nodes while maintaining a single draw call (batching) [10].
- **NEVER use `TIME` without a speed multiplier** — Fragment speed should be controllable via uniforms to ensure consistency across different gameplay states.
- **NEVER forget `hint_source_color` for color uniforms** — Without it, the engine treats colors as linear math, leading to incorrect gamma and washed-out visuals in the inspector.
- **NEVER calculate complex math in `fragment()` that could be in `vertex()`** — `vertex()` runs once per point; `fragment()` runs millions of times per frame. Interpolate values via `varying` instead.
- **NEVER use `#define` macros for dynamic runtime toggles** — These create new shader permutations, causing massive compilation stutters when first encountered in-game. Use uniforms instead.
- **NEVER forget to normalize vectors** — Using `reflect(dir, normal)` on unnormalized vectors causes severe rendering artifacts and incorrect lighting math.
- **NEVER modify UV without bounds checking or `fract()`** — Shifting UVs beyond 0.0-1.0 without `repeat` wrapping or clamping will sample edge pixels or return black, breaking texture consistency.


## Scenario → Script Triggers

> **MANDATORY** for the matching effect. **Do NOT Load** beginner canvas_item tint recipes or built-in variable glossaries here.

| Goal | Script |
|------|--------|
| Per-enemy hitflash without breaking batches | **MANDATORY** [instance_uniform_hitflash.gdshader](../scripts/shaders_basics_instance_uniform_hitflash.gdshader) |
| Foliage wind + shadows | **MANDATORY** [foliage_wind_sway_expert.gdshader](../scripts/shaders_basics_foliage_wind_sway_expert.gdshader) (alpha scissor/hash — not unconditional `discard`) |
| Dissolve that keeps depth-prepass | **MANDATORY** [dissolve_scissor_expert.gdshader](../scripts/shaders_basics_dissolve_scissor_expert.gdshader) |
| PostFX pixelate / stylize | **MANDATORY** [screenspace_hex_pixelate.gdshader](../scripts/shaders_basics_screenspace_hex_pixelate.gdshader) |
| Full-screen quad (Reversed-Z) | **MANDATORY** [screenspace_full_quad.gdshader](../scripts/shaders_basics_screenspace_full_quad.gdshader) |
| Depth → world for water/fog | **MANDATORY** [depth_world_reconstruction.gdshader](../scripts/shaders_basics_depth_world_reconstruction.gdshader) |
| Grass flatten from player | [global_grass_flatten.gdshader](../scripts/shaders_basics_global_grass_flatten.gdshader) |
| UV-less cliffs/rocks | [triplanar_world_mapping.gdshader](../scripts/shaders_basics_triplanar_world_mapping.gdshader) |
| Unique textures on instanced meshes | [instance_texture_array.gdshader](../scripts/shaders_basics_instance_texture_array.gdshader) |
| Vertex displacement terrain | [noise_terrain_displacement.gdshader](../scripts/shaders_basics_noise_terrain_displacement.gdshader) |
| Animate uniforms at runtime | [shader_parameter_animator.gd](../scripts/shaders_basics_shader_parameter_animator.gd) |
| VFX port template | [vfx_port_shader.gdshader](../scripts/shaders_basics_vfx_port_shader.gdshader) |

**Golden path for cutouts/dissolve:** `ALPHA_SCISSOR` / alpha hash (see dissolve + foliage scripts) — not `discard` for optimization. NEVER list explains why.

## Available Scripts

### [instance_uniform_hitflash.gdshader](../scripts/shaders_basics_instance_uniform_hitflash.gdshader)
Instance-uniform flashes; one material, many unique intensities.

### [dissolve_scissor_expert.gdshader](../scripts/shaders_basics_dissolve_scissor_expert.gdshader)
Mask dissolve with `ALPHA_SCISSOR` for depth-prepass + shadows.

### [foliage_wind_sway_expert.gdshader](../scripts/shaders_basics_foliage_wind_sway_expert.gdshader)
World-space wind sway for foliage batches.

### [global_grass_flatten.gdshader](../scripts/shaders_basics_global_grass_flatten.gdshader)
`global uniform` player interaction flattening grass.

### [screenspace_hex_pixelate.gdshader](../scripts/shaders_basics_screenspace_hex_pixelate.gdshader)
`hint_screen_texture` stylized postFX.

### [screenspace_full_quad.gdshader](../scripts/shaders_basics_screenspace_full_quad.gdshader)
Reversed-Z-safe full-rect post pass.

### [depth_world_reconstruction.gdshader](../scripts/shaders_basics_depth_world_reconstruction.gdshader)
`hint_depth_texture` → world position.

### [triplanar_world_mapping.gdshader](../scripts/shaders_basics_triplanar_world_mapping.gdshader)
World-axis projection without UVs.

### [instance_texture_array.gdshader](../scripts/shaders_basics_instance_texture_array.gdshader)
`sampler2DArray` + instance uniform for unique batched textures.

### [noise_terrain_displacement.gdshader](../scripts/shaders_basics_noise_terrain_displacement.gdshader)
Vertex noise displacement.

### [vfx_port_shader.gdshader](../scripts/shaders_basics_vfx_port_shader.gdshader)
Validated VFX shader template.

### [shader_parameter_animator.gd](../scripts/shaders_basics_shader_parameter_animator.gd)
Tween/runtime uniform animation without AnimationPlayer.

## Expert Pointers

- Move invariant math to `vertex()`; pass via `varying`.
- Color uniforms need `hint_source_color`.
- Prefer Official Docs for shading-language builtins; this skill owns batching, scissor, screenspace, and depth routing.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API;
> load Related Skills when routing work to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Introduction to shaders](https://docs.godotengine.org/en/stable/tutorials/shaders/introduction_to_shaders.html) — Entry map of shader types, render modes, and when to use ShaderMaterial vs StandardMaterial3D.
- [Shading language](https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/shading_language.html) — Core GLSL-like syntax: uniforms, hints, varyings, built-ins, and preprocessor rules used throughout this skill.
- [CanvasItem shaders](https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/canvas_item_shader.html) — 2D `canvas_item` built-ins (`UV`, `COLOR`, `TEXTURE`, `SCREEN_UV`) for sprites, UI, and 2D post FX.
- [Spatial shaders](https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/spatial_shader.html) — 3D `spatial` built-ins (`ALBEDO`, `NORMAL`, `instance uniform`, depth/screen textures) for materials and full-screen quads.
- [Your first 2D shader](https://docs.godotengine.org/en/stable/tutorials/shaders/your_first_shader/your_first_2d_shader.html) — Minimal canvas_item workflow from ShaderMaterial attach through fragment tinting.
- [Your first 3D shader](https://docs.godotengine.org/en/stable/tutorials/shaders/your_first_shader/your_first_3d_shader.html) — Minimal spatial workflow and conversion path from StandardMaterial3D into writable shaders.
- [ShaderMaterial](https://docs.godotengine.org/en/stable/classes/class_shadermaterial.html) — Runtime `set_shader_parameter` / instance parameter API used by animators and hit-flash batching.
- [Custom post-processing](https://docs.godotengine.org/en/stable/tutorials/shaders/custom_postprocessing.html) — Screen-reading shaders, `hint_screen_texture`, and compositing patterns for pixelate/vignette-style FX.
- [Advanced post-processing](https://docs.godotengine.org/en/stable/tutorials/shaders/advanced_postprocessing.html) — Depth buffer, reversed-Z, and world reconstruction needed for water/fog/debug visualizers.
- [Compute shaders](https://docs.godotengine.org/en/stable/tutorials/shaders/compute_shaders.html) — RenderingDevice GPGPU path for particle sims and other non-fragment workloads.
- [Using VisualShaders](https://docs.godotengine.org/en/stable/tutorials/shaders/visual_shaders.html) — Graph editor + `VisualShaderNodeCustom` extensibility covered in the expert patterns.
- [GPU optimization](https://docs.godotengine.org/en/stable/tutorials/performance/gpu_optimization.html) — Overdraw, transparency, and batching guidance that motivates alpha scissor, instance uniforms, and vertex-vs-fragment cost.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Nodes, Resources, and project layout required before attaching ShaderMaterials and shipping `.gdshader` assets.
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — Sharing vs duplicating ShaderMaterial/Shader Resources so uniforms and instance parameters stay batch-friendly.

#### Complements
- [godot-3d-materials](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-materials/SKILL.md) — StandardMaterial3D/ORM first; graduate to spatial shaders for triplanar, dissolve, and instance-uniform effects.
- [godot-3d-lighting](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-lighting/SKILL.md) — How custom `ALBEDO`/`EMISSION`/`light()` output interacts with Forward+, GI, and fog volumes.
- [godot-particles](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md) — Particle process/draw materials and alpha pipelines that must match scissor/hash vs blend choices from this skill.
- [godot-2d-animation](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-animation/SKILL.md) — CanvasItem shader hooks for stylized 2D motion, outline, and dissolve on animated sprites.
- [godot-camera-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md) — Camera near/far and view/projection matrices that screen-space and depth-reconstruction shaders depend on.
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — Draw-call batching, MultiMesh, and GPU budgets that justify `instance uniform` and avoiding unique materials.
- [godot-debugging-profiling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md) — GPU/overdraw profilers and debug views to validate shader cost and depth/normal visualizers.

#### Downstream / consumers
- [godot-procedural-generation](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-procedural-generation/SKILL.md) — Procedural meshes/terrain consume noise displacement, triplanar, and UV-less spatial patterns from this skill.
- [godot-3d-world-building](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md) — Large environment props apply foliage wind, grass flatten, and world-projection shaders at level scale.
- [godot-genre-open-world](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-open-world/SKILL.md) — Open-world foliage interaction, distance FX, and shared-material batching consume these shader templates.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry for cross-skill discovery.
