extends CharacterBody3D

## Expert MOBA Cooldown Sync (Godot 4.7).
## Server Authority + Client Prediction.

@export var current_cooldown: float = 0.0 # Synced via MultiplayerSynchronizer
@export var max_cooldown: float = 5.0

func _process(delta: float) -> void:
	if current_cooldown > 0.0:
		current_cooldown = maxf(0.0, current_cooldown - delta)

func cast_ability() -> void:
	if current_cooldown == 0.0:
		# Client Prediction: Instant visual feedback
		current_cooldown = max_cooldown
		# Request authoritative cast
		_server_cast.rpc_id(1)

@rpc("any_peer", "call_remote", "reliable")
func _server_cast() -> void:
	if not multiplayer.is_server(): return
	if current_cooldown <= 0.0:
		current_cooldown = max_cooldown
		# Spawn ability projectile/effect here
		
## [SKILL NOTICE]: Always use 'MultiplayerSynchronizer' to 
## replicate 'current_cooldown' property from server to peers.
