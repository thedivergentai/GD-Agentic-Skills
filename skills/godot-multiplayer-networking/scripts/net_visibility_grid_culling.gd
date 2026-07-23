class_name NetVisibilityGridCulling
extends Node

## Expert Visibility Grid Culling (Interest Management).
## Only replicates objects within relevant spatial sectors.

@export var grid_size: int = 64
var player_sectors: Dictionary = {} # PeerID: Vector2i

func update_interest(peer_id: int, pos: Vector3) -> void:
	var sector = Vector2i(pos.x / grid_size, pos.z / grid_size)
	if player_sectors.get(peer_id) != sector:
		player_sectors[peer_id] = sector
		# Re-calculate visibility set for this peer...

## Tip: Interest management is mandatory for 'Open World' or 64+ player multiplayer games.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_multiplayersynchronizer.html
# - https://docs.godotengine.org/en/stable/classes/class_scenemultiplayer.html
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — interest management at scale
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-battle-royale/SKILL.md — large-world visibility budgets
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md
# =============================================================================
