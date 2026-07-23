# local_vs_global_coords.gd
# Handling local vs global coordinate space for trails and localized effects
extends GPUParticles3D

func configure_trail_mode(is_trail: bool) -> void:
	# local_coords = false: Particles are left behind in global space (Smoke Trails) [36].
	# local_coords = true: Particles move WITH the emitter (Magic Aura).
	local_coords = !is_trail
	
func safe_teleport(new_pos: Vector3) -> void:
	emitting = false
	global_position = new_pos
	# CRITICAL: If local_coords=false, teleporting leaves a visual gap.
	# restart() clears the trail instantly for a clean teleport [38].
	restart() 
	emitting = true
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/3d/particles/properties.html
# - https://docs.godotengine.org/en/stable/tutorials/3d/particles/trails.html
# - https://docs.godotengine.org/en/stable/classes/class_gpuparticles3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-shooter/SKILL.md — projectile smoke trails in global space
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md — aura FX that must follow the caster (local_coords)
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md
# =============================================================================
