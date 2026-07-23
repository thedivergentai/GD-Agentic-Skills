# derived_stat_resource.gd
extends Resource
class_name DerivedStat

@export var multiplier: float = 1.0
@export var base_stat: RPGStat:
	set(new_base):
		if base_stat:
			base_stat.stat_changed.disconnect(_on_dependency_changed)
		base_stat = new_base
		if base_stat:
			base_stat.stat_changed.connect(_on_dependency_changed)
			_recalculate()

var current_value: int = 0


func _recalculate() -> void:
	if base_stat:
		current_value = int(base_stat.current_value * multiplier)


func _on_dependency_changed(_old: int, _new: int) -> void:
	_recalculate()
