# hitbox_visualizer.gd
class_name HitboxVisualizer
extends Node

func toggle_debug_hitboxes() -> void:
	get_tree().debug_collisions_hint = not get_tree().debug_collisions_hint

static func set_hitbox_color(shape: CollisionShape3D, is_attack: bool) -> void:
	shape.debug_color = Color.RED if is_attack else Color.GREEN
