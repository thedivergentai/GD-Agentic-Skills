# threaded_catchup_simulator.gd
extends Node

# Threaded Offline Catch-Up (Scalability Optimization)
# Offloads heavy incremental math to a background thread to prevent UI freezing.
func process_offline_sim(total_ticks: int) -> void:
    # WorkerThreadPool allows chunked processing across all CPU cores.
    var task_id := WorkerThreadPool.add_group_task(_simulate_single_tick, total_ticks)
    
    # Non-blocking wait if needed, or simply allow background completion.
    WorkerThreadPool.wait_for_group_task_completion(task_id)

func _simulate_single_tick(_tick_index: int) -> void:
    # Logic for individual tick simulation (e.g., compounding interest).
    pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_workerthreadpool.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/using_multiple_threads.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/thread_safe_apis.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — background offline tick sims
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — publish results after wait_for_group_task
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-idle-clicker/SKILL.md
# =============================================================================
