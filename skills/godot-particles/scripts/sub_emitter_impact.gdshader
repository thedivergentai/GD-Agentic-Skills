# sub_emitter_impact.gdshader
# Triggering sub-emitters on collision for splashes or debris
shader_type particles;

void process() {
	if (COLLIDED) {
		mat4 sub_transform = TRANSFORM;
		// Offset slightly from collision point using normal
		sub_transform[3].xyz += COLLISION_NORMAL * 0.05;
		
		// Spawn sub-particles (debris/splash)
		// Only emit if sub-emitter is assigned to the material
		emit_subparticle(sub_transform, 
			REFLECTED_VELOCITY * 0.4, 
			vec4(1.0), 
			vec4(1.0), 
			FLAG_EMIT_POSITION | FLAG_EMIT_VELOCITY);
			
		// Kill parent particle on impact
		ACTIVE = false;
	}
}
// =============================================================================
// GDSkills research links (agents) — does not affect runtime
// Official docs:
// - https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/particle_shader.html
// - https://docs.godotengine.org/en/stable/tutorials/3d/particles/subemitters.html
// - https://docs.godotengine.org/en/stable/tutorials/3d/particles/collision.html
// Related skills:
// - ../godot-combat-system/SKILL.md — splash/debris sub-emitters on impact
// - ../godot-audio-systems/SKILL.md — GPU collision limits vs looped impact SFX
// Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md
// =============================================================================
