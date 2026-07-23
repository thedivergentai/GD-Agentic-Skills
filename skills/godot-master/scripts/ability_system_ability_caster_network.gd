extends Node
class_name AbilityCasterNetwork

## Multiplayer cast shell: predict locally, authority validates resources, rollback on reject.

@rpc("any_peer", "call_remote", "reliable")
func server_request_cast(target_pos: Vector3) -> void:
	var sender_id := multiplayer.get_remote_sender_id()
	if _has_sufficient_resources():
		_consume_resources()
		rpc("client_execute_cast", target_pos)
	else:
		rpc_id(sender_id, "client_cancel_cast")


@rpc("authority", "call_remote", "reliable")
func client_execute_cast(target_pos: Vector3) -> void:
	if not is_multiplayer_authority():
		_play_cast_animation()
	_spawn_projectile_at(target_pos)


@rpc("authority", "call_remote", "reliable")
func client_cancel_cast() -> void:
	_cancel_cast_animation()


func _has_sufficient_resources() -> bool:
	return true


func _consume_resources() -> void:
	pass


func _play_cast_animation() -> void:
	pass


func _spawn_projectile_at(_target_pos: Vector3) -> void:
	pass


func _cancel_cast_animation() -> void:
	pass
# ---
# GDSkills research links (agents)
# Docs:
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html — RPC authority patterns
# Related:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md — lag compensation
# ---
