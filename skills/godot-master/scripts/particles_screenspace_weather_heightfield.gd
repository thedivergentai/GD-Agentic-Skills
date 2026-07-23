# screenspace_weather_heightfield.gd
# Optimizing global rain/snow using Camera-following HeightFields [46]
extends GPUParticlesCollisionHeightField3D

func _ready() -> void:
	# Snaps the collision texture to follow the active Camera
	follow_camera_enabled = true
	
	# Optimization: only update depth when camera shifts [48]
	update_mode = GPUParticlesCollisionHeightField3D.UPDATE_MODE_WHEN_MOVED
	
	# High resolution (1024) for accurate collisions in open scenes
	resolution = GPUParticlesCollisionHeightField3D.RESOLUTION_1024
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/3d/particles/collision.html
# - https://docs.godotengine.org/en/stable/classes/class_gpuparticlescollisionheightfield3d.html
# - https://docs.godotengine.org/en/stable/tutorials/3d/particles/creating_a_3d_particle_system.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md — follow_camera_enabled weather collision volumes
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md — outdoor rain/snow against terrain height
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md
# =============================================================================
