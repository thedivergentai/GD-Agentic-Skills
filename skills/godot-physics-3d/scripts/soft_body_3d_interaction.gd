# soft_body_3d_interaction.gd
# Expert configuration for SoftBody3D (Flags, Cloaks, Foliage)
extends SoftBody3D

# EXPERT NOTE: Soft bodies are CPU heavy. Use them sparingly 
# and use 'Simulation Precision' sparingly.

func attach_to_point(path: NodePath, bone: String = ""):
	# Attaching a flag to a flagpole or character bone
	var pin_point = 0 # Vertex index
	set_point_pinned(pin_point, true)
	# Logic usually involves Editor configuration, but scriptable for dynamic spawn
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/soft_body.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/using_jolt_physics.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — soft-body CPU cost and tick-rate tradeoffs
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-animation-tree-mastery/SKILL.md — pinned cloth on animated characters
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md
# =============================================================================
