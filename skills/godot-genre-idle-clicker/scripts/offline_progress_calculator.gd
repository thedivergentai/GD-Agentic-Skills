# offline_progress_calculator.gd
extends Node

# Calculating Offline Ticks
# Measures real-world time passed while the application was closed.
func calculate_offline_progress(last_save_unix_time: float) -> float:
    # get_unix_time_from_system() returns persistent time since the Epoch.
    # NEVER use get_ticks_msec() for offline progress as it resets on boot.
    var current_time := Time.get_unix_time_from_system()
    var delta_seconds := current_time - last_save_unix_time
    
    # Returns raw seconds; usually passed to a simulation loop.
    return delta_seconds
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_time.html
# - https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
# - https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — persist last_save UNIX timestamps
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-mobile/SKILL.md — resume/offline catch-up on phones
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-idle-clicker/SKILL.md
# =============================================================================
