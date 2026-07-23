# massive_swarm_multimesh.gd
# Managing millions of particles via MultiMeshInstance3D with interpolation [32]
extends MultiMeshInstance3D

func _ready() -> void:
	# Set high-speed interpolation for massive counts
	multimesh.physics_interpolation_quality = MultiMesh.MULTIMESH_INTERP_QUALITY_FAST

func submit_interpolated_swarm(current_data: PackedFloat32Array, previous_data: PackedFloat32Array) -> void:
	# Essential for smooth movement at high particle counts:
	# Submission of both buffers allows the engine to jitter-free interpolate 
	# between physics ticks even if the frame rate is higher than physics.
	multimesh.set_buffer_interpolated(current_data, previous_data)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/performance/using_multimesh.html
# - https://docs.godotengine.org/en/stable/classes/class_multimesh.html
# - https://docs.godotengine.org/en/stable/classes/class_multimeshinstance3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — MultiMesh cutover when GPUParticles amount ceilings fail
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-procedural-generation/SKILL.md — dense swarm/fish/insect instance buffers
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md
# =============================================================================
