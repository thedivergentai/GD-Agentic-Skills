extends CharacterBody2D
class_name OneWayDropHandler

## Expert One-Way Drop Logic (Godot 4.7).
## Down + Jump intentionally drops through platforms.

const PLATFORM_LAYER = 4 # Example layer for one-way platforms

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("down") and Input.is_action_just_pressed("jump"):
		_drop_through()

func _drop_through() -> void:
	# Temporarily disable the collision mask for the platform layer
	set_collision_mask_value(PLATFORM_LAYER, false)
	
	# Restore after a short delay
	await get_tree().create_timer(0.2).timeout
	set_collision_mask_value(PLATFORM_LAYER, true)

## [SKILL NOTICE]: Use 'set_collision_mask_value()' to temporarily ignore 
## one-way platform layers. Use 'await' for precise, non-blocking timing.
