# Money flying to bank, resources flowing, etc.
class_name ResourceFlowVisualizer
extends Node

func show_income(amount: float, from: Vector2, to: Vector2) -> void:
    var coin := coin_scene.instantiate()
    coin.position = from
    add_child(coin)
    
    var tween := create_tween()
    tween.tween_property(coin, "position", to, 0.5)
    tween.tween_callback(coin.queue_free)
    
    var label := Label.new()
    label.text = "+$" + str(int(amount))
    label.position = from
    add_child(label)
    
    var label_tween := create_tween()
    label_tween.tween_property(label, "position:y", label.position.y - 30, 0.5)
    label_tween.parallel().tween_property(label, "modulate:a", 0.0, 0.5)
    label_tween.tween_callback(label.queue_free)
