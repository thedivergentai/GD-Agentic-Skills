# skills/autoload-architecture/scripts/autoload_initializer.gd
extends Node

## AutoLoad Initializer Expert Pattern
## Manages explicit initialization order and dependency injection for AutoLoads.

class_name AutoLoadInitializer

var _initialized: Dictionary = {}
var _init_order: Array[StringName] = []

func register_autoload(autoload_name: StringName, init_callback: Callable) -> void:
	_init_order.append(autoload_name)
	_initialized[autoload_name] = {
		"callback": init_callback,
		"complete": false
	}

func initialize_all() -> void:
	print("=== Initializing AutoLoads ===")
	
	for autoload_name in _init_order:
		var data: Dictionary = _initialized[autoload_name]
		if data["complete"]:
			continue
			
		print("Initializing: %s" % autoload_name)
		data["callback"].call()
		data["complete"] = true

func is_initialized(autoload_name: StringName) -> bool:
	return _initialized.get(autoload_name, {}).get("complete", false)

func wait_for_autoload(autoload_name: StringName) -> void:
	while not is_initialized(autoload_name):
		await get_tree().process_frame

## EXPERT USAGE:
## In each AutoLoad's _ready():
##   AutoLoadInitializer.register_autoload(&"GameManager", initialize)
##
## func initialize() -> void:
##   # Heavy initialization here
##   pass
##
## Then in main scene:
##   AutoLoadInitializer.initialize_all()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/overridable_functions.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/autoloads_versus_regular_nodes.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — call initialize_all from main scene boot
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — keep heavy work out of Autoload _ready
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — registration before lazy init
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md
# =============================================================================
