# lap_tracker.gd
extends Node
class_name LapTracker

# Lap/Time Tracking with Validation
# Sequential checkpoint checks to prevent "cheating" by reversing through the start.

signal lap_completed(total_time: float)

var current_lap := 1
var next_checkpoint_idx := 0
var lap_start_time := 0.0
var checkpoints: Array[Node3D] = []

func _ready() -> void:
    lap_start_time = Time.get_ticks_msec() / 1000.0

func on_checkpoint_passed(checkpoint: Node3D) -> void:
    var idx = checkpoints.find(checkpoint)
    
    # Pattern: Validate sequence to stop lap-shortcuts.
    if idx == next_checkpoint_idx:
        next_checkpoint_idx += 1
        if next_checkpoint_idx >= checkpoints.size():
            _complete_lap()

func _complete_lap() -> void:
    var end_time = Time.get_ticks_msec() / 1000.0
    var lap_time = end_time - lap_start_time
    lap_completed.emit(lap_time)
    
    current_lap += 1
    next_checkpoint_idx = 0
    lap_start_time = end_time
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/classes/class_area3d.html
# - https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — lap_completed signal graph
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — lap-time fairness sampling
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-racing/SKILL.md
# =============================================================================
