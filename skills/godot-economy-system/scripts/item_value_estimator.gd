# item_value_estimator.gd
class_name ItemValueEstimator
extends Resource

enum Rarity { COMMON, RARE, EPIC, LEGENDARY }

@export var rarity: Rarity = Rarity.COMMON
@export var base_value: int = 100

func get_value() -> int:
	var mult := 1.0
	match rarity:
		Rarity.RARE:
			mult = 2.0
		Rarity.EPIC:
			mult = 5.0
		Rarity.LEGENDARY:
			mult = 20.0
	return int(base_value * mult)
