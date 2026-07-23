# resource_flyweight_caching.gd
# Optimizing memory via shared Resource instances
extends Node

# EXPERT NOTE: Godot automatically uses the Flyweight pattern for 
# Resources. Loading the same .tres file 100 times only uses 
# the memory of one instance.

func spawn_item(path: String):
	# This returns the cached reference if already loaded
	var data = load(path) as ItemData
	var item = Sprite2D.new()
	item.texture = data.icon
	add_child(item)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/classes/class_resourceloader.html
# - https://docs.godotengine.org/en/stable/classes/class_resource.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — shared .tres instances vs per-entity copies
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — load timing when spawning many items
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md
# =============================================================================
