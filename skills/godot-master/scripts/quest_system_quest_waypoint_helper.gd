# quest_waypoint_helper.gd
extends Node3D
class_name QuestWaypointHelper

## Updates NavigationAgent target when objectives change — not every frame.

@export var navigation_agent: NavigationAgent3D

func set_objective_position(target_pos: Vector3) -> void:
	if navigation_agent:
		navigation_agent.target_position = target_pos


func get_next_path_corner() -> Vector3:
	if not navigation_agent or navigation_agent.is_navigation_finished():
		return global_position
	return navigation_agent.get_next_path_position()
