# Customer/Demand System

```gdscript
class_name CustomerSimulation
extends Node

@export var base_customers_per_hour := 10.0
@export var demand_curve: Curve  # Hour of day vs demand multiplier

var customer_queue: Array[Customer] = []

func generate_customers(game_hour: float, delta_hours: float) -> void:
    var demand_mult := demand_curve.sample(game_hour / 24.0)
    var reputation_mult := Economy.resources["reputation"] / 50.0  # 100 rep = 2x customers
    
    var customers_to_spawn := base_customers_per_hour * delta_hours * demand_mult * reputation_mult
    
    for i in int(customers_to_spawn):
        spawn_customer()

func spawn_customer() -> void:
    var customer := Customer.new()
    customer.patience = randf_range(30.0, 120.0)  # Seconds before leaving
    customer.spending_budget = randf_range(10.0, 100.0)
    customer_queue.append(customer)
```

---
