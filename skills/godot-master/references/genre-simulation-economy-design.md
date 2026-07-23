# Economy Design

The heart of any tycoon game is its economy. Key principle: **multiple interconnected resources that force trade-offs**.

### Multi-Resource System

```gdscript
class_name TycoonEconomy
extends Node

signal resource_changed(resource_type: String, amount: float)
signal went_bankrupt

var resources: Dictionary = {
    "money": 10000.0,
    "reputation": 50.0,  # 0-100
    "workers": 0,
    "materials": 100.0,
    "energy": 100.0
}

var resource_caps: Dictionary = {
    "reputation": 100.0,
    "workers": 50,
    "energy": 1000.0
}

func modify_resource(type: String, amount: float) -> bool:
    if amount < 0 and resources[type] + amount < 0:
        if type == "money":
            went_bankrupt.emit()
        return false  # Can't go negative
    
    resources[type] = clamp(
        resources[type] + amount,
        0,
        resource_caps.get(type, INF)
    )
    resource_changed.emit(type, resources[type])
    return true
```

### Income/Expense Tracking

```gdscript
class_name FinancialTracker
extends Node

var income_sources: Dictionary = {}  # source_name: amount_per_tick
var expense_sources: Dictionary = {}

signal financial_update(profit: float, income: float, expenses: float)

func calculate_tick() -> float:
    var total_income := 0.0
    var total_expenses := 0.0
    
    for source in income_sources.values():
        total_income += source
    
    for source in expense_sources.values():
        total_expenses += source
    
    var profit := total_income - total_expenses
    financial_update.emit(profit, total_income, total_expenses)
    return profit
```

---
