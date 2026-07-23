# signal_combat_decoupler.gd
# "Signal Up, Call Down" architecture for combat
extends Node

# EXPERT NOTE: Avoid coupling UI to combat. 
# Combat nodes emit signals; UI nodes observe and react.

signal combat_logged(msg: String, type: String)

func _on_damage_dealt(target: String, amount: int):
	# UI/Log decoupled via signal
	combat_logged.emit("Hit %s for %d damage!" % [target, amount], "damage")

func _on_death():
	combat_logged.emit("Enemy defeated!", "death")
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html — signals up for combat_logged
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html — UI observes, combat emits
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — combat ↔ HUD decoupling
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — damage_dealt hooks
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-action-rpg/SKILL.md
# =============================================================================
