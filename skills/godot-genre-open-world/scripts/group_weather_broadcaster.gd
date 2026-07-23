# group_weather_broadcaster.gd
extends Node
class_name GroupWeatherBroadcaster

# Global Environment Group Broadcasting
# Decouples weather logic from individual entities using high-speed group calls.

func apply_weather_state(weather_type: StringName) -> void:
    # Pattern: Avoid iterating nodes manually. Use call_group_flags for efficiency.
    get_tree().call_group_flags(
        SceneTree.GROUP_CALL_DEFERRED,
        &"environment_reactors",
        &"_on_weather_update",
        weather_type
    )
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/groups.html
# - https://docs.godotengine.org/en/stable/classes/class_scenetree.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — group broadcast vs find_child for global weather
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-3d-lighting/SKILL.md — environment reactors for time-of-day/weather
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-open-world/SKILL.md
# =============================================================================
