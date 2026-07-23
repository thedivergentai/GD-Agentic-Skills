# Instance Uniform Shader Batching (+ texture-array variants)
shader_type spatial;

## One material shared by thousands of meshes: per-instance color/health
## and optional texture-array index (forest/crowd variants) without unique .tres.

uniform sampler2D texture_array[4];
instance uniform vec4 instance_color : source_color = vec4(1.0);
instance uniform float health_ratio = 1.0;
instance uniform int texture_index;

void fragment() {
	vec4 tex_color;
	switch (texture_index) {
		case 0: tex_color = texture(texture_array[0], UV); break;
		case 1: tex_color = texture(texture_array[1], UV); break;
		case 2: tex_color = texture(texture_array[2], UV); break;
		default: tex_color = texture(texture_array[3], UV); break;
	}
	ALBEDO = tex_color.rgb * instance_color.rgb * health_ratio;
	// GDScript: mesh.set_instance_shader_parameter(&"texture_index", i)
	// Never duplicate the ShaderMaterial per variant — that breaks batching.
}
// =============================================================================
// GDSkills research links (agents) — does not affect runtime
// Official docs:
// - https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/spatial_shader.html
// - https://docs.godotengine.org/en/stable/classes/class_geometryinstance3d.html
// - https://docs.godotengine.org/en/stable/tutorials/performance/gpu_optimization.html
// Related skills:
// - ../godot-performance-optimization/SKILL.md — shared-material batching at scale
// - ../godot-shaders-basics/SKILL.md — instance uniforms in spatial shaders
// Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-materials/SKILL.md
// =============================================================================
