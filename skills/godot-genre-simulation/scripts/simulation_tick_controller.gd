extends Node
class_name SimulationTickController

## Expert Simulation Controller (Godot 4.7).
## Decoupled simulation 'ticks' with independent time scaling.

signal sim_tick

@onready var tick_timer: Timer = $TickTimer

func set_speed(multiplier: float) -> void:
	if multiplier <= 0:
		tick_timer.paused = true
	else:
		tick_timer.paused = false
		# Expert Pattern: Scale frequency by dividing base interval
		tick_timer.wait_time = 1.0 / multiplier

func _on_tick_timer_timeout() -> void:
	sim_tick.emit()

## [SKILL NOTICE]: Use a dedicated 'Timer' for simulation steps. 
## This allows the game to run at 2x or 5x speed without affecting 
## visual frame rates or audio.
