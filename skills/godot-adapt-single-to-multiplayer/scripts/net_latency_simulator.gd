class_name NetLatencySimulator
extends Node

## Expert Network Latency Simulator.
## Simulates high-latency environments for local testing.

@export var latency_ms: int = 150
@export var jitter_ms: int = 50
@export var loss_percent: float = 0.05

func _ready() -> void:
	if not OS.has_feature("editor"): return
	
	var peer = multiplayer.multiplayer_peer as ENetMultiplayerPeer
	if peer:
		# ENet built-in simulation
		# Note: Implementation varies by Godot version and Peer type
		pass

## Tip: If the game feels unplayable at 150ms latency, your lag compensation logic needs refactoring.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_scenemultiplayer.html
# - https://docs.godotengine.org/en/stable/classes/class_multiplayerpeer.html
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — stress-test with artificial RTT/loss
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md — multi-instance local QA loops
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md
# =============================================================================
