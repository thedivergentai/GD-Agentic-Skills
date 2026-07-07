extends Node
class_name StatusDepletionManager

## Expert Status Management (Godot 4.7).
## Continuous depletion of Hunger, Thirst, and Health using physics delta.

var stats: Dictionary = {
	"hunger": {"val": 100.0, "max": 100.0, "rate": 0.5},
	"thirst": {"val": 100.0, "max": 100.0, "rate": 0.8}
}

func _physics_process(delta: float) -> void:
	for id in stats:
		var s = stats[id]
		# Expert Pattern: Frame-independent reduction
		s.val = clamp(s.val - (s.rate * delta), 0.0, s.max)
		if s.val <= 0: _on_stat_empty(id)

func _on_stat_empty(id: String) -> void:
	# Trigger starvation/dehydration damage
	pass

## [SKILL NOTICE]: Use '_physics_process(delta)' for continuous depletion 
## instead of Timers for a smoother, frame-independent survival feel.
