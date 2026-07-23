# damage_popup.gd
extends Label

func show_damage(amount: float, is_crit: bool = false) -> void:
	text = str(int(amount))
	if is_crit:
		modulate = Color.RED
		scale = Vector2(1.5, 1.5)

	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position:y", position.y - 50, 1.0)
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	tween.finished.connect(queue_free)
