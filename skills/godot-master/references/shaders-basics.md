---
name: godot-shaders-basics
description: "Expert blueprint for shader programming (visual effects, post-processing, material customization) using Godot's GLSL-like shader language. Covers canvas_item (2D), spatial (3D), uniforms, built-in variables, and performance. Use when implementing custom effects OR stylized rendering. Keywords shader, GLSL, fragment, vertex, canvas_item, spatial, uniform, UV, COLOR, ALBEDO, post-processing."
---

# Shader Basics

Fragment/vertex shaders, uniforms, and built-in variables define custom visual effects.

## Available Scripts

### [vfx_port_shader.gdshader](../scripts/shaders_basics_vfx_port_shader.gdshader)
Expert shader template with parameter validation and common effect patterns.

### [shader_parameter_animator.gd](../scripts/shaders_basics_shader_parameter_animator.gd)
Runtime shader uniform animation without AnimationPlayer - for dynamic effects.

### [dissolve_scissor_expert.gdshader](../scripts/shaders_basics_dissolve_scissor_expert.gdshader)
High-performance mask-based dissolve. Uses `ALPHA_SCISSOR` to enable depth-prepass optimization and shadow casting.

### [instance_uniform_hitflash.gdshader](../scripts/shaders_basics_instance_uniform_hitflash.gdshader)
Batch-friendly hit effects. Uses `instance uniform` to allow thousands of unique flashes in one draw call.

### [screenspace_hex_pixelate.gdshader](../scripts/shaders_basics_screenspace_hex_pixelate.gdshader)
Post-processing logic for stylizing screen output. Uses `hint_screen_texture` and optimized coordinate quantization.

### [noise_terrain_displacement.gdshader](../scripts/shaders_basics_noise_terrain_displacement.gdshader)
Procedural geometry displacement using `NoiseTexture2D` in the `vertex()` function for rolling terrain.

### [foliage_wind_sway_expert.gdshader](../scripts/shaders_basics_foliage_wind_sway_expert.gdshader)
GPU-driven wind animation using `world_vertex_coords` for uniform sway across the environment.

### [global_grass_flatten.gdshader](../scripts/shaders_basics_global_grass_flatten.gdshader)
World-interaction pattern using `global uniform`. Synchronizes player position to push grass down project-wide.

### [depth_world_reconstruction.gdshader](../scripts/shaders_basics_depth_world_reconstruction.gdshader)
Expert depth-buffer logic. Reconstructs world-space coordinates from `hint_depth_texture` for water/fog effects.

### [triplanar_world_mapping.gdshader](../scripts/shaders_basics_triplanar_world_mapping.gdshader)
UV-less texturing architecture. Seamlessly projects textures along world axes for procedural cliffs and rocks.

### [instance_texture_array.gdshader](../scripts/shaders_basics_instance_texture_array.gdshader)
Bypassing batching limits. Combines `sampler2DArray` with `instance uniform` to give unique textures to thousands of batched objects.

### [screenspace_full_quad.gdshader](../scripts/shaders_basics_screenspace_full_quad.gdshader)
Godot 4.3 specific full-rect shader. Handles Reversed-Z coordinate reconstruction to prevent clipping at the near plane.

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

---

```gdsl
shader_type canvas_item;

void fragment() {
    // Get texture color
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Tint red
    COLOR = tex_color * vec4(1.0, 0.5, 0.5, 1.0);
}
```

**Apply to Sprite:**
1. Select Sprite2D node
2. Material → New ShaderMaterial
3. Shader → New Shader
4. Paste code

## Godot 4.7: Shaders

- `LinearToSRGB` visual shader node no longer clamps to `[0,1]` on Mobile/Forward+.
- **Drawable Texture API** for custom render targets.
- `get_format()` on `ImageTexture` / `PortableCompressedTexture2D` moved to **Texture2D** base.

## Common 2D Effects

### Dissolve Effect

```glsl
shader_type canvas_item;

uniform float dissolve_amount : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D noise_texture;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    float noise = texture(noise_texture, UV).r;
    
    if (noise < dissolve_amount) {
        discard;  // Make pixel transparent
    }
    
    COLOR = tex_color;
}
```

### Wave Distortion

```glsl
shader_type canvas_item;

uniform float wave_speed = 2.0;
uniform float wave_amount = 0.05;

void fragment() {
    vec2 uv = UV;
    uv.x += sin(uv.y * 10.0 + TIME * wave_speed) * wave_amount;
    
    COLOR = texture(TEXTURE, uv);
}
```

