extends AbilityResource
class_name ChargeAbility

## Multi-charge ability (Flash-style). Charges tick in _physics_process on the owning manager node.

@export var max_charges: int = 2
@export var charge_recharge_time: float = 20.0

var current_charges: int = 0
var recharge_timer: float = 0.0


func _init() -> void:
	current_charges = max_charges


func can_cast(_caster: Node) -> bool:
	return current_charges > 0


func execute(user: Node2D, target_position: Vector2) -> bool:
	if current_charges <= 0:
		return false
	current_charges -= 1
	if current_charges < max_charges and is_equal_approx(recharge_timer, 0.0):
		recharge_timer = charge_recharge_time
	return super.execute(user, target_position)


func tick_charges(delta: float) -> void:
	if recharge_timer <= 0.0:
		return
	recharge_timer -= delta
	if recharge_timer <= 0.0:
		current_charges += 1
		if current_charges < max_charges:
			recharge_timer = charge_recharge_time
		else:
			recharge_timer = 0.0
# ---
# GDSkills research links (agents)
# Docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html — tick recharge on physics step
# Related:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md — cooldown & GCD contract
# ---
