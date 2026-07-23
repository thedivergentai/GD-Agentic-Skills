# deep_stat_duplicator.gd
# Preventing resource leakage across shared templates
extends Node

# EXPERT NOTE: Resources are shared by reference. 
# You MUST duplicate() them to avoid global state pollution.

@export var template_stats: BaseStats

var current_stats: BaseStats

func _ready():
	# EXPERT: Deep duplicate ensures this instance has its own health/buffs
	current_stats = template_stats.duplicate()

func apply_poison():
	# Only affects this specific instance
	current_stats.max_health -= 5
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_resource.html — duplicate() before mutate
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html — shared Resource references
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — template vs instance Resources
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md — per-entity buff mutation
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-action-rpg/SKILL.md
# =============================================================================
