# shapecast_aoe_detection.gd
# Using ShapeCast2D for robust area-of-effect detection [Ray vs Shape]
extends ShapeCast2D

# EXPERT NOTE: RayCasts are pins. ShapeCasts are volumes. 
# Use ShapeCast2D for ground detection or melee swings to 
# prevent "skinny" collisions from missing targets.

func check_grounded() -> bool:
	# A CircleShape2D cast downwards is more stable for slopes
	# than a single RayCast2D.
	force_shapecast_update()
	return is_colliding()

func get_all_targets() -> Array:
	var hits = []
	for i in range(get_collision_count()):
		hits.append(get_collider(i))
	return hits

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_shapecast2d.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — melee swing volume hits
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/SKILL.md — ground/ledge volume sensing
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md
# =============================================================================
