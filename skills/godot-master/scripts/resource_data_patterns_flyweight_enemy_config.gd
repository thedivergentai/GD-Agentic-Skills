# flyweight_enemy_config.gd
# Using Resources to configure many entities efficiently
extends CharacterBody2D

# EXPERT NOTE: Instead of exporting 20 variables, export 1 Resource.
# This makes swapping "Normal" for "Elite" enemy stats instant.

@export var config: EnemyConfigResource

func _ready():
	if config:
		$Sprite3D.texture = config.skin
		$HealthComponent.max_health = config.hp
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/data_preferences.html
# - https://docs.godotengine.org/en/stable/classes/class_resource.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — one config Resource for many entity instances
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — enemy HP/speed knobs as .tres data
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md
# =============================================================================
