# foliage_wind_sway_expert.gdshader
# High-performance GPU-driven wind sway with world-space uniformity [19]
shader_type spatial;
render_mode depth_prepass_alpha, world_vertex_coords;

uniform float wind_speed = 1.0;
uniform float wind_strength = 0.1;

void vertex() {
	// Use VERTEX.y or Vertex Color (RED) to mask the base of the plant
	// COLOR.r should be 0.0 at the ground and 1.0 at the tips.
	float strength = COLOR.r * wind_strength;
	
	float time = TIME * wind_speed;
	// Multi-frequency sine for organic movement
	VERTEX.x += sin(time + VERTEX.x * 0.5) * strength;
	VERTEX.z += cos(time * 0.8 + VERTEX.z * 0.4) * strength;
}
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/spatial_shader.html
# - https://docs.godotengine.org/en/stable/tutorials/shaders/making_trees.html
# - https://docs.godotengine.org/en/stable/classes/class_geometryinstance3d.html
# Related skills:
# - ../godot-3d-world-building/SKILL.md — foliage placement and environment LODs
# - ../godot-genre-open-world/SKILL.md — large-world vegetation sway at scale
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md
# =============================================================================
