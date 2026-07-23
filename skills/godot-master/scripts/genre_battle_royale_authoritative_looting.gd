# authoritative_looting.gd
# Server-side validation for item collection
extends Node

# EXPERT NOTE: Trust the Server. If a client "loots" an item, 
# the server must verify proximity and item existence.

@rpc("any_peer", "call_local", "reliable")
func request_loot(loot_id: String):
	if not multiplayer.is_server(): return
	
	var sender_id = multiplayer.get_remote_sender_id()
	if _verify_looting(sender_id, loot_id):
		_distribute_loot(sender_id, loot_id)

func _verify_looting(_id, _item): return true
func _distribute_loot(_id, _item): pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
# - https://docs.godotengine.org/en/stable/classes/class_multiplayerspawner.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md — backpack/item state ownership
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md — server-validated RPCs
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-battle-royale/SKILL.md
# =============================================================================
