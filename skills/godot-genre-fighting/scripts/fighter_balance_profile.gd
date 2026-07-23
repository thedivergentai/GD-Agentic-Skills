# fighter_balance_profile.gd
class_name FighterBalanceProfile extends Resource

@export_group("Damage Scaling")
@export var base_damage_mult: float = 1.0
@export var combo_proration_rate: float = 0.9 # Lower means faster damage drop-off

@export_group("Movement Scaling")
@export var walk_speed_mult: float = 1.0
@export var dash_distance_mult: float = 1.0

@export_group("Defense Scaling")
@export var max_health: int = 10000
@export var guts_threshold: float = 0.3 # Damage reduction kicks in at 30% HP

# Usage in Fighter script:
# @export var balance_profile: FighterBalanceProfile
# func take_damage(amount: int) -> void:
#     health -= int(amount * balance_profile.damage_reduction_curve)
