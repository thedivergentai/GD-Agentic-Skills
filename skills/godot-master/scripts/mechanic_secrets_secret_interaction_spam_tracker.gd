class_name SecretInteractionSpamTracker
extends Node

## Expert Interaction Spam Tracker.
## Triggers events based on repetitive clicks or actions (e.g. NPC dialogue secrets).

signal secret_spam_triggered

@export var required_interactions: int = 50
@export var reset_on_exit: bool = true

var interaction_count: int = 0

func interact() -> void:
	interaction_count += 1
	if interaction_count >= required_interactions:
		secret_spam_triggered.emit()
		interaction_count = 0 # Optional reset

func reset() -> void:
	if reset_on_exit:
		interaction_count = 0

## Tip: Use 'Interaction Spam' for Easter Eggs that reward player persistence/curiosity.

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/inputs/input_examples.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html
# - https://docs.godotengine.org/en/stable/tutorials/math/random_number_generation.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — secret_spam_triggered routing
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-dialogue-system/SKILL.md — NPC poke-count Easter eggs
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-mechanic-secrets/SKILL.md
# =============================================================================
