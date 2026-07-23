extends Node3D
class_name NPCScheduleAgent

## Expert NPC Scheduling (Godot 4.7).
## Responds to TimeManager signals and uses NavigationServer for paths.

var schedule: Dictionary = { 8: Vector3(10, 0, 5), 18: Vector3(0, 0, 0) }
var active_path: PackedVector3Array = []

func _ready() -> void:
	# Expects a Global TimeManager with a 'hour_passed(h)' signal
	if get_node_or_null("/root/TimeManager"):
		get_node("/root/TimeManager").hour_passed.connect(_on_hour_passed)

func _on_hour_passed(hour: int) -> void:
	if schedule.has(hour):
		_recalculate_path(schedule[hour])

func _recalculate_path(target_pos: Vector3) -> void:
	var map = get_world_3d().get_navigation_map()
	# Expert Pattern: Query NavServer directly to avoid NavAgent node overhead
	active_path = NavigationServer3D.map_get_path(map, global_position, target_pos, true)

## [SKILL NOTICE]: Connect NPCs to a central TimeManager signal 
## to trigger schedule updates without polling every frame.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationservers.html
# - https://docs.godotengine.org/en/stable/classes/class_navigationserver3d.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md — map_get_path and agent budgets
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — hour_passed schedule triggers
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-simulation/SKILL.md
# =============================================================================
