extends Node

## Expert Minigame Orchestrator (Godot 4.7).
## State-driven transitions between minigames.

enum Phase { INTRO, PLAY, RESULTS }
var current_phase = Phase.INTRO

func start_game() -> void:
	current_phase = Phase.PLAY
	# Start gameplay timer...

func end_game(winner_id: int) -> void:
	current_phase = Phase.RESULTS
	# Update persistent score (Autoload)
	# ScoreManager.add_score(winner_id, 1)
	
	# Transition back to main board or next game
	get_tree().change_scene_to_file("res://scenes/results_screen.tscn")

## [SKILL NOTICE]: Use 'get_tree().change_scene_to_file()' to 
## ensure clean memory teardown between unrelated minigames.
