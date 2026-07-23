class_name RevivalAutoSaveManager
extends Node

## Expert Auto-Save Bridge.
## Triggers the global Save System when a new checkpoint is reached.

func _on_checkpoint_activated() -> void:
	if has_node("/root/SaveManager"):
		get_node("/root/SaveManager").save_game()
		print("Checkpoint Auto-Saved.")

## Rule: In modern ARPGs/Platformers, checkpoints should ALWAYS trigger an auto-save.
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html — checkpoint-triggered auto-save
# - https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html — SaveManager Autoload bridge
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md — implement SaveManager.save_game
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — what payload the auto-save writes
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-mechanic-revival/SKILL.md
# =============================================================================
