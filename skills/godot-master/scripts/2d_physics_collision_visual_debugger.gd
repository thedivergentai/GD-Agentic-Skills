class_name CollisionVisualDebugger
extends Node2D
## Draw last kinematic contact point + normal for physics tuning.

var _last_collision: KinematicCollision2D

func update_debug_info(collision: KinematicCollision2D) -> void:
	_last_collision = collision
	queue_redraw()

func _draw() -> void:
	if _last_collision == null:
		return
	var hit_pos := to_local(_last_collision.get_position())
	var normal := _last_collision.get_normal()
	draw_circle(hit_pos, 5.0, Color.RED)
	draw_line(hit_pos, hit_pos + normal * 30.0, Color.GREEN, 2.0)

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_kinematiccollision2d.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/troubleshooting_physics_issues.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — visible collision debug workflow
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-2d-physics/SKILL.md
# =============================================================================
