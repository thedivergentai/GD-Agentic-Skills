# hand_manager.gd
class_name HandManager extends Node

signal card_drawn(card: Resource)
signal card_overdrawn(card: Resource)

@export var max_hand_size: int = 10
var _current_hand: Array[Resource] = []

func draw_card(new_card: Resource) -> void:
    if _current_hand.size() >= max_hand_size:
        # Hand is full; trigger overdraw
        card_overdrawn.emit(new_card)
    else:
        _current_hand.append(new_card)
        card_drawn.emit(new_card)
