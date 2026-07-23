# dialogue_stat_logger.gd
class_name DialogueStatLogger
extends Logger

func _log_message(msg: String, is_error: bool) -> void:
	if not is_error and msg.begins_with("[CHOICE]"):
		_record_analytics(msg)

func _record_analytics(_msg: String) -> void:
	pass

static func initialize() -> void:
	OS.add_logger(DialogueStatLogger.new())
