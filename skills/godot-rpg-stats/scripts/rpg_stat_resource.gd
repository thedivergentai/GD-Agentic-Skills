# rpg_stat_resource.gd
extends Resource
class_name RPGStat

signal stat_changed(old_value: int, new_value: int)

@export var stat_name: String = "Strength"
@export var max_cap: int = 999
@export var current_value: int = 10:
	set(value):
		var old := current_value
		current_value = clampi(value, 0, max_cap)
		if old != current_value:
			stat_changed.emit(old, current_value)
