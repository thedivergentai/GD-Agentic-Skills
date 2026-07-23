# skills/godot-combat-system/scripts/health_component.gd
extends Node
class_name HealthComponent

## Golden-path HP + invincibility frames. Wire Hurtbox → take_damage(DamageData).

signal health_changed(old_health: float, new_health: float)
signal died
signal healed(amount: float)
signal invincibility_started
signal invincibility_ended

@export var max_health: float = 100.0
@export var current_health: float = 100.0
@export var i_frame_duration: float = 0.25
@export var disable_hurt_shapes_on_death: bool = true

var _invincible: bool = false
var _i_frame_left: float = 0.0

func _physics_process(delta: float) -> void:
	if _i_frame_left > 0.0:
		_i_frame_left -= delta
		if _i_frame_left <= 0.0:
			_invincible = false
			invincibility_ended.emit()

func take_damage(data: DamageData) -> void:
	if data == null or _invincible or current_health <= 0.0:
		return
	var old := current_health
	current_health = maxf(0.0, current_health - data.amount)
	health_changed.emit(old, current_health)
	if current_health <= 0.0:
		_on_died()
		return
	_start_i_frames()

func heal(amount: float) -> void:
	if amount <= 0.0 or current_health <= 0.0:
		return
	var old := current_health
	current_health = minf(max_health, current_health + amount)
	healed.emit(current_health - old)
	health_changed.emit(old, current_health)

func _start_i_frames() -> void:
	if i_frame_duration <= 0.0:
		return
	_invincible = true
	_i_frame_left = i_frame_duration
	invincibility_started.emit()

func _on_died() -> void:
	died.emit()
	if not disable_hurt_shapes_on_death:
		return
	var host := get_parent()
	if host == null:
		return
	for child in host.find_children("*", "CollisionShape2D", true, false):
		(child as CollisionShape2D).set_deferred("disabled", true)
	for child in host.find_children("*", "CollisionShape3D", true, false):
		(child as CollisionShape3D).set_deferred("disabled", true)
