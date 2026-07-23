extends Resource
class_name CombatStatsResource
## Deterministic combat stats for turn preview / UI damage hover.

@export var attack_power: int = 10
@export var defense: int = 5

func get_expected_damage(target: CombatStatsResource) -> int:
	var raw := attack_power - target.defense
	return maxi(0, raw)
