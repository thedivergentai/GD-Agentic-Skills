# thread_safe_global_access.gd
# Handling global data from background threads
extends Node

# EXPERT NOTE: Modifying Autoload nodes or SceneTree properties 
# from threads is UNSAFE. Use Mutex for data or call_deferred for nodes.

var _shared_data: Dictionary = {}
var _lock: Mutex = Mutex.new()

func update_data_safely(key: String, val: Variant):
	_lock.lock()
	_shared_data[key] = val
	_lock.unlock()

func get_data_safely(key: String) -> Variant:
	_lock.lock()
	var res = _shared_data.get(key)
	_lock.unlock()
	return res
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/performance/thread_safe_apis.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/using_multiple_threads.html
# - https://docs.godotengine.org/en/stable/classes/class_mutex.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — WorkerThreadPool + Autoload shared maps
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — call_deferred back to main thread
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-procedural-generation/SKILL.md — typical background writer into global caches
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md
# =============================================================================
