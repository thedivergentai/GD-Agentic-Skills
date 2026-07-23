# resource_local_to_scene.gd
# Creating unique resource instances per node
extends Node

# EXPERT NOTE: If you modify a Resource's property at runtime, 
# it affects EVERY node using it. Turn on "Local to Scene" or 
# call duplicate() to prevent cross-contamination.

@export var stats: ItemData

func _ready():
	# Create a unique copy so our changes don't affect other entities
	stats = stats.duplicate()
	stats.base_value += 5 # Safe modification
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/classes/class_resource.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — per-instance Resource ownership in packed scenes
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — duplicate() before mutating shared data
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md
# =============================================================================
