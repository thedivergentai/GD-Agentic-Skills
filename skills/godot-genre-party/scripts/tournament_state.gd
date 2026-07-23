# tournament_state.gd
extends Node
# Configured as an Autoload named 'TournamentState'

# Global Tournament State (Autoload)
# Persists scores and round progression across minigame scene switches.

var player_scores: Dictionary = {} # player_id -> score
var current_round: int = 1
var active_players: Dictionary = {} # device_id mapping

func award_points(player_id: int, points: int) -> void:
    player_scores[player_id] = player_scores.get(player_id, 0) + points

func reset_tournament() -> void:
    player_scores.clear()
    current_round = 1
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/autoloads_versus_regular_nodes.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md — scores/rounds outside minigame trees
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — retune point awards / 1v3 offsets
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-turn-system/SKILL.md — round counter drives board turns
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-party/SKILL.md
# =============================================================================
