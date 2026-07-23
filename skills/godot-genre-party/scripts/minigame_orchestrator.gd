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
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/change_scenes_manually.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — phase INTRO/PLAY/RESULTS transitions
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-turn-system/SKILL.md — return to board/meta after results
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-party/SKILL.md
# =============================================================================
