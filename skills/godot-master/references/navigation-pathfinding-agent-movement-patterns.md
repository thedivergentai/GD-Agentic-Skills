# Agent movement patterns (2D/3D)

> Editor intro / first NavigationRegion bake → Official Docs. This file keeps chase/patrol/signal recipes removed from SKILL.md.

### 2D Navigation

```gdscript

## NavigationAgent Properties

```gdscript

## Advanced Patterns

### Chase Player

```gdscript
extends CharacterBody2D

@onready var nav_agent := $NavigationAgent2D
@export var speed := 150.0
@export var chase_range := 300.0

var player: Node2D

func _physics_process(delta: float) -> void:
    if not player:
        return
    
    var distance := global_position.distance_to(player.global_position)
    
    if distance <= chase_range:
        nav_agent.target_position = player.global_position
        
        if not nav_agent.is_navigation_finished():
            var next_pos := nav_agent.get_next_path_position()
            var direction := (next_pos - global_position).normalized()
            velocity = direction * speed
            move_and_slide()
```

### Patrol Points

```gdscript
extends CharacterBody2D

@onready var nav_agent := $NavigationAgent2D
@export var patrol_points: Array[Vector2] = []
@export var speed := 100.0

var current_point_index := 0

func _ready() -> void:
    if patrol_points.size() > 0:
        nav_agent.target_position = patrol_points[0]

func _physics_process(delta: float) -> void:
    if nav_agent.is_navigation_finished():
        _go_to_next_patrol_point()
        return
    
    var next_pos := nav_agent.get_next_path_position()
    var direction := (next_pos - global_position).normalized()
    velocity = direction * speed
    move_and_slide()

func _go_to_next_patrol_point() -> void:
    current_point_index = (current_point_index + 1) % patrol_points.size()
    nav_agent.target_position = patrol_points[current_point_index]
```

## 3D Navigation

```gdscript
extends CharacterBody3D

@onready var nav_agent := $NavigationAgent3D
@export var speed := 5.0

func _physics_process(delta: float) -> void:
    if nav_agent.is_navigation_finished():
        return
    
    var next_position := nav_agent.get_next_path_position()
    var direction := (next_position - global_position).normalized()
    
    velocity = direction * speed
    move_and_slide()
```

## Dynamic Obstacles

```gdscript

## Signals

```gdscript
func _ready() -> void:
    nav_agent.velocity_computed.connect(_on_velocity_computed)
    nav_agent.navigation_finished.connect(_on_navigation_finished)

func _on_velocity_computed(safe_velocity: Vector2) -> void:
    velocity = safe_velocity
    move_and_slide()

func _on_navigation_finished() -> void:
    print("Reached destination")
```

## Best Practices

### 1. Defer Navigation Setup

```gdscript
