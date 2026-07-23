# idle_performance_setup.gd
extends Node

# Low Processor Mode Setup
# Essential for mobile idle games to prevent excessive battery drain during background/menu time.
func setup_performance() -> void:
    # Optimizes for low CPU usage by only refreshing the screen if needed.
    OS.low_processor_usage_mode = true
    
    # Increases the sleep time between frames (in microseconds) to further lower CPU overhead.
    # 6900 corresponds to a slight delay that substantially reduces draw calls.
    OS.low_processor_usage_mode_sleep_usec = 6900
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_os.html
# - https://docs.godotengine.org/en/stable/tutorials/performance/cpu_optimization.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — low_processor_usage_mode tuning
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-mobile/SKILL.md — battery-friendly idle sessions
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-idle-clicker/SKILL.md
# =============================================================================
