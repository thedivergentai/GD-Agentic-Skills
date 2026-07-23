# Time System

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
