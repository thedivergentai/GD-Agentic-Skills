# damage_formula_handler.gd
# Centralized logic for combat math
class_name DamageFormula extends RefCounted

# EXPERT NOTE: Move complex math out of Node scripts and into 
# RefCounted classes to keep your core scripts clean.

static func calculate_damage(attacker: StatsComponent, defender: StatsComponent) -> int:
	var atk = attacker.get_attribute("strength")
	var def = defender.get_attribute("dexterity") # Dodge chance
	
	# Simple formula: Atk - Def (Clamped)
	var raw = atk - (def * 0.5)
	return int(max(raw, 1.0))
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_refcounted.html
# - https://docs.godotengine.org/en/stable/tutorials/math/random_number_generation.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — calls DamageFormula from hit resolution
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — simulate formula variance at scale
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md
# =============================================================================
