# stat_modifier_stacking.gd
# Preventing modifier bloat and conflicts
extends Node

# EXPERT NOTE: Use a unique ID or Name check if you don't 
# want the same buff to stack multiple times.

func apply_unique_buff(stats: StatsComponent, mod: StatusEffectData):
	for existing in stats.modifiers:
		if existing.name == mod.name:
			# Refresh duration instead of adding new
			return
			
	stats.apply_modifier(mod)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# - https://docs.godotengine.org/en/stable/classes/class_scenetree.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md — unique vs stackable buff IDs from abilities
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md — equipment modifiers that must not double-stack
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md
# =============================================================================
