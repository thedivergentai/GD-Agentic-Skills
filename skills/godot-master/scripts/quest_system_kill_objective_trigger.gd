# kill_objective_trigger.gd
# Decoupled quest trigger via signals
extends Node

# EXPERT NOTE: Use a generic trigger script that listens to game events 
# (like an EventBus) to avoid hardcoding quest logic into enemies.

@export var target_enemy_id: String = ""
@export var quest_id: String = ""

func _ready():
	# Assumes a GlobalEventBus exits
	if get_tree().root.has_node("GlobalBus"):
		var bus = get_node("/root/GlobalBus")
		bus.enemy_defeated.connect(_on_enemy_defeated)

func _on_enemy_defeated(enemy_id: String, _points: int):
	if enemy_id == target_enemy_id:
		QuestManager.update_objective(quest_id)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/instancing_with_signals.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# - https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — EventBus enemy_defeated without hardcoding quests in enemies
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-combat-system/SKILL.md — death/defeat payloads that feed kill objectives
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-quest-system/SKILL.md
# =============================================================================
