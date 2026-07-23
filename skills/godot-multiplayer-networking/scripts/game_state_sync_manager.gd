# game_state_sync_manager.gd
# Master clock synchronization
extends Node

# EXPERT NOTE: Synchronizing game time between server and 
# clients is critical for deterministic physics or effects.

var server_time: float = 0.0

@rpc("authority", "call_remote", "unreliable")
func sync_time(time: float):
	server_time = time
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_scenemultiplayer.html
# - https://docs.godotengine.org/en/stable/classes/class_multiplayerapi.html
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-server-architecture/SKILL.md — authoritative clock on dedicated host
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — keep sync across scene swaps
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md
# =============================================================================
