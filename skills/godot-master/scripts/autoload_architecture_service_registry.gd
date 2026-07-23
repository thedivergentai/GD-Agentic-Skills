class_name ServiceRegistry
extends Node

## Expert Service Locator (Godot 4.7).
## Prevents Global Namespace Pollution by centralizing dependencies.

var _services: Dictionary = {}

func register(service_name: StringName, instance: Object) -> void:
	if _services.has(service_name):
		push_warning("[SERVICE]: %s already registered. Overwriting." % service_name)
	
	_services[service_name] = instance
	if instance is Node and not instance.is_inside_tree():
		add_child(instance)

func get_service(service_name: StringName) -> Object:
	return _services.get(service_name)

func unregister(service_name: StringName) -> void:
	var service = _services.get(service_name)
	if service:
		_services.erase(service_name)
		if service is Node and service.get_parent() == self:
			service.queue_free()

## [SKILL NOTICE]: Use StringName (&"Name") for keys to ensure O(1) 
## dictionary lookups at the engine-core level.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_engine.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/godot_interfaces.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md — named service interfaces vs hard Autoloads
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — StringName O(1) dictionary keys
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — missing-service diagnostics
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md
# =============================================================================
