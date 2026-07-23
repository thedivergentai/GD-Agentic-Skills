class_name NetCustomIDMapper
extends Node

## Expert ID Mapping.
## Maps persistent DB UserIDs to ephemeral Network PeerIDs.

var peer_to_user: Dictionary = {}
var user_to_peer: Dictionary = {}

func register_player(peer_id: int, user_id: String) -> void:
	peer_to_user[peer_id] = user_id
	user_to_peer[user_id] = peer_id

func get_peer(user_id: String) -> int:
	return user_to_peer.get(user_id, -1)

## Rule: PeerIDs change on every reconnect; UserIDs are permanent. Mapping is mandatory.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_multiplayerapi.html
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
# - https://docs.godotengine.org/en/stable/classes/class_multiplayerpeer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — durable UserIDs vs ephemeral PeerIDs
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — session Autoload owns ID maps
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md
# =============================================================================