### Outline

```glsl
shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float outline_width = 2.0;

void fragment() {
    vec4 col = texture(TEXTURE, UV);
    vec2 pixel_size = TEXTURE_PIXEL_SIZE * outline_width;
    
    float alpha = col.a;
    alpha = max(alpha, texture(TEXTURE, UV + vec2(pixel_size.x, 0.0)).a);
    alpha = max(alpha, texture(TEXTURE, UV + vec2(-pixel_size.x, 0.0)).a);
    alpha = max(alpha, texture(TEXTURE, UV + vec2(0.0, pixel_size.y)).a);
    alpha = max(alpha, texture(TEXTURE, UV + vec2(0.0, -pixel_size.y)).a);
    
    COLOR = mix(outline_color, col, col.a);
    COLOR.a = alpha;
}
```

## 3D Shaders

### Basic 3D Shader

```glsl
shader_type spatial;

void fragment() {
    ALBEDO = vec3(1.0, 0.0, 0.0);  // Red material
}
```

### Toon Shading (Cel-Shading)

```glsl
shader_type spatial;

uniform vec3 base_color : source_color = vec3(1.0);
uniform int color_steps = 3;

void light() {
    float NdotL = dot(NORMAL, LIGHT);
    float stepped = floor(NdotL * float(color_steps)) / float(color_steps);
    
    DIFFUSE_LIGHT = base_color * stepped;
}
```

## Screen-Space Effects

### Vignette

```glsl
shader_type canvas_item;

uniform float vignette_strength = 0.5;

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    
    // Distance from center
    vec2 center = vec2(0.5, 0.5);
    float dist = distance(UV, center);
    
    float vignette = 1.0 - dist * vignette_strength;
    
    COLOR = color * vignette;
}
```

## Uniforms (Parameters)

```glsl
// Float slider
uniform float intensity : hint_range(0.0, 1.0) = 0.5;

// Color picker
uniform vec4 tint_color : source_color = vec4(1.0);

// Texture
uniform sampler2D noise_texture;

// Access in code:
material.set_shader_parameter("intensity", 0.8)
```

## Built-in Variables

**2D (canvas_item):**
- `UV` - Texture coordinates (0-1)
- `COLOR` - Output color
- `TEXTURE` - Current texture
- `TIME` - Time since start
- `SCREEN_UV` - Screen coordinates

**3D (spatial):**
- `ALBEDO` - Base color
- `NORMAL` - Surface normal
- `ROUGHNESS` - Surface roughness
- `METALLIC` - Metallic value

## Best Practices

### 1. Use Uniforms for Tweaking

```glsl
// ✅ Good - adjustable
uniform float speed = 1.0;

void fragment() {
    COLOR.r = sin(TIME * speed);
}

// ❌ Bad - hardcoded
void fragment() {
    COLOR.r = sin(TIME * 2.5);
}
```

### 2. Optimize Performance

```glsl
// Avoid expensive operations in fragment shader
// Pre-calculate values when possible
// Use textures for complex patterns
```

### 3. Comment Shaders

```glsl
// Water wave effect
// Creates horizontal distortion based on sine wave
uniform float wave_amplitude = 0.02;
```

---

---

## Expert Pattern: Deferred-Fog-Volume

Create localized volumetric effects (caves, toxic clouds) using custom fog shaders that react to real-time lighting.

```glsl
// Custom Localized Fog Shader
shader_type fog;

uniform float base_density : hint_range(0.0, 10.0) = 1.0;
uniform vec3 edge_color : source_color = vec3(0.1, 0.5, 0.8);

void fog() {
    // 1. SDF built-in contains distance to FogVolume surface
    float distance_factor = clamp(-SDF, 0.0, 1.0);
    
    // 2. Smooth density falloff at volume edges
    float edge_fade = pow(distance_factor, 2.0);
    
    // 3. Output to volumetric froxel buffer
    DENSITY = base_density * edge_fade;
    ALBEDO = edge_color;
}
```

---

## Expert Pattern: Compute-Shader-Particles

Simulate massive, high-performance particle systems (boids, fluids) using the `RenderingDevice` API for raw GPGPU processing.

