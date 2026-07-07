extends Node
class_name StatModifierPowerup

## Expert Powerup System (Godot 4.7).
## Manages temporary stat buffs with automatic duration reverting.

var base_stats: Dictionary = { "speed": 10.0, "power": 5.0 }
var active_stats: Dictionary = base_stats.duplicate()

func apply_buff(stat_id: String, multiplier: float, duration: float) -> void:
	if not active_stats.has(stat_id): return
	
	active_stats[stat_id] = base_stats[stat_id] * multiplier
	
	# Expert Pattern: Bind signal to pass context to the timeout callback
	var timer = get_tree().create_timer(duration)
	timer.timeout.connect(_revert_buff.bind(stat_id))

func _revert_buff(stat_id: String) -> void:
	active_stats[stat_id] = base_stats[stat_id]

## [SKILL NOTICE]: Use 'bind()' on timer signals to pass specific 
## stat IDs back to the callback for clean duration management.
