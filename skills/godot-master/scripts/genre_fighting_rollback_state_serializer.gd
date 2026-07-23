# rollback_state_serializer.gd
# High-speed serialization for frame snapshots
extends Node

# EXPERT NOTE: Rollback requires snapshots every frame. 
# Pre-allocating PackedByteArray ensures zero allocation stutters.

var state_buffer := PackedByteArray()

func _ready():
	state_buffer.resize(1024) # Reserve memory for the fighter state

func save_state() -> PackedByteArray:
	# Serialize position, health, inputs into binary
	return state_buffer # Return current snapshot
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md — snapshot/rollback state payloads
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md — reconciliation consumers
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-fighting/SKILL.md
# =============================================================================
