# combo_system.gd
class_name ComboSystem
extends Node

signal combo_executed(combo_name: String)

@export var combo_window: float = 0.5
var combo_buffer: Array[StringName] = []
var last_input_time: float = 0.0

func register_input(action: StringName) -> void:
	var current_time := Time.get_ticks_msec() / 1000.0

	if current_time - last_input_time > combo_window:
		combo_buffer.clear()

	combo_buffer.append(action)
	last_input_time = current_time
	_check_combos()

func _check_combos() -> void:
	if combo_buffer.size() >= 3:
		var last_three := combo_buffer.slice(-3)
		if last_three == [&"light", &"light", &"heavy"]:
			_execute_combo(&"special_attack")
			combo_buffer.clear()

func _execute_combo(combo_name: StringName) -> void:
	combo_executed.emit(combo_name)
