class_name AutoLoadBootstrapper
extends Node

## Expert AutoLoad Bootstrapper (Godot 4.7).
## Orchestrates two-phase initialization across all Singletons.
## PLACE THIS LAST IN THE PROJECT SETTINGS AUTOLOAD LIST.

func _ready() -> void:
	var root := get_tree().root
	var services: Array[Node] = []
	
	# 1. Discovery
	for child in root.get_children():
		if child.has_method("init_service") and child != self:
			services.append(child)
	
	# 2. Phase 1: Dependency Resolution
	for s in services:
		s.call("init_service")
	
	# 3. Phase 2: Execution Start
	for s in services:
		if s.has_method("start_service"):
			s.call("start_service")
	
	print("[BOOTSTRAP]: All global services synchronized and started.")

## [SKILL NOTICE]: This pattern resolves circular dependencies where 
## AutoLoad A needs AutoLoad B's 'ready' state to initialize.
