# card_history_logger.gd
class_name CardHistoryLogger extends Logger

signal history_updated(entry: String)
var turn_history: Array[String] = []

func _log_message(message: String, error: bool) -> void:
    if not error and message.begins_with("[CARD]"):
        turn_history.append(message)
        history_updated.emit(message)

# To register (in an Autoload):
# func _init(): OS.add_logger(CardHistoryLogger.new())
