class_name NetAdaptiveSyncThrottle
extends Node

## Expert Adaptive Sync Throttle.
## Reduces update frequency for peers with poor RTT or packet loss.

@export var base_sync_hz: int = 20
var active_sync_hz: int = 20

func update_throttle(current_rtt: int) -> void:
	if current_rtt > 200:
		active_sync_hz = 10 # Half rate for laggy peers
	elif current_rtt > 100:
		active_sync_hz = 15
	else:
		active_sync_hz = base_sync_hz

## Tip: Throttling bandwidth for laggy peers prevents them from 'clogging' the server's upload pipe.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_multiplayersynchronizer.html
# - https://docs.godotengine.org/en/stable/classes/class_multiplayerpeer.html
# - https://docs.godotengine.org/en/stable/classes/class_scenereplicationconfig.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — Hz caps when peers degrade
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure RTT before throttling
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md
# =============================================================================
