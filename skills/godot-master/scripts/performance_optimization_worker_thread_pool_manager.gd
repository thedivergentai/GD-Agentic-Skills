# worker_thread_pool_manager.gd
# Offloading heavy computation to worker threads
extends Node

# EXPERT NOTE: WorkerThreadPool is superior to Thread.new() in 
# Godot 4 as it reuses a pool of system threads, avoiding 
# the overhead of spawning new OS threads intermittently.

func process_massive_dataset(data: Array):
	var task_id = WorkerThreadPool.add_task(_do_heavy_work.bind(data))
	# task_id can be used to check completion or wait
	# WorkerThreadPool.is_task_completed(task_id)

func _do_heavy_work(data: Array):
	for i in data:
		# Process locally without touching the SceneTree directly
		pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/performance/using_multiple_threads.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/thread_safe_apis.html
# - https://docs.godotengine.org/en/stable/classes/class_workerthreadpool.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — Callable.bind and task completion waits
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — keep heavy loads off the main thread during transitions
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md
# =============================================================================
