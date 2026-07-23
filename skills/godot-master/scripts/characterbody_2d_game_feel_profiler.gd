extends Node2D
class_name GameFeelProfiler

## Debug-draw jump arcs and velocity vectors while tuning expert_physics_2d exports.

@export var character: CharacterBody2D
var _points: PackedVector2Array = []


func _process(_delta: float) -> void:
	if character == null:
		return
	_points.append(character.global_position - global_position)
	if _points.size() > 100:
		_points.remove_at(0)
	queue_redraw()


func _draw() -> void:
	if _points.size() < 2:
		return
	draw_polyline(_points, Color.CYAN, 2.0, true)
	draw_line(_points[-1], _points[-1] + character.velocity * 0.1, Color.YELLOW, 3.0)
# ---
# GDSkills research links (agents)
# Related:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-characterbody-2d/scripts/expert_physics_2d.gd — tune coyote/buffer against visualized apex
# ---
