# character_stats_resource.gd
extends Resource
class_name CharacterStatsResource

# Modular Resource-Based Character Stats
# Lightweight Inspector-friendly data container for RPG attributes.

@export var max_health: int = 100
@export var base_attack_damage: float = 15.0
@export var elemental_resistances: Dictionary[StringName, float] = {
    &"fire": 0.0,
    &"ice": 0.0,
    &"lightning": 0.0
}

# Methods allow for internal scaling logic without exposing math variables.
func get_scaled_damage(multiplier: float) -> float:
    return base_attack_damage * multiplier

func get_mitigated_damage(incoming_damage: float, element: StringName) -> float:
    var res = elemental_resistances.get(element, 0.0)
    return incoming_damage * (1.0 - res)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html — modular RPG attributes
# - https://docs.godotengine.org/en/stable/classes/class_resource.html — typed Dictionary resistances
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-rpg-stats/SKILL.md — scaling and mitigation formulas
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — sim resistance vs DPS curves
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-action-rpg/SKILL.md
# =============================================================================
