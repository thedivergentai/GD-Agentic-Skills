class_name CollectionCompass
extends Sprite2D

## Compass HUD: points at the nearest item_id the manager still lists as remaining.
## Does not scan all live group nodes — collected IDs are excluded via manager truth.

@export var collection_manager: CollectionManager
@export var collection_id: String = "easter_egg"
@export var search_group: StringName = &"collectible"
@export var rotation_speed: float = 10.0
@export var player: Node

var target_collectible: Node


func _process(delta: float) -> void:
	if not is_instance_valid(target_collectible) or not _is_remaining_target(target_collectible):
		target_collectible = _find_nearest_collectible()

	if is_instance_valid(target_collectible):
		var target_pos := _get_node_world_position(target_collectible)
		var angle_to_target := get_angle_to(target_pos)
		rotation += angle_to_target * rotation_speed * delta


func _find_nearest_collectible() -> Node:
	if not collection_manager:
		return null

	var remaining := collection_manager.get_remaining_ids(collection_id)
	if remaining.is_empty():
		return null

	var origin := _get_compass_origin()
	var nearest: Node = null
	var min_dist := INF

	for node in get_tree().get_nodes_in_group(search_group):
		if not node is CollectibleItem:
			continue
		var item := node as CollectibleItem
		if item.item_id not in remaining:
			continue

		var dist := origin.distance_to(_get_node_world_position(node))
		if dist < min_dist:
			min_dist = dist
			nearest = node

	return nearest


func _is_remaining_target(node: Node) -> bool:
	if not collection_manager or not node is CollectibleItem:
		return false
	var item := node as CollectibleItem
	return item.item_id in collection_manager.get_remaining_ids(collection_id)


func _get_compass_origin() -> Vector2:
	if is_instance_valid(player):
		return _get_node_world_position(player)
	return global_position


func _get_node_world_position(node: Node) -> Vector2:
	if node is Node2D:
		return node.global_position
	if node is Node3D:
		var pos := (node as Node3D).global_position
		return Vector2(pos.x, pos.z)
	return Vector2.ZERO

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/math/vector_math.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/groups.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — host compass HUD in Control layouts
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md — compass orientation relative to player/camera
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-game-loop-collection/SKILL.md
# =============================================================================
