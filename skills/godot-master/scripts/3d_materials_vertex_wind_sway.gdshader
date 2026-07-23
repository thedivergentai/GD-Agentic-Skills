# High-Performance GPU Wind Sway
shader_type spatial;

## Expert level vertex sway. No bone overhead.
## Uses vertex colors (REd channel) as depth weight for foliage.

render_mode depth_prepass_alpha, cull_disabled, world_vertex_coords;

uniform sampler2D texture_albedo : source_color;
uniform float sway_speed = 1.0;
uniform float sway_strength = 0.05;

void vertex() {
    // Weight derived from vertex painting
    float weight = COLOR.r;
    float time_offset = TIME * sway_speed + VERTEX.x + VERTEX.z;
    
    VERTEX.x += sin(time_offset) * sway_strength * weight;
    VERTEX.z += cos(time_offset) * sway_strength * weight;
}

void fragment() {
    vec4 albedo_tex = texture(texture_albedo, UV);
    ALBEDO = albedo_tex.rgb;
    ALPHA = albedo_tex.a;
    ALPHA_SCISSOR_THRESHOLD = 0.5;
}
// =============================================================================
// GDSkills research links (agents) — does not affect runtime
// Official docs:
// - https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/spatial_shader.html
// - https://docs.godotengine.org/en/stable/tutorials/shaders/your_first_shader/your_first_3d_shader.html
// - https://docs.godotengine.org/en/stable/classes/class_geometryinstance3d.html
// Related skills:
// - ../godot-shaders-basics/SKILL.md — vertex displacement patterns
// - ../godot-3d-world-building/SKILL.md — foliage/environment placement
// Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-materials/SKILL.md
// =============================================================================
