# offline_progression_manager.gd
class_name OfflineProgressionManager extends Node

signal offline_earnings_calculated(seconds_offline: float)
const SAVE_PATH: String = "user://offline_save.json"

func _ready() -> void:
    _process_offline_time()

func _process_offline_time() -> void:
    var current_time = Time.get_unix_time_from_system()
    var last_time = load_timestamp() # From FileAccess
    var delta = current_time - last_time
    
    if delta > 60.0:
        offline_earnings_calculated.emit(delta)

func save_timestamp() -> void:
    var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    file.store_string(JSON.stringify({"last_time": Time.get_unix_time_from_system()}))