```gdscript
class_name ComputeParticleSim extends Node

var _rd: RenderingDevice
var _pipeline: RID
var _buffer: RID

func _ready() -> void:
    # 1. Initialize RenderingDevice and load GLSL
    _rd = RenderingServer.create_local_rendering_device()
    var shader_file := load("res://particle_sim.glsl") as RDShaderFile
    var shader_rid := _rd.shader_create_from_spirv(shader_file.get_spirv())
    
    # 2. Setup Storage Buffer for particle data
    var data := PackedFloat32Array()
    data.resize(6400) # 6400 particles
    _buffer = _rd.storage_buffer_create(data.size() * 4, data.to_byte_array())
    
    # 3. Create Compute Pipeline and Uniform Set
    var uniform := RDUniform.new()
    uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
    uniform.binding = 0
    uniform.add_id(_buffer)
    
    var uniform_set := _rd.uniform_set_create([uniform], shader_rid, 0)
    _pipeline = _rd.compute_pipeline_create(shader_rid)
    
    # 4. Dispatch (simplified for logic overview)
    var compute_list := _rd.compute_list_begin()
    _rd.compute_list_bind_compute_pipeline(compute_list, _pipeline)
    _rd.compute_list_bind_uniform_set(compute_list, uniform_set, 0)
    _rd.compute_list_dispatch(compute_list, 100, 1, 1) # 100 workgroups * 64
    _rd.compute_list_end()
```

---

## Expert Pattern: Shader-Debug-Visualizer

Diagnostic tool to inspect Depth, Normals, and UVs using a full-screen post-processing quad.

```glsl
shader_type spatial;
render_mode unshaded, fog_disabled;

uniform sampler2D depth_tex : hint_depth_texture;
uniform sampler2D norm_tex : hint_normal_roughness_texture;
uniform int mode : hint_range(0, 2) = 0; // 0: Depth, 1: Normals, 2: UVs

void vertex() {
    POSITION = vec4(VERTEX.xy, 1.0, 1.0); // Full-screen quad
}

void fragment() {
    if (mode == 0) {
        float raw_depth = texture(depth_tex, SCREEN_UV).x;
        // Convert to linear view-space depth
        vec3 ndc = vec3(SCREEN_UV * 2.0 - 1.0, raw_depth);
        vec4 view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
        view.xyz /= view.w;
        ALBEDO = vec3(clamp(-view.z / 100.0, 0.0, 1.0));
    } else if (mode == 1) {
        vec3 norm = texture(norm_tex, SCREEN_UV).xyz * 2.0 - 1.0;
        ALBEDO = (norm * 0.5) + 0.5;
    } else {
        ALBEDO = vec3(SCREEN_UV, 0.0);
    }
}
```

---

## Expert Pattern: Visual-Shader-Extensibility

Extend the Visual Shader editor by creating custom `VisualShaderNodeCustom` classes in GDScript to expose complex math or global functions as reusable nodes.

```gdscript
@tool
class_name VisualShaderNodeCustomMath extends VisualShaderNodeCustom

func _get_name() -> String: return "CustomPhysicsMath"
func _get_category() -> String: return "Custom"
func _get_return_icon_type() -> PortType: return PORT_TYPE_SCALAR

func _get_input_port_count() -> int: return 2
func _get_input_port_name(port: int) -> String: return "in_" + str(port)
func _get_input_port_type(_port: int) -> PortType: return PORT_TYPE_SCALAR

func _get_output_port_count() -> int: return 1
func _get_output_port_name(_port: int) -> String: return "out"
func _get_output_port_type(_port: int) -> PortType: return PORT_TYPE_SCALAR

func _get_code(input_vars: Array[String], output_vars: Array[String], _mode: Shader.Mode, _type: VisualShader.Type) -> String:
    return "%s = %s * (1.0 - %s);" % [output_vars[0], input_vars[0], input_vars[1]]
```

---

## Expert Pattern: Shader-Precompilation-Warmup

Prevent mid-game "shader stutter" by forcing the engine to compile and cache pipelines during a loading screen.

```gdscript
func warmup_shaders(scenes: Array[PackedScene]):
    for scene in scenes:
        var inst = scene.instantiate()
        add_child(inst)
        # Place in front of camera
        inst.position = Vector3(0, 0, -5) 
    
    # Force a single-frame render to populate the pipeline cache
    await RenderingServer.frame_post_draw
    
    # Cleanup
    for child in get_children():
        child.queue_free()
```

## Reference
- [Godot Docs: Shading Language](https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/shading_language.html)
- [Godot Docs: Your First Shader](https://docs.godotengine.org/en/stable/tutorials/shaders/your_first_shader/your_first_2d_shader.html)


### Related
- Master Skill: [godot-master](../SKILL.md)
