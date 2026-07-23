# run_manager.gd
extends Node

signal run_started
signal run_ended(victory: bool)
signal floor_changed(new_floor: int)

var current_seed: int
var current_floor: int = 1
var player_stats: Dictionary = {}
var inventory: Array[Resource] = []
var rng: RandomNumberGenerator

func start_run(seed_val: int = -1) -> void:
    rng = RandomNumberGenerator.new()
    if seed_val == -1:
        rng.randomize()
        current_seed = rng.seed
    else:
        current_seed = seed_val
        rng.seed = current_seed
        
    current_floor = 1
    _reset_run_state()
    run_started.emit()

func _reset_run_state() -> void:
    player_stats = { "hp": 100, "gold": 0 }
    inventory.clear()

func next_floor() -> void:
    current_floor += 1
    floor_changed.emit(current_floor)
    
func end_run(victory: bool) -> void:
    run_ended.emit(victory)
    # Trigger meta-progression save here
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-roguelike/SKILL.md
# =============================================================================
