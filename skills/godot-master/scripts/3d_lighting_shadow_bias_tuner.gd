# Directional Light Shadow Bias Tuner
extends DirectionalLight3D

## Prevents 'Peter Panning' (shadows detached from feet)
## and 'Shadow Acne' (striped artifacts on surfaces).

func optimize_shadow_physics() -> void:
	# Bias depends on cascade split distances. 
	# Too high = Peter Panning. Too low = Shadow Acne.
	shadow_bias = 0.05 
	
	# Normal bias pushes the shadow caster depth along normals.
	# Fixes acne on flat slopes.
	shadow_normal_bias = 2.0
	
	# Transmittance bias for SSS materials
	shadow_transmittance_bias = 0.05
	
	# Architecture Tip: Use Contact Test to close small gaps at contact points.
	shadow_blur = 1.0
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/3d/lights_and_shadows.html
# - https://docs.godotengine.org/en/stable/classes/class_light3d.html
# - https://docs.godotengine.org/en/stable/classes/class_directionallight3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — spot Peter Panning visually
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md — scene scale informs bias
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — soft shadow filter quality
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-lighting/SKILL.md
# =============================================================================
