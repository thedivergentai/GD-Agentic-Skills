# economy_logger.gd
class_name EconomyLogger
extends Logger

var _gold_earned := 0
var _start_time := Time.get_ticks_msec()

func _log_message(msg: String, is_error: bool) -> void:
	if is_error or not msg.begins_with("[ECON]"):
		return
	var parts := msg.split(":")
	if parts.size() < 2:
		return
	_gold_earned += parts[1].strip_edges().to_int()
	_log_gpm()

func _log_gpm() -> void:
	var mins := (Time.get_ticks_msec() - _start_time) / 60000.0
	var _gpm := _gold_earned / max(mins, 0.01)
