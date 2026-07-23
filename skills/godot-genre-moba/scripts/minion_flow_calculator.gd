# minion_flow_calculator.gd
extends Node
class_name MinionFlowCalculator

# Offloading Heavy Parallel Computations
# Uses WorkerThreadPool to process minion intelligence/paths without lag spikes.

func process_minion_batch(minions: Array[Node]) -> void:
    if minions.is_empty(): return
    
    # Pattern: Distribute logic across all available CPU cores.
    var task_id := WorkerThreadPool.add_group_task(_compute_minion_logic.bind(minions), minions.size())
    
    # Wait for the batch to finish before moving to the next frame step.
    WorkerThreadPool.wait_for_group_task_completion(task_id)

func _compute_minion_logic(index: int, minion_list: Array[Node]) -> void:
    var minion = minion_list[index]
    # Perform expensive path or visibility calculations here.
    # Note: Must only access thread-safe data within this function.
    pass
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/performance/using_multiple_threads.html
# - https://docs.godotengine.org/en/stable/classes/class_workerthreadpool.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/thread_safe_apis.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — batch offload budgets
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-navigation-pathfinding/SKILL.md — path work vs main thread
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-moba/SKILL.md
# =============================================================================
