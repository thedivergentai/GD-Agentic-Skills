# particle_lod_manager.gd
# Managing culling and fading for massive environmental VFX counts
extends GPUParticles3D

func setup_lod_ranges(max_dist: float) -> void:
	# Use GeometryInstance3D Visibility Ranges [52]
	# This COMPLETELY stops particle processing when out of range.
	visibility_range_begin = 0.0
	visibility_range_end = max_dist
	
	# Smoothly dither particles out at a distance (Alpha Hash / Dither) [54]
	visibility_range_end_margin = max_dist * 0.1
	visibility_range_fade_mode = GeometryInstance3D.VISIBILITY_RANGE_FADE_SELF
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/3d/visibility_ranges.html
# - https://docs.godotengine.org/en/stable/classes/class_geometryinstance3d.html
# - https://docs.godotengine.org/en/stable/tutorials/3d/particles/properties.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — distance culling environmental torches/fires
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md — range thresholds relative to active camera
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md
# =============================================================================
