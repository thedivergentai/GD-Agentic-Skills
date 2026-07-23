extends Node
class_name CombatDamageCalculator

## Diminishing-returns damage resolve for ARPG hit pipelines. Pair with hitbox_component + duck_typed_hitbox.

const ARMOR_K: float = 100.0


static func calculate_damage(
	attacker_strength: float,
	attacker_crit_chance: float,
	attacker_crit_damage: float,
	defender_armor: float,
	base_damage: float
) -> Dictionary:
	var attack_power := attacker_strength * 2.0 + base_damage
	var reduction := defender_armor / (defender_armor + ARMOR_K)
	var final_damage := int(attack_power * (1.0 - reduction))
	var is_crit := randf() < attacker_crit_chance / 100.0
	if is_crit:
		final_damage = int(final_damage * attacker_crit_damage / 100.0)
	return {
		"damage": maxi(1, final_damage),
		"is_crit": is_crit,
		"damage_type": &"physical",
	}


static func apply_damage(target: Node, damage_result: Dictionary) -> void:
	if target.has_method(&"take_damage"):
		target.take_damage(damage_result["damage"], damage_result.get("is_crit", false))
# ---
# GDSkills research links (agents)
# Related:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-action-rpg/SKILL.md — NEVER linear armor to 100%
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — DamageData integration
# ---
