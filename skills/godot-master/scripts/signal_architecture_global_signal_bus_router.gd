# global_signal_bus_router.gd
# Centralized event routing without shared gameplay state
extends Node

# EXPERT NOTE: Use a dedicated Autoload (EventBus) for broad events 
# like achievements or global UI updates. Avoid for local scene logic.

# global_events.gd (Autoload)
signal player_leveled_up(new_level: int)
signal achievement_unlocked(id: String)
signal game_saved()

func notify_level_up(level: int):
	player_leveled_up.emit(level)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/autoloads_versus_regular_nodes.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — EventBus ownership and boot order
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — register Autoload before cross-scene emits
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md
# =============================================================================
