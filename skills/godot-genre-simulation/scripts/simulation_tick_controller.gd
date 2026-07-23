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
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_timer.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — sim_tick consumers without polling
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — speed multipliers vs visual FPS
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-simulation/SKILL.md
# =============================================================================
