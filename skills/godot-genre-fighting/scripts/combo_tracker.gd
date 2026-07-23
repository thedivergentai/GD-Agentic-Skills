# combo_tracker.gd
class_name ComboTracker
extends Node

var combo_count: int = 0
var combo_damage: int = 0
var in_combo: bool = false
var damage_scaling: float = 1.0

const SCALING_PER_HIT := 0.9  # 10% reduction per hit

func start_combo() -> void:
    in_combo = true
    combo_count = 0
    combo_damage = 0
    damage_scaling = 1.0

func add_hit(base_damage: int) -> int:
    combo_count += 1
    var scaled_damage := int(base_damage * damage_scaling)
    combo_damage += scaled_damage
    damage_scaling *= SCALING_PER_HIT
    return scaled_damage

func drop_combo() -> void:
    in_combo = false
    combo_count = 0
    damage_scaling = 1.0
