# shapecast_ground_detection.gd
# Using ShapeCast3D for robust footing detection
extends ShapeCast3D

# EXPERT NOTE: Raycasts are thin and can miss corners. 
# Shapecasts use a volume (Circle/Box) to detect footing reliably.

func is_on_solid_ground() -> bool:
	# Ensure the shapecast is updated even if physics frame hasn't finished
	force_shapecast_update()
	return is_colliding()

func get_ground_normal() -> Vector3:
	if is_colliding():
		# Get the normal of the first contact point
		return get_collision_normal(0)
	return Vector3.UP
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_shapecast3d.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md — footing/ledge feel from volume casts
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md — 3D ground collision layers
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-raycasting-queries/SKILL.md
# =============================================================================
