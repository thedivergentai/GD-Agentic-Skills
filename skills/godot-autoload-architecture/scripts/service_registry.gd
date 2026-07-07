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
