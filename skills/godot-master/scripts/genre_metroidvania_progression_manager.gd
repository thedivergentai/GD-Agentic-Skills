# progression_manager.gd (Autoload)
class_name ProgressionManager extends Node

var unlocked_abilities: Dictionary = {
    "double_jump": false,
    "dash": false,
    "wall_slide": false
}

func check_gate(ability_name: String) -> bool:
    return unlocked_abilities.get(ability_name, false)

func unlock_ability(id: String) -> void:
    if unlocked_abilities.has(id):
        unlocked_abilities[id] = true
