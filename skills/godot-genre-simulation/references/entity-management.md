# Entity Management

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
