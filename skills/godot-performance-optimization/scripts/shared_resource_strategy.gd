# shared_resource_strategy.gd
# Using Local-To-Scene vs Shared resources
extends Sprite2D

# EXPERT NOTE: By default, Resources are shared. If you change 
# a property in one instance, it changes for all. Toggle 
# "Local to Scene" for unique instances or use .duplicate() 
# for performance-balanced unique states.

@export var data: Resource

func _ready():
	# If we need a unique instance for this node:
	if not data.resource_local_to_scene:
		data = data.duplicate()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/performance/cpu_optimization.html
# - https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — local-to-scene vs shared ownership rules
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — packed scenes that share materials/meshes
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md
# =============================================================================
