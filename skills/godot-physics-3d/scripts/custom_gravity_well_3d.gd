# custom_gravity_well_3d.gd
# 3D Gravity wells and directional overrides via Area3D
extends Area3D

func _ready() -> void:
	# Replace world gravity with point force
	gravity_space_override = Area3D.SPACE_OVERRIDE_REPLACE
	gravity_point = true
	gravity_point_unit_distance = 10.0
	gravity = 20.0 # Force attraction
	
	# For planetary gravity (spherical):
	# gravity_direction = Vector3.ZERO # Point toward center
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html
# - https://docs.godotengine.org/en/stable/classes/class_area3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — Area3D overlap signal ownership
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-world-building/SKILL.md — planetary zones vs level collision layout
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md
# =============================================================================
