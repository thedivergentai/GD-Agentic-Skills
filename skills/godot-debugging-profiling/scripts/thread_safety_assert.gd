# thread_safety_assert.gd
# Caught threading violations early
extends Node

# EXPERT NOTE: Writing to the SceneTree from a worker 
# thread is a common source of crashes.

func update_main_thread_data():
	# EXPERT: Verifies that this code runs on the Main Thread
	assert(OS.get_main_thread_id() == OS.get_thread_caller_id())
	# Safe to update UI or Nodes now
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/performance/thread_safe_apis.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/using_multiple_threads.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-server-architecture/SKILL.md — server APIs vs SceneTree access
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — offload work without races
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md
# =============================================================================
