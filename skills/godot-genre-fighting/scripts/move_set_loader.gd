# move_set_loader.gd
class_name MoveSetLoader extends Node

var move_data: Dictionary = {}

func load_from_json(path: String) -> void:
    var file := FileAccess.open(path, FileAccess.READ)
    if file:
        var json_string := file.get_as_text()
        var result = JSON.parse_string(json_string)
        if result is Dictionary:
            move_data = result
        file.close()

# Example JSON Schema structure:
# {
#   "hadouken": {
#     "input": ["down", "down_forward", "forward", "punch"],
#     "startup": 12,
#     "active": 3,
#     "recovery": 25,
#     "damage": 800
#   }
# }
