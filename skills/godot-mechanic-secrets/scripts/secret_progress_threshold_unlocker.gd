class_name SecretProgressThresholdUnlocker
extends Node

## Expert Progress-Based Secret Trigger.
## Unlocks hidden content when game completion % reaches a threshold.

@export var required_completion_percent: float = 100.0

func check_unlock() -> bool:
	var current_percent = GlobalStats.get_completion_percent()
	if current_percent >= required_completion_percent:
		_perform_unlock()
		return true
	return false

func _perform_unlock() -> void:
	print("Secret True Ending Unlocked.")

## Tip: Use '100% Completion' triggers specifically for non-gameplay meta-content (e.g., concept art).

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-quest-system/SKILL.md — completion % → true-ending gates
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md — simulate threshold reach rates
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-mechanic-secrets/SKILL.md
# =============================================================================
