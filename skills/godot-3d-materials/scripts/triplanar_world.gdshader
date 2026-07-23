// skills/3d-materials/code/triplanar_world.gdshader
shader_type ruby; // Using Ruby syntax highlighting as a placeholder for GDShader if needed, but the extension will be .gdshader
shader_type spatial;

## World-Aligned Triplanar Expert shader
## Perfect for terrain, caves, or architectural meshes.

uniform sampler2D wall_texture : source_color;
uniform float uv_scale = 1.0;

varying vec3 world_pos;
varying vec3 world_normal;

void vertex() {
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
    world_normal = abs(NORMAL);
}

void fragment() {
    // 1. Calculate triplanar blending weights
    vec3 blending = world_normal;
    blending /= (blending.x + blending.y + blending.z);
    
    // 2. Project textures on 3 axes
    vec3 x_tex = texture(wall_texture, world_pos.zy * uv_scale).rgb;
    vec3 y_tex = texture(wall_texture, world_pos.xz * uv_scale).rgb;
    vec3 z_tex = texture(wall_texture, world_pos.xy * uv_scale).rgb;
    
    // 3. Blend based on normal direction
    ALBEDO = x_tex * blending.x + y_tex * blending.y + z_tex * blending.z;
}
// =============================================================================
// GDSkills research links (agents) — does not affect runtime
// Official docs:
// - https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/spatial_shader.html
// - https://docs.godotengine.org/en/stable/tutorials/shaders/your_first_shader/your_first_3d_shader.html
// - https://docs.godotengine.org/en/stable/tutorials/3d/standard_material_3d.html
// Related skills:
// - ../godot-shaders-basics/SKILL.md — spatial shader workflow
// - ../godot-procedural-generation/SKILL.md — UV-less procedural meshes
// Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-materials/SKILL.md
// =============================================================================
