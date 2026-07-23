# screenspace_full_quad.gdshader
# Correct Godot 4.3 Reversed-Z Full-Screen Quad setup [8]
shader_type spatial;
render_mode unshaded, skip_vertex_transform;

void vertex() {
	// Reverse-Z fix: ensure the quad is at the correct depth [9]
	// Using 1.0 for Z ensures it's at the far plane in reversed-Z
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
	// Perform post-processing logic here...
	ALBEDO = vec3(SCREEN_UV, 0.5);
}
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/shaders/advanced_postprocessing.html
# - https://docs.godotengine.org/en/stable/tutorials/shaders/custom_postprocessing.html
# - https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/spatial_shader.html
# Related skills:
# - ../godot-camera-systems/SKILL.md — full-screen pass camera/compositor setup
# - ../godot-debugging-profiling/SKILL.md — debug visualizer quads for depth/normals
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md
# =============================================================================
