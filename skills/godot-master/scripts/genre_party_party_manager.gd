# party_manager.gd
extends Node

var players: Array[PlayerData] = [] # Tracks score, input_device_id, color
var current_round: int = 1
var max_rounds: int = 10

func start_minigame(minigame: MinigameData) -> void:
    # 1. Show instructions scene
    await show_instructions(minigame)
    # 2. Transition to actual game
    get_tree().change_scene_to_file(minigame.scene_path)
    # 3. Pass player data to the new scene
    # (The minigame scene must look up PartyManager in _ready)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-party/SKILL.md
# =============================================================================
