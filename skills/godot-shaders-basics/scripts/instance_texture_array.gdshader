# instance_texture_array.gdshader
# Selecting unique textures in a batch using TextureArrays and Instance Uniforms [28]
shader_type spatial;

// Regular uniform array (shared by all batched instances)
uniform sampler2DArray textures_collection : source_color;

// Instance-specific index (unique per node, but maintains batching)
instance uniform int texture_variant_index = 0;

void fragment() {
	// Use the instance index to pick a layer from the array
	ALBEDO = texture(textures_collection, vec3(UV, float(texture_variant_index))).rgb;
}
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/spatial_shader.html
# - https://docs.godotengine.org/en/stable/classes/class_geometryinstance3d.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/gpu_optimization.html
# Related skills:
# - ../godot-performance-optimization/SKILL.md — texture arrays + instance uniforms for batching
# - ../godot-resource-data-patterns/SKILL.md — shared Texture2DArray assets
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md
# =============================================================================
