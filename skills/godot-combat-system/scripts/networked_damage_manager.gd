# networked_damage_manager.gd
class_name NetworkedDamageManager
extends Node

func request_damage(target: Node, amount: int) -> void:
	if multiplayer.has_multiplayer_peer():
		rpc_id(1, &"server_validate_hit", target.get_path(), amount)

@rpc("any_peer", "call_remote", "reliable")
func server_validate_hit(target_path: NodePath, amount: int) -> void:
	var sender_id := multiplayer.get_remote_sender_id()
	var target_node := get_node_or_null(target_path)

	if is_instance_valid(target_node) and target_node.has_method(&"take_damage"):
		target_node.take_damage(amount)
		rpc_id(sender_id, &"client_confirm_hit", target_path, amount)

@rpc("authority", "call_remote", "reliable")
func client_confirm_hit(target_path: NodePath, amount: int) -> void:
	print_rich("[color=green]Hit confirmed by server.[/color]")
