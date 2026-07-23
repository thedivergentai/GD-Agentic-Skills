# instance_uniform_hitflash.gdshader
# High-performance hit flash using instance uniforms for batching [10]
shader_type spatial;

// Instance uniforms allow thousands of nodes to have unique flash states
// while sharing a single draw call (batching).
instance uniform float hit_flash_intensity : hint_range(0.0, 1.0) = 0.0;
uniform vec3 tint_color : source_color = vec3(1.0, 1.0, 1.0);

void fragment() {
	// Blend base color with hit flash color based on the instance parameter
	ALBEDO = mix(ALBEDO, tint_color, hit_flash_intensity);
	// Optional: add a tiny bit of emission for the flash
	EMISSION = tint_color * hit_flash_intensity * 0.5;
}
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/spatial_shader.html
# - https://docs.godotengine.org/en/stable/classes/class_geometryinstance3d.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/gpu_optimization.html
# Related skills:
# - ../godot-performance-optimization/SKILL.md — shared-material batching at scale
# - ../godot-3d-materials/SKILL.md — instance shader parameters without unique mats
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md
# =============================================================================
