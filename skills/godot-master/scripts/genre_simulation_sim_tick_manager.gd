# skills/genre-simulation/scripts/sim_tick_manager.gd
extends Node

## Sim Tick Manager (Expert Pattern)
## Delta accumulator on _physics_process — never visual-framerate sim steps.

class_name SimTickManager

signal tick(day: int, hour: int)
signal speed_changed(new_speed: int)

enum Speed { PAUSED = 0, NORMAL = 1, FAST = 2, SUPER_FAST = 5 }

var current_speed: int = Speed.NORMAL
var _accumulated_time: float = 0.0
const SECONDS_PER_GAME_HOUR: float = 2.0

var game_hour: int = 8
var game_day: int = 1

func _physics_process(delta: float) -> void:
	if current_speed == Speed.PAUSED:
		return
	_accumulated_time += delta * float(current_speed)
	while _accumulated_time >= SECONDS_PER_GAME_HOUR:
		_accumulated_time -= SECONDS_PER_GAME_HOUR
		_advance_hour()

func _advance_hour() -> void:
	game_hour += 1
	if game_hour >= 24:
		game_hour = 0
		game_day += 1
	tick.emit(game_day, game_hour)

func set_speed(speed: int) -> void:
	current_speed = speed
	speed_changed.emit(current_speed)

func pause() -> void:
	set_speed(Speed.PAUSED)

## EXPERT USAGE:
## Connect Economy and AI to tick. NEVER step economy inside _process.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — tick buses for economy/AI listeners
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — TimeManager ownership across scenes
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-simulation/SKILL.md
# =============================================================================
