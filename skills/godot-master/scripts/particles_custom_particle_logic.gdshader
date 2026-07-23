# custom_particle_logic.gdshader
# Expert procedural particle logic using custom shaders
shader_type particles;

// Use USERDATA to pass per-instance data without breaking batching [35]
uniform vec4 USERDATA1; 

void start() {
	// CUSTOM.x: Random phase
	// CUSTOM.y: Persistent velocity scale
	CUSTOM.x = rand_from_seed(RANDOM_SEED);
	CUSTOM.y = 1.0 + rand_from_seed(RANDOM_SEED) * 0.5;
}

void process() {
	float phase = CUSTOM.x * 6.28318;
	float time = TIME * CUSTOM.y;
	
	// Procedural orbit/spiral logic
	VELOCITY.x += cos(time + phase) * DELTA * 10.0;
	VELOCITY.z += sin(time + phase) * DELTA * 10.0;
	
	// Apply dynamic wind intensity passed from GDScript via USERDATA
	float wind = USERDATA1.x;
	VELOCITY.x += wind * DELTA;
}
// =============================================================================
// GDSkills research links (agents) — does not affect runtime
// Official docs:
// - https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/particle_shader.html
// - https://docs.godotengine.org/en/stable/tutorials/3d/particles/process_material_properties.html
// - https://docs.godotengine.org/en/stable/classes/class_gpuparticles3d.html
// Related skills:
// - ../godot-shaders-basics/SKILL.md — CUSTOM/USERDATA particle process shaders
// - ../godot-performance-optimization/SKILL.md — GPU orbit/wind without per-particle CPU
// Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md
// =============================================================================
