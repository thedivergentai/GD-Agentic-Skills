# Feedback Systems

### Visual Feedback

```gdscript
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
```

### Statistics Dashboard

```gdscript
class_name StatsDashboard
extends Control

@export var graph_history_hours := 24
var income_history: Array[float] = []
var expense_history: Array[float] = []

func record_financial_tick(income: float, expenses: float) -> void:
    income_history.append(income)
    expense_history.append(expenses)
    
    # Keep last N entries
    while income_history.size() > graph_history_hours:
        income_history.pop_front()
        expense_history.pop_front()
    
    queue_redraw()

func _draw() -> void:
    # Draw income/expense graph
    draw_line_graph(income_history, Color.GREEN)
    draw_line_graph(expense_history, Color.RED)
```

---
