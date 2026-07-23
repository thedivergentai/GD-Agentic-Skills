# skills/debugging-profiling/code/performance_plotter.gd
extends Node

## Performance Plotter Expert Pattern
## Hooks into Godot's Performance API for professional profiling.

func _ready() -> void:
    if OS.is_debug_build():
        # 1. Custom Monitors
        # Track arbitrary variables in the engine's built-in monitor.
        Performance.add_custom_monitor("Gameplay/ActiveProjectiles", _get_projectile_count)
        Performance.add_custom_monitor("Gameplay/EnemyCount", _get_enemy_count)

func _get_projectile_count() -> int:
    return get_tree().get_nodes_in_group("projectiles").size()

func _get_enemy_count() -> int:
    return get_tree().get_nodes_in_group("enemies").size()

func capture_error_state(context: String) -> String:
    # 2. Automated Diagnostic Capture
    # Gathers stack traces and scene tree structure for bug reports.
    var report = {
        "timestamp": Time.get_datetime_string_from_system(),
        "context": context,
        "stack_trace": get_stack(),
        "os": OS.get_name(),
        "memory_usage": Performance.get_monitor(Performance.MEMORY_STATIC)
    }
    return JSON.stringify(report, "\t")

## EXPERT NOTE:
## Use 'push_error()' and 'push_warning()' instead of 'print()' for logic errors.
## These appear in the Debugger tab with red/yellow icons and stack traces, 
## making them impossible to miss compared to standard console output.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_performance.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/debug/the_profiler.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/debug/custom_performance_monitors.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — plot then optimize bottlenecks
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md — plot release exports not editor debug
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md
# =============================================================================
