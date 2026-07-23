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
