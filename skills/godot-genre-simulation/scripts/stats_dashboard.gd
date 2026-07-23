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
