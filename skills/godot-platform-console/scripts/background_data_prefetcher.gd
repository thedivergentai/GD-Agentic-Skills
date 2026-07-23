class_name BackgroundDataPrefetcher
extends Node

## Expert Content Delivery: Offloads asset pre-fetching to background threads.
## Ensures smooth level transitions on slow console storage.

func prefetch_assets(paths: Array[String]) -> void:
	for path in paths:
		# Use WorkerThreadPool to keep the main thread fluid
		WorkerThreadPool.add_task(_load_asset.bind(path))

func _load_asset(path: String) -> void:
	# ResourceLoader.load() on a background thread pre-fills the internal cache.
	# Subsequent calls to 'load()' on the main thread will be instant.
	var _res = ResourceLoader.load(path)
	print("Console: Prefetched ", path)

## Rule: Only prefetch non-critical assets (SFX, MeshData) to avoid I/O bottlenecks.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/using_multiple_threads.html
# - https://docs.godotengine.org/en/stable/classes/class_workerthreadpool.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — prefetch queues tied to scene transitions
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — I/O budgets on slow console storage
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-console/SKILL.md
# =============================================================================
