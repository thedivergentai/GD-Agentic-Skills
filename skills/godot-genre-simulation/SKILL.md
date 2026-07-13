---
name: godot-genre-simulation
description: "Expert blueprint for simulation and tycoon games (SimCity, RollerCoaster Tycoon, Factorio, Two Point Hospital) covering economy management, time progression, interconnected systems, NPC simulation, and feedback loops. Use when building management sims, tycoon games, city builders, or resource optimization games. Keywords tycoon, economy system, resource management, time scale, feedback loop, progression unlock, simulation tick."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Genre: Simulation / Tycoon

Optimization, systems mastery, and satisfying feedback loops define management games.

## NEVER Do (Expert Anti-Patterns)

### Simulation & Economy
- NEVER use floating-point for primary currency; strictly use **Integer Cents** (or fixed-point math) to prevent accumulated precision errors in financial models.
- NEVER process 1000+ entities individually in `_process()`; strictly use a **Tick Manager** to batch updates or process entities in rotating pools.
- NEVER rely on linear cost scaling; strictly use **Exponential Growth** (`Base * pow(1.15, Level)`) to maintain challenge and strategic tension.
- NEVER hide critical metrics from the player; strictly provide **Detailed Breakdowns** (Income vs. Expense) so players can make optimization-based decisions.
- NEVER allow infinite resource stacking; strictly enforce **Logistical Caps** (warehouses/silos) to create meaningful space-management gameplay loops.
- NEVER let the early game become a "Waiting Simulator"; strictly **Front-Load Decisions** and quick early wins to build player momentum.
- NEVER modify a shared Resource directly; strictly use **`duplicate()`** to avoid unintentionally updating every building of that type.
- NEVER tie simulation logic to the visual framerate; strictly use **`_physics_process()`** or delta accumulators for deterministic simulation results.

### Performance & Threading
- NEVER update UI labels every frame; strictly use **Event-Driven Signals** to refresh UI ONLY when the underlying data changes.
- NEVER run heavy economic loops synchronously; strictly use **WorkerThreadPool** to offload complex calculations and prevent UI stutters.
- NEVER store massive resource data as Nodes; strictly use **`RefCounted`** or **Data Resources** to avoid the memory/CPU overhead of the SceneTree.
- NEVER ignore **`OS.low_processor_usage_mode`**; strictly enable it for stationary management screens to save massive CPU/Battery life.
- NEVER manipulate the SceneTree from background threads; strictly use **`call_deferred()`** for thread-safe UI updates.
- NEVER parse large JSON save files on the main thread; strictly use **Threaded Serialization** or optimized binary `.res` formats.
- NEVER use standard equality (==) for needs; strictly use **`is_equal_approx()`** to prevent floating-point jitter failures in logic gates.

---

## 🛠 Expert Components (scripts/)

### Original Expert Patterns
- [sim_tick_manager.gd](scripts/sim_tick_manager.gd) - Variable-speed tick system decoupling simulation from rendering.
- [tycoon_economy.gd](scripts/tycoon_economy.gd) - Multi-resource economic engine with integer-precision currency.

### Modular Components
- [simulation_patterns.gd](scripts/simulation_patterns.gd) - Reusable patterns: AStarGrid2D logistics and low-processor modes.

---

## Economy Design

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

## Time System

Simulation games need controllable time:

```gdscript
class_name SimulationTime
extends Node

signal time_tick(delta_game_hours: float)
signal day_changed(day: int)
signal speed_changed(new_speed: int)

enum Speed { PAUSED, NORMAL, FAST, ULTRA }

@export var seconds_per_game_hour := 30.0  # Real seconds

var current_speed := Speed.NORMAL
var speed_multipliers := {
    Speed.PAUSED: 0.0,
    Speed.NORMAL: 1.0,
    Speed.FAST: 3.0,
    Speed.ULTRA: 10.0
}

var current_hour := 8.0  # Start at 8 AM
var current_day := 1

func _process(delta: float) -> void:
    if current_speed == Speed.PAUSED:
        return
    
    var game_delta := (delta / seconds_per_game_hour) * speed_multipliers[current_speed]
    current_hour += game_delta
    
    if current_hour >= 24.0:
        current_hour -= 24.0
        current_day += 1
        day_changed.emit(current_day)
    
    time_tick.emit(game_delta)

func set_speed(speed: Speed) -> void:
    current_speed = speed
    speed_changed.emit(speed)
```

---

## Entity Management

### Workers/NPCs

```gdscript
class_name Worker
extends Node

enum State { IDLE, WORKING, RESTING, COMMUTING }

@export var wage_per_hour: float = 10.0
@export var skill_level: float = 1.0  # Productivity multiplier
@export var morale: float = 80.0  # 0-100

var current_state := State.IDLE
var assigned_workstation: Workstation

func update(game_hours: float) -> void:
    match current_state:
        State.WORKING:
            if assigned_workstation:
                var productivity := skill_level * (morale / 100.0)
                assigned_workstation.work(game_hours * productivity)
                morale -= game_hours * 0.5  # Working tires workers
        State.RESTING:
            morale = min(100.0, morale + game_hours * 2.0)

func calculate_hourly_cost() -> float:
    return wage_per_hour
```

### Buildings/Facilities

