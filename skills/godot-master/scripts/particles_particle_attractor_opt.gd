# particle_attractor_opt.gd
# Isolating particle interactions using cull_mask/layers
extends GPUParticles3D

func setup_isolated_attractor(attractor: GPUParticlesAttractorSphere3D) -> void:
	# Optimization: ONLY interact with particles on specific layers [24, 25]
	# Layer 2 = (1 << 1). Prevents thousands of global particles from checking this attractor.
	var specific_layer = (1 << 1)
	
	attractor.cull_mask = specific_layer
	
	# Ensure the particle system itself is on the matching layer
	# GeometryInstance3D.layers is used for particle interaction masking [26]
	self.layers = specific_layer
	
	# Enable interaction in the material
	if process_material is ParticleProcessMaterial:
		process_material.attractor_interaction_enabled = true
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/3d/particles/attractors.html
# - https://docs.godotengine.org/en/stable/classes/class_gpuparticlesattractor3d.html
# - https://docs.godotengine.org/en/stable/tutorials/3d/particles/process_material_properties.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — cull_mask isolation vs global attractor cost
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md — layered environmental VFX zones
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md
# =============================================================================
