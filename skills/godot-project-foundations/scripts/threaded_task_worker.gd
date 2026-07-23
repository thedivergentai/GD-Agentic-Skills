class_name ThreadedTaskWorker
extends Node

## Expert implementation of WorkerThreadPool for heavy calculations.
## Ensures thread-safe global state updates using Mutex and SceneTree synchronization.

var _shared_results: Array = []
var _data_mutex := Mutex.new()

func execute_async_calculation(data: Variant) -> void:
	# Dispatch to the engine's built-in thread pool [Efficient multi-core usage]
	WorkerThreadPool.add_task(_background_processing.bind(data), true, "Heavy AI/ProcGen Task")

func _background_processing(input_data: Variant) -> void:
	var local_buffer := [] 
	# ... Perform heavy heavy work here ...
	# local_buffer.append(processed_result)
	
	# Only lock when committing to the shared state to minimize core contention
	_data_mutex.lock()
	_shared_results.append_array(local_buffer)
	_data_mutex.unlock()
	
	# ALWAYS use call_deferred to update nodes or emit signals to the UI
	call_deferred(&"_on_task_finalized")

func _on_task_finalized() -> void:
	# Back on main thread: Safe to modify SceneTree
	pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_workerthreadpool.html
# - https://docs.godotengine.org/en/stable/classes/class_mutex.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/scene_tree.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — offload CPU work without tree mutations from workers
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — call_deferred / Mutex patterns in typed GDScript
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md
# =============================================================================
