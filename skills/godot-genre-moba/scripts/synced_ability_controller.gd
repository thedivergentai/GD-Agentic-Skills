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
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
# - https://docs.godotengine.org/en/stable/classes/class_multiplayersynchronizer.html
# - https://docs.godotengine.org/en/stable/classes/class_scenereplicationconfig.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md — authoritative cast RPCs
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md — cooldown sync fields
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-moba/SKILL.md
# =============================================================================