```gdscript
class_name Facility
extends Node3D

@export var build_cost: Dictionary  # resource_type: amount
@export var operating_cost_per_hour: float = 5.0
@export var capacity: int = 5
@export var output_per_hour: Dictionary  # resource_type: amount

var assigned_workers: Array[Worker] = []
var is_operational := true
var efficiency := 1.0

func calculate_output(game_hours: float) -> Dictionary:
    if not is_operational or assigned_workers.is_empty():
        return {}
    
    var worker_efficiency := 0.0
    for worker in assigned_workers:
        worker_efficiency += worker.skill_level * (worker.morale / 100.0)
    worker_efficiency /= capacity  # Normalize to 0-1
    
    var result := {}
    for resource in output_per_hour:
        result[resource] = output_per_hour[resource] * game_hours * worker_efficiency * efficiency
    return result
```

---

## Customer/Demand System

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

## Feedback Systems

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

## Progression & Unlocks

```gdscript
class_name UnlockSystem
extends Node

var unlocks: Dictionary = {
    "basic_facility": true,
    "advanced_facility": false,
    "marketing": false,
    "automation": false
}

var unlock_conditions: Dictionary = {
    "advanced_facility": {"money_earned": 50000},
    "marketing": {"reputation": 70},
    "automation": {"workers_hired": 20}
}

var progress: Dictionary = {
    "money_earned": 0.0,
    "workers_hired": 0
}

func check_unlocks() -> Array[String]:
    var newly_unlocked: Array[String] = []
    
    for unlock in unlock_conditions:
        if unlocks[unlock]:
            continue  # Already unlocked
        
        var conditions := unlock_conditions[unlock]
        var all_met := true
        
        for condition in conditions:
            if progress.get(condition, 0) < conditions[condition]:
                all_met = false
                break
        
        if all_met:
            unlocks[unlock] = true
            newly_unlocked.append(unlock)
    
    return newly_unlocked
```

---

## Common Pitfalls

| Pitfall | Solution |
|---------|----------|
| Economy too easy to break | Extensive balancing, soft caps, diminishing returns |
| Boring early game | Front-load interesting decisions, quick early progression |
| Information overload | Progressive disclosure, collapsible UI panels |
| No clear goals | Milestones, achievements, scenarios |
| Tedious micromanagement | Automation unlocks, batch operations |

---

## Godot-Specific Tips

1. **UI**: Use `Control` nodes extensively, `Tree` for lists, `GraphEdit` for connections
2. **Performance**: Process entities in batches, not every frame
3. **Save/Load**: Convert all game state to Dictionary for JSON serialization
4. **Isometric view**: Use `Camera2D` with orthographic projection


---

## 🚀 Elite Technical Implementations (Batch 09)

### 1. Dependency-Graph Pattern (Production Chains)
Represent complex production chains (e.g., Raw Materials -> Intermediate -> Finished Goods) using nested `Resource` structures. This allows for deep, recursive data definitions that are fully editable in the Inspector.

```gdscript
# production_recipe.gd
class_name ProductionRecipe extends Resource

## Mapping of required ItemResources to their integer quantities
@export var required_inputs: Dictionary[ItemResource, int] = {}
@export var output_item: ItemResource
@export var output_yield: int = 1
@export var production_time: float = 5.0

## Evaluates if the current inventory meets the graph dependencies
func can_produce(available_inventory: Dictionary[ItemResource, int]) -> bool:
    for input_item in required_inputs:
        var required_amount: int = required_inputs[input_item]
        var available_amount: int = available_inventory.get(input_item, 0)
        if available_amount < required_amount:
            return false
    return true
```

### 2. AStarGrid2D for Logistics & NPC Jobs
`AStarGrid2D` is specialized for 2D grids, eliminating the need to manually connect points. It is ideal for factory floors, warehouse logistics, and NPC pathfinding in management sims.

```gdscript
class_name LogisticsGrid extends Node

var _astar_grid: AStarGrid2D

func _ready() -> void:
    _astar_grid = AStarGrid2D.new()
    _astar_grid.region = Rect2i(0, 0, 100, 100)
    _astar_grid.cell_size = Vector2(32, 32)
    _astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
    _astar_grid.update()

## Mark a cell as impassable (e.g., placing a new machine)
func place_obstacle(cell_coords: Vector2i) -> void:
    if _astar_grid.is_in_bounds(cell_coords.x, cell_coords.y):
        _astar_grid.set_point_solid(cell_coords, true)

## Retrieves the logistics path for an NPC worker
func get_npc_path(start_cell: Vector2i, target_cell: Vector2i) -> Array[Vector2i]:
    return _astar_grid.get_id_path(start_cell, target_cell)
```

### 3. CSV-to-Resource Workflow (Rapid Balancing)
Automate the conversion of spreadsheet data (CSV) into native `.tres` files. This allows game designers to balance thousands of entities in Excel/Google Sheets and "bake" them into performant Godot resources.

```gdscript
@tool
class_name CSVResourceBaker extends EditorScript

func _run() -> void:
    var csv_path := "res://data/balancing_sheet.csv"
    var output_dir := "res://data/generated_items/"
    
    var file := FileAccess.open(csv_path, FileAccess.READ)
    if not file: return
        
    var rows := file.get_as_text().split("\n", false)
    for i in range(1, rows.size()): # Skip header
        var columns := rows[i].split(",", false)
        if columns.size() < 2: continue
            
        var item_name: String = columns[0].strip_edges()
        var base_value: int = columns[1].to_int()
        
        var new_item := ItemResource.new()
        new_item.item_name = item_name
        new_item.base_value = base_value
        
        ResourceSaver.save(new_item, output_dir + item_name.to_lower() + ".tres")
```


- Master Skill: [godot-master](../godot-master/SKILL.md)
