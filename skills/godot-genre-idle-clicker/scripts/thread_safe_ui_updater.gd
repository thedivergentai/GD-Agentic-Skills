# thread_safe_ui_updater.gd
extends Node

# Thread-Safe UI Update Pattern
# Safely propagates data from background simulations to main-thread UI nodes.
@onready var currency_label: Label = Label.new()

func update_display_deferred(new_value_string: String) -> void:
    # NEVER set .text directly from a thread. 
    # call_deferred ensures the update happens on the next frame in the main thread.
    currency_label.call_deferred("set_text", "Balance: " + new_value_string)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/performance/thread_safe_apis.html
# - https://docs.godotengine.org/en/stable/classes/class_label.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — main-thread Label updates only
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — call_deferred from WorkerThreadPool
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-idle-clicker/SKILL.md
# =============================================================================
