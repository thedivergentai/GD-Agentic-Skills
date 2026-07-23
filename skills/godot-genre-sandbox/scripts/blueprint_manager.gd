class_name BlueprintManager extends Node

## Exports chunk data to the OS clipboard.
static func export_blueprint_to_clipboard(blueprint_data: Dictionary) -> void:
    var json_string: String = JSON.stringify(blueprint_data)
    DisplayServer.clipboard_set(json_string)

## Imports blueprint from clipboard.
static func import_blueprint_from_clipboard() -> Dictionary:
    var json_string: String = DisplayServer.clipboard_get()
    var parsed_data = JSON.parse_string(json_string)
    return parsed_data if parsed_data is Dictionary else {}
