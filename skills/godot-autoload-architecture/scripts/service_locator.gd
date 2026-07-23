# service_locator.gd
# Expert Service Locator pattern using Godot 4.1+ static variables.
# Decouples system discovery from hardcoded Autoloads.

extends Node

class_name ServiceLocator

## Global registry of services, accessible via static methods.
static var _services: Dictionary = {}

## Registers a service provider (Node or RefCounted).
static func register_service(id: String, provider: Object) -> void:
	if _services.has(id):
		push_warning("Service Locator: Overwriting existing service '%s'." % id)
	_services[id] = provider
	print("Service Locator: Registered '%s' (%s)" % [id, provider.get_class()])

## Retrieves a registered service. Returns null if not found.
static func get_service(id: String) -> Object:
	if not _services.has(id):
		push_error("Service Locator: Service '%s' not found!" % id)
		return null
	return _services[id]

## Removes a service from the registry.
static func unregister_service(id: String) -> void:
	if _services.erase(id):
		print("Service Locator: Unregistered '%s'" % id)

## Clears all services (useful for unit test teardown).
static func clear_all() -> void:
	_services.clear()
	print("Service Locator: All services cleared.")

## Usage Expert Tip:
## Instead of using hardcoded Autoloads, have your managers register themselves:
## func _ready():
##     ServiceLocator.register_service("save_manager", self)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_engine.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/autoloads_versus_regular_nodes.html
# - https://docs.godotengine.org/en/stable/classes/class_refcounted.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition/SKILL.md — register components without Node Autoload spam
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — StringName keys / static helpers
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md — swap fakes via clear/register
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md
# =============================================================================
