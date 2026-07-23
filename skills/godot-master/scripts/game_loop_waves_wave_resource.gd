# wave_resource.gd
# [GDSKILLS] godot-game-loop-waves
# EXPORT_REFERENCE: wave_resource.gd

extends Resource
class_name WaveResource

@export_group("Wave Metadata")
## The name of the wave for UI or logging.
@export var wave_name: String = "New Wave"
## Time in seconds before this wave starts after the previous one cleared.
@export var pre_wave_delay: float = 3.0

@export_group("Spawn Configuration")
## Dictionary of enemy scenes and their counts.
## Key: PackedScene, Value: int
@export var compositions: Dictionary = {}

## The rate at which enemies spawn (enemies per second).
@export var spawn_rate: float = 1.0

## If true, enemies spawn at random points. If false, they rotate through spawners.
@export var random_spawning: bool = true
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/classes/class_resource.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — WaveResource export groups
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — tune compositions without code
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-game-loop-waves/SKILL.md
# =============================================================================
