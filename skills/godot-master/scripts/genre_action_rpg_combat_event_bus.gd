# combat_event_bus.gd
# Centralized bus for decoupled global combat events
extends Node

# EXPERT NOTE: A global bus (Autoload) is great for events 
# like "AnyEnemyDied" that multiple diverse systems observe.

signal player_spawned(player: Node2D)
signal enemy_defeated(experience: int)
signal boss_phase_changed(phase_id: int)

func notify_enemy_death(xp: int):
	enemy_defeated.emit(xp)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html — global combat signals
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html — Autoload observers
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — bus ownership and fan-out
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-quest-system/SKILL.md — enemy_defeated / XP hooks
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-action-rpg/SKILL.md
# =============================================================================
