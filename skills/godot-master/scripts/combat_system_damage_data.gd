# skills/godot-combat-system/scripts/damage_data.gd
class_name DamageData
extends Resource

## Typed combat payload. Elemental types are bitflags — never raw strings.

enum DamageType {
	PHYSICAL = 1,
	FIRE = 2,
	ICE = 4,
	LIGHTNING = 8,
	POISON = 16,
}

@export var amount: float = 10.0
@export var source: Node
@export_flags("Physical", "Fire", "Ice", "Lightning", "Poison")
var damage_types: int = DamageType.PHYSICAL
@export var knockback: Vector2 = Vector2.ZERO
@export var knockback_force_3d: float = 0.0
@export var hit_stun_time: float = 0.0
@export var is_critical: bool = false
@export var source_position: Vector3 = Vector3.ZERO

func has_type(flag: int) -> bool:
	return (damage_types & flag) != 0

func with_amount(dmg: float, src: Node = null) -> DamageData:
	var copy := duplicate(true) as DamageData
	copy.amount = dmg
	if src:
		copy.source = src
	return copy
