class_name NetInterestManagement
extends Area3D

## Expert Interest Management (Network ROI).
## Toggles node visibility based on proximity to optimize bandwidth.

@export var synchronizer: MultiplayerSynchronizer
@export var cull_distance: float = 50.0

func _physics_process(_delta: float) -> void:
	if not multiplayer.is_server(): return
	
	for peer_id in multiplayer.get_peers():
		var peer_node = get_tree().get_nodes_in_group("Players").filter(func(p): return p.name == str(peer_id))[0]
		var dist = global_position.distance_to(peer_node.global_position)
		
		synchronizer.set_visibility_for(peer_id, dist < cull_distance)

## Rule: Use interest management for large maps to prevent clients from receiving local data for players 1km away.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_multiplayersynchronizer.html
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
# - https://docs.godotengine.org/en/stable/classes/class_scenemultiplayer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-battle-royale/SKILL.md — large-map visibility culling consumers
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — fewer sync targets per peer
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md
# =============================================================================
