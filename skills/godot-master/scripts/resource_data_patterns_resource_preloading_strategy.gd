# resource_preloading_strategy.gd
# Preventing frame drops by pre-loading data
extends Node

# EXPERT NOTE: Use a dictionary of preloaded Resources to 
# avoid 'load()' calls during gameplay frame peaks.

var _vfx_cache: Dictionary = {
	"hit": preload("res://vfx/hit.tres"),
	"spark": preload("res://vfx/spark.tres")
}

func get_vfx(key: String) -> Resource:
	return _vfx_cache.get(key)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html
# - https://docs.godotengine.org/en/stable/classes/class_resourceloader.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — cache warm before scene transitions
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — avoid mid-frame load() hitch spikes
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md
# =============================================================================
