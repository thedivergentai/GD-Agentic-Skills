# depth_world_reconstruction.gdshader
# Reconstructing world-space from depth for localized fog/water [24]
shader_type spatial;
render_mode unshaded;

uniform sampler2D depth_tex : hint_depth_texture;

void fragment() {
	float depth = textureLod(depth_tex, SCREEN_UV, 0.0).r;
	
	// NDC (Normalized Device Coordinates) handle reversed-Z in Godot 4.3 [8]
	vec4 ndc = vec4(SCREEN_UV * 2.0 - 1.0, depth, 1.0);
	
	// Convert NDC back to world coordinates
	vec4 world = INV_VIEW_MATRIX * INV_PROJECTION_MATRIX * ndc;
	vec3 world_pos = world.xyz / world.w;
	
	// Visualize Y-height (useful for checking water depth)
	ALBEDO = vec3(clamp(world_pos.y * 0.1, 0.0, 1.0));
}
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/shaders/advanced_postprocessing.html
# - https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/spatial_shader.html
# - https://docs.godotengine.org/en/stable/tutorials/shaders/custom_postprocessing.html
# Related skills:
# - ../godot-camera-systems/SKILL.md — projection/view matrices for depth unproject
# - ../godot-3d-lighting/SKILL.md — fog/water depth effects paired with lighting
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md
# =============================================================================
