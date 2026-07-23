# global_grass_flatten.gdshader
# Using GlobalShaderParameters to synchronize world interaction [23]
shader_type spatial;

// Global uniform injected project-wide via RenderingServer
global uniform vec3 player_pos;

void vertex() {
	float dist = distance(VERTEX, player_pos);
	// If player is close, squash the vertex towards the ground
	// mix() + step() is used for branchless optimization [5]
	float flatten_mask = 1.0 - step(1.5, dist);
	VERTEX.y *= mix(1.0, 0.1, flatten_mask);
}
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/spatial_shader.html
# - https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/shading_language.html
# - https://docs.godotengine.org/en/stable/classes/class_shadermaterial.html
# Related skills:
# - ../godot-genre-open-world/SKILL.md — player-driven world interaction FX
# - ../godot-3d-world-building/SKILL.md — grass/prop placement that reads global uniforms
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md
# =============================================================================
