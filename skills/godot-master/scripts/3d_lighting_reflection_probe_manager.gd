# ReflectionProbe Dynamic Bake Manager
extends ReflectionProbe

## Real-time reflections tank performance. 
## Expert pattern: Trigger an UPDATE_ONCE only when large geometry changes.

func refresh_reflections() -> void:
	# Set to UPDATE_ONCE for performance
	update_mode = UPDATE_ONCE
	interior = true # Optimize for indoor bounding
	
	# Architecture Tip: Use multiple small ReflectionProbes 
	# instead of one massive one for better parallax accuracy.
	box_projection = true
	enable_shadows = false # Shadows in reflections are extremely expensive
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/3d/global_illumination/reflection_probes.html
# - https://docs.godotengine.org/en/stable/classes/class_reflectionprobe.html
# - https://docs.godotengine.org/en/stable/tutorials/3d/environment_and_post_processing.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-materials/SKILL.md — metallic/roughness need probes
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md — probe placement per room
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — Update Once vs Always
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-lighting/SKILL.md
# =============================================================================
