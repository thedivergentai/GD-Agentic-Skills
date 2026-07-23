shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled;

## Expert Spectral Shader for downed/ghostly players.
## Simulates a translucent, glowing soul effect.

uniform vec4 ghost_color : source_color = vec4(0.4, 0.8, 1.0, 0.4);
uniform float glow_intensity : hint_range(0.0, 5.0) = 2.0;
uniform float wave_speed : hint_range(0.0, 10.0) = 1.0;

void fragment() {
	// Simple sine wave for "pulsing" soul effect
	float pulse = (sin(TIME * wave_speed) + 1.0) * 0.5;
	
	ALBEDO = ghost_color.rgb;
	ALPHA = ghost_color.a * (0.5 + pulse * 0.5);
	
	// Add emissive glow
	EMISSION = ghost_color.rgb * glow_intensity;
}
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/spatial_shader.html — ALPHA/EMISSION soul pulse
# - https://docs.godotengine.org/en/stable/tutorials/shaders/introduction_to_shaders.html — spatial shader_type basics
# - https://docs.godotengine.org/en/stable/classes/class_shadermaterial.html — assign spectral material at runtime
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md — ghost/emissive patterns
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-materials/SKILL.md — when StandardMaterial3D transparency suffices first
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-mechanic-revival/SKILL.md
# =============================================================================
