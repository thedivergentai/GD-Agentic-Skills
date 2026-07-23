# global_event_bus.gd
# Centralized signal routing to decouple systems
extends Node

# EXPERT NOTE: An Event Bus should ideally hold no state. 
# It only acts as a post office for signals.

signal level_started(id: int)
signal enemy_defeated(type: String, points: int)
signal game_paused(is_paused: bool)

func notify_enemy_killed(type: String, val: int):
	enemy_defeated.emit(type, val)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/instancing_with_signals.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/logic_preferences.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — typed bus contracts, no stored state
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — enemy_defeated / score fan-out
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-quest-system/SKILL.md — level_started listeners
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md
# =============================================================================
