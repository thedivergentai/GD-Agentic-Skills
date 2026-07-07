class_name AbilityResource
extends Resource

## Expert Ability Logic (Godot 4.7).
## Resource-based ability definitions and fly-in UI logic.

@export var id: StringName = &"double_jump"
@export var name: String = "Double Jump"
@export var icon: Texture2D

func trigger_notification(ui_panel: Control) -> void:
	# Fly-in effect for discovery
	var t = ui_panel.create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	t.tween_property(ui_panel, "position:x", 20, 0.5)
	t.tween_interval(2.0)
	t.tween_property(ui_panel, "position:x", -300, 0.4)

## [SKILL NOTICE]: Use 'duplicate(true)' if abilities have mutable 
## power levels to prevent modifying the source .tres file.
