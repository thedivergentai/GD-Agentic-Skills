# dynamic_userdata_modulation.gd
# Passing runtime variables to particle shaders without breaking batching
extends GPUParticles3D

func set_vfx_intensity(intensity: float) -> void:
	# USERDATA variables (1-4) are designed for per-instance scripting [35].
	# This avoids duplicating the entire ShaderMaterial for every emitter.
	if process_material is ShaderMaterial:
		# Pack data into Vector4. x = intensity, y = spare, etc.
		process_material.set_shader_parameter("USERDATA1", Vector4(intensity, 0, 0, 0))
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/particle_shader.html
# - https://docs.godotengine.org/en/stable/classes/class_gpuparticles3d.html
# - https://docs.godotengine.org/en/stable/classes/class_shadermaterial.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md — USERDATA uniforms without duplicating ShaderMaterials
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — preserve GPU batching across emitter instances
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md
# =============================================================================
