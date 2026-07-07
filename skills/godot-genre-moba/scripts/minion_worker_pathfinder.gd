extends Node

## Expert MOBA Pathfinding (Godot 4.7).
## Multi-threaded deterministic minion navigation.

var minion_list: Array[Node3D] = []
var target_pos: Vector3

func _process(_delta: float) -> void:
	if minion_list.is_empty(): return
	
	# Distribute pathfinding across CPU cores
	var task = WorkerThreadPool.add_group_task(_calc_minion_path, minion_list.size())
	WorkerThreadPool.wait_for_group_task_completion(task)

func _calc_minion_path(idx: int) -> void:
	var m = minion_list[idx]
	var map = m.get_world_3d().get_navigation_map()
	var path = NavigationServer3D.map_get_path(map, m.global_position, target_pos, true)
	
	if path.size() > 1:
		m.velocity = m.global_position.direction_to(path[1]) * 5.0

## [SKILL NOTICE]: Disable 'avoidance_enabled' (RVO) for minions 
## to prevent jitter. Use 'WorkerThreadPool' for massive waves.
